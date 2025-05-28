;--------------------------------------------------------------------------
;  crt0.s - Generic crt0.s for a Z80
;
;  Copyright (C) 2000, Michael Hope
;
;  This library is free software; you can redistribute it and/or modify it
;  under the terms of the GNU General Public License as published by the
;  Free Software Foundation; either version 2, or (at your option) any
;  later version.
;
;  This library is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License 
;  along with this library; see the file COPYING. If not, write to the
;  Free Software Foundation, 51 Franklin Street, Fifth Floor, Boston,
;   MA 02110-1301, USA.
;
;  As a special exception, if you link this library with other files,
;  some of which are compiled with SDCC, to produce an executable,
;  this library does not by itself cause the resulting executable to
;  be covered by the GNU General Public License. This exception does
;  not however invalidate any other reasons why the executable file
;  might be covered by the GNU General Public License.
;--------------------------------------------------------------------------

;;;-----------------------------------------------------------------------
;;; INTERRUPT HANDLERS & VECTORS
;;; HARDWARE DRIVERS FOR 8251/8259
;;;    BY ARMCODER - 2025
;;;-----------------------------------------------------------------------

RAMTOP		.equ 0x10000
STACKTOP	.equ RAMTOP - 0x100
isr0vector	.equ STACKTOP
isr1vector	.equ STACKTOP+2
isr2vector	.equ STACKTOP+4
isr3vector	.equ STACKTOP+6
isr4vector	.equ STACKTOP+8
isr5vector	.equ STACKTOP+10
isr6vector	.equ STACKTOP+12
isr7vector	.equ STACKTOP+14
BUFRXSIZE	.equ 0x80
bufrx		.equ STACKTOP+16
bufrxins	.equ bufrx+BUFRXSIZE
bufrxget	.equ bufrxins+1
bufrxqty	.equ bufrxget+1

timecount	.equ RAMTOP-2

PORTLEDS	.equ 0x00

PORT8259_A00	.equ 0x30
PORT8259_A01	.equ 0x31

PORT8251_DATA	.equ 0x20
PORT8251_CTRL	.equ 0x21

	.module crt0
	.globl	_main

	.area	_HEADER (ABS)
	;; Reset vector
	.org 	0
	jp	init

	.org	0x08
	jp	tx_char	;reti
	.org	0x10
	jp	get_char ;reti
	.org	0x18
	reti
	.org	0x20
	reti
	.org	0x28
	reti
	.org	0x30
	reti

	;///////////////////////////////////////////////////////////////////////
	.org	0x38	; Used by 8259A

	push	af

next_poll:
	ld	a,#0b00001100	;OCW3_8259
	;             || | ``----> No register command
	;             || `-------> Poll command
	;             ``---------> No Special Mask command
	out	(PORT8259_A00),a

	in	a,(PORT8259_A00)	;Read int status
	bit	7,a
	jr	z,end38

	and	#0x07

	or	a
	jr	z,isr0			;RX RDY
	jr	testisr2

isr0:	push	hl			;TIMER
	ld	hl,#isrpopret
	push	hl
	ld	hl,(isr0vector)
	jp	(hl)

testisr2:
	cp	#2
	jr	nz,do_eoi

isr2:	push	hl			;TIMER
	ld	hl,#isrpopret
	push	hl
	ld	hl,(isr2vector)
	jp	(hl)

isrpopret:
	pop	hl

do_eoi:
	ld	a,#0b00100000	;OCW2_8259
	;            |||  ```----> Lvl 0 (don't care)
	;            ```---------> Non Specific EOI
	out	(PORT8259_A00),a

	jr	next_poll		; Check other pending INTs, if ever

end38:
	pop	af
	ei
	reti

	;///////////////////////////////////////////////////////////////////////
	.org	0x100
init:
	;; Stack at the top of memory.
	ld	sp,#STACKTOP
	ld	hl,#default_isr
	ld	(isr1vector),hl
	ld	hl,#rx_isr
	ld	(isr0vector),hl
	ld	hl,#timer_isr
	ld	(isr2vector),hl
	ld	a,#0xf0
	ld	(timecount),a

	xor	a
	ld	(bufrxins),a
	ld	(bufrxget),a
	ld	(bufrxqty),a

	;; Initialize 8251
	;out	(PORT8251_CTRL),a

	ld	a,#0b01001110		;Mode config
	;            ||||||``----> Async 16X
	;            ||||``------> Char length 8 bits
	;            |||`--------> Parity disabled
	;            ||`---------> Parity odd (unused)
	;            ``----------> 1 Stop bit
	out	(PORT8251_CTRL),a

	ld	a,#0b00110101
	;            |||||||`----> Transmit enable
	;            ||||||`-----> Don't set DTR
	;            |||||`------> Receive enable
	;            ||||`-------> Don't send Break
	;            |||`--------> Error reset
	;            ||`---------> Set RTS
	;            |`----------> No Reset CMD
	;            `-----------> No Hunt Mode
	out	(PORT8251_CTRL),a
	
	;; Initialize 8259
	ld	a,#0b00010110	;ICW1_8259
	;            |||||||`----> ICW4 not needed
	;            ||||||`-----> Single chip
	;            |||||`------> Call Interval 4
	;            ||||`-------> Edge trigger
	;            |||`--------> ICW1 marker
	;            ```---------> A7A6A5 = 000 -> base=0x0000 (not used, we'll use IM1)
	out	(PORT8259_A00),a

	ld	a,#0b00000000	;ICW2_8259
	;            ````````----> A15-A8 = 0 (not used, we'll use IM1)
	out	(PORT8259_A01),a
	
	ld	a,#0b00000000	;ICW3_8259
	;            ````````----> No input have slaves
	out	(PORT8259_A01),a

        ;; Initialise global variables
        call    gsinit
        
	im	1
	ei
	
	ld	hl,#signon
	call	prints
	call	_main
	di
	halt

signon:
	.db	13,10
	.ascii	'Kraft 80 - Z80 Computer'
	.db	13,10,0
	
	;///////////////////////////////////////////////////////////////////////
prints:
	ld	a,(hl)
	or	a
	ret	z
	call	tx_char
	inc	hl
	jr	prints

	;///////////////////////////////////////////////////////////////////////
tx_char:
	out	(PORT8251_DATA),a
wait_tx:
	in	a,(PORT8251_CTRL)
	;out	(PORTLEDS),a
	bit	0,a
	jr	z,wait_tx
	ret

	;///////////////////////////////////////////////////////////////////////
timer_isr:
	ld	a,(timecount)
	inc	a
	ld	(timecount),a
	ret

	;///////////////////////////////////////////////////////////////////////
rx_isr:
	ld	a,(bufrxqty)
	cp	#BUFRXSIZE
	jr	nz,rx_isr1
	in	a,(PORT8251_DATA)
	ret
	
rx_isr1:
	inc	a
	cp	#(BUFRXSIZE-16)
	jr	nz,rx_isr1a
	
	push	af
	ld	a,#0b00000101
	;            |||||||`----> Transmit enable
	;            ||||||`-----> Don't set DTR
	;            |||||`------> Receive enable
	;            ||||`-------> Don't send Break
	;            |||`--------> No error reset
	;            ||`---------> Clear RTS
	;            |`----------> No Reset CMD
	;            `-----------> No Hunt Mode
	out	(PORT8251_CTRL),a
	pop	af
	
rx_isr1a:	
	ld	(bufrxqty),a
	ld	a,(bufrxins)
	push	bc
	ld	c,a
	ld	b,#0
	ld	hl,#bufrx
	add	hl,bc
	in	a,(PORT8251_DATA)
	ld	(hl),a
	ld	a,c
	pop	bc

	inc	a
	cp	#BUFRXSIZE
	jr	c,rx_isr2
	xor	a

rx_isr2:
	ld	(bufrxins),a

default_isr:
	ret

	;///////////////////////////////////////////////////////////////////////
get_char:
	di
	ld	a,(bufrxqty)
	or	a
	jr	nz,get_char0
	ei
	ret		;; No char available, return Z

get_char0:
	dec	a
	ld	(bufrxqty),a

	cp	#8
	jr	nz,get_char2

	ld	a,#0b00100101
	;            |||||||`----> Transmit enable
	;            ||||||`-----> Don't set DTR
	;            |||||`------> Receive enable
	;            ||||`-------> Don't send Break
	;            |||`--------> No error reset
	;            ||`---------> Set RTS
	;            |`----------> No Reset CMD
	;            `-----------> No Hunt Mode
	out	(PORT8251_CTRL),a

get_char2:
	push	hl

	push	bc
	ld	a,(bufrxget)
	ld	c,a
	ld	b,#0
	ld	hl,#bufrx
	add	hl,bc
	pop	bc

	inc	a
	cp	#BUFRXSIZE
	jr	nz,get_char1	;; Condition NZ

	xor	a
	cp	#1		;; Force condition NZ

get_char1:
	ld	(bufrxget),a
	
	ld	a,(hl)
	pop	hl

	ei
	ret			;; Always return NZ

	;///////////////////////////////////////////////////////////////////////
gsinit:
	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	Z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir
gsinit_next:
        ret

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
	.area	_INITIALIZER
	.area   _GSINIT
	.area   _GSFINAL
        .area   _MAIN
	.area	_DATA
	.area	_INITIALIZED
	.area	_BSEG
	.area   _BSS
	.area   _HEAP

	.area   _CODE

	.area   _GSFINAL

