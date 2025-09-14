;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  INVADERS FOR KRAFT 80
;  A mini game inspired on Taito's Space Invaders
;  Rev 1.0
;  04-Jul-2025 - ARMCoder
;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PORTBUTTONS	.equ	0x00	
PORTDATA	.equ	0x50
PORTADDRL	.equ	0x51
PORTADDRH	.equ	0x52
PORTMODE	.equ	0x53


INVADER_COLS	.equ	11
INVADER_ROWS	.equ	5
INVADER_NUM	.equ	(INVADER_COLS*INVADER_ROWS)	
INVADERS_VSPACING .equ	8

PLAYFIELD_WIDTH	.equ	224

PLAY_WIDTH_BYTES .equ	(PLAYFIELD_WIDTH/2)
VSTEP		.equ	12
VSTEP2		.equ	INVADERS_VSPACING


BYTES_PER_LINE	.equ	160

LEFT_OFFSET_BYTES .equ	(BYTES_PER_LINE - PLAY_WIDTH_BYTES)/2


CANNON_VPOS	.equ	220
CANNON_SCR_OFS	.equ	(BYTES_PER_LINE*CANNON_VPOS+LEFT_OFFSET_BYTES)
BLINE_SCR_OFS	.equ	(BYTES_PER_LINE*(10+CANNON_VPOS)+LEFT_OFFSET_BYTES)

BUNKER1_SCR_OFS	.equ	(BYTES_PER_LINE*(CANNON_VPOS-24)+16+LEFT_OFFSET_BYTES)
BUNKER2_SCR_OFS	.equ	(BUNKER1_SCR_OFS+23)
BUNKER3_SCR_OFS	.equ	(BUNKER2_SCR_OFS+23)
BUNKER4_SCR_OFS	.equ	(BUNKER3_SCR_OFS+23)

INV_DIVIDER_INI	 .equ	550
INV_DIVIDER_DROP .equ	10

NUM_BOMBS	.equ	8

USE_KRAFTMON	.equ	0

		.area	_HEADER (ABS)

		.if	USE_KRAFTMON == 1

isr2vector	.equ	0xff04	;STACKTOP+4

		.org 0x2100

		.else

isr2vector	.equ	0x4104	;STACKTOP+4

		.org 0x4200

		.endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

invaders:	ld	a,#1
		out	(PORTMODE),a

		ld	hl,(isr2vector)
		ld	(isr2vector_copy),hl
		di
		ld	hl,#timer_isr
		ld	(isr2vector),hl
		ei

		ld	hl,#150
		ld	(timer_invaders),hl
wait_init:	ld	hl,(timer_invaders)
		ld	a,h
		or	l
		jr	nz,wait_init

		call	clrscr
		
		ld	hl,#BLINE_SCR_OFS
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	b,#PLAY_WIDTH_BYTES
		ld	a,#0xcc		;lightred
bline:		out	(PORTDATA),a
		djnz	bline
		
		call	init_vars1
		
		call	init_vars2
		call	print_cannon

		call	print_invaders

loop_invaders:	call	move_cannon
		call	move_invaders
		call	move_missile
		call	newbomb
		call	move_bombs
		call	lfsr_update
		jr	loop_invaders

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

init_vars1:	ld	a,#(PLAYFIELD_WIDTH/2) - 8
		ld	(cannon_hpos_px),a

		xor	a
		ld	(missile_act),a
		ld	(timer_missile),a

		ld	b,#NUM_BOMBS
		ld	ix,#bomb_basedata
init_vars1a:	ld	_BOMB_ACT(ix),a
		inc	ix
		djnz	init_vars1a

		ld	(timer_bombs),a
		ld	(timer_newbomb),a

		ld	hl,#0x51af
		ld	(lfsr_data),hl

		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

init_vars2:	call	print_bunkers

		ld	hl,#invader_matrix
		ld	a,#1
		ld	b,#INVADER_NUM
init_var1:	ld	(hl),a
		inc	hl
		djnz	init_var1

		ld	a,#INVADER_NUM
		ld	(invader_count),a

		xor	a
		ld	(col_start),a
		ld	(stepping),a
		ld	(hdir_invaders),a
		
		ld	a,#INVADER_COLS-1
		ld	(col_end),a
		ld	a,#INVADER_ROWS-1
		ld	(row_end),a

		ld	hl,#INV_DIVIDER_INI
		ld	(invaders_divider),hl
		ld	(timer_div),hl

		ld	a,#24
		ld	(row_invaders),a
		ld	a,#32
		ld	(col_invaders_px),a

		ld	hl,#0
		ld	(timer_invaders),hl

		call	update_scrpos

		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

check_hit:	ld	b,#INVADER_ROWS		

		ld	hl,#invader_matrix
		ld	a,(col_start)
		ld	e,a
		ld	d,#0
		add	hl,de

		ld	a,(row_invaders)
		ld	d,a
		add	a,#8
		ld	e,a

scan_invrows:	ld	a,(missile_vpos)
		cp	d
		jr	c,invr_nf
		cp	e
		jr	nc,invr_nf

		jr	invr_foundrow

invr_nf:	ld	a,d
		add	#(8+INVADERS_VSPACING)
		ld	d,a
		
		ld	a,e
		add	#(8+INVADERS_VSPACING)
		ld	e,a

		push	de
		ld	de,#INVADER_COLS
		add	hl,de
		pop	de

		djnz	scan_invrows
		ret

invr_foundrow:	ld	b,#INVADER_COLS

		ld	a,(col_invaders_px)
		ld	d,a
		add	a,#16
		ld	e,a

scan_invcols:	ld	a,(missile_hpos_px)
		cp	d
		jr	c,invr_nf2
		cp	e
		jr	nc,invr_nf2

		jr	invr_foundcol

invr_nf2:	ld	a,d
		add	#16
		ld	d,a
		
		ld	a,e
		add	#16
		ld	e,a

		inc	hl
		djnz	scan_invcols
		ret

invr_foundcol:	ld	a,(hl)
		or	a
		ret	z

		ld	(hl),#0

		call	print_invaders

		ld	hl,(invaders_divider)
		ld	de,#-INV_DIVIDER_DROP
		add	hl,de
		ld	(invaders_divider),hl

		ld	a,(invader_count)
		dec	a
		ld	(invader_count),a
		jr	nz,check_cols_r

		call	init_vars2
		call	print_invaders
		ret

check_cols_r:	ld	a,(col_end)
		ld	e,a
		ld	d,#0
		ld	hl,#invader_matrix
		add	hl,de
		ld	b,#INVADER_ROWS
		ld	e,#INVADER_COLS
check_cols_r2:	ld	a,(hl)
		or	a
		jr	nz,check_cols_l
		add	hl,de
		djnz	check_cols_r2
		ld	a,(col_end)
		dec	a
		ld	(col_end),a
		jr	check_cols_r
		
check_cols_l:	ld	a,(col_start)
		ld	e,a
		ld	hl,#invader_matrix
		add	hl,de
		ld	b,#INVADER_ROWS
		ld	e,#INVADER_COLS
check_cols_l2:	ld	a,(hl)
		or	a
		jr	nz,check_rows

		add	hl,de
		djnz	check_cols_l2
		ld	a,(col_start)
		inc	a
		ld	(col_start),a
		
		ld	a,(col_invaders_px)
		add	a,#16
		ld	(col_invaders_px),a
		call	update_scrpos
		
		jr	check_cols_l

check_rows:	ld	a,(row_end)
		or	a
		ret	z

		ld	b,a
		ld	hl,#invader_matrix+(INVADER_ROWS-1)*(INVADER_COLS)
		ld	de,#-INVADER_COLS
chkrow0:	add	hl,de
		djnz	chkrow0
		
		ld	a,(row_end)
		ld	c,a		

chkrow2:	ld	(invader_matnow),hl
		ld	b,#INVADER_COLS

chkrow1:	ld	a,(hl)
		or	a
		ret	nz

		inc	hl
		djnz	chkrow1

		ld	a,(row_end)
		dec	a
		ld	(row_end),a

		ld	hl,(invader_matnow)
		ld	de,#-INVADER_COLS
		add	hl,de

		dec	c
		jr	nz,chkrow2
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

update_scrpos:	ld	a,(row_invaders)	; Pixel line
		ld	hl,#0
		or	a
		jr	z,update1a
		ld	de,#BYTES_PER_LINE
update1:	add	hl,de
		dec	a
		jr	nz,update1
	
update1a:	ld	d,h
		ld	e,l
		ld	a,(col_invaders_px)
		srl	a
		ld	l,a
		ld	h,#0
		add	hl,de
		ld	de,#LEFT_OFFSET_BYTES
		add	hl,de
		ld	(scrpos_invaders),hl

		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

move_missile:	ld	a,(timer_missile)
		or	a
		ret	nz
		ld	a,#3
		ld	(timer_missile),a

		ld	a,(missile_act)
		cp	#1
		ret	nz

		ld	a,(missile_vpos)
		cp	#8
		jr	nc,movem1

		ld	a,#2
		ld	(missile_act),a
		ld	hl,(missile_scrpos)
		ld	c,#0
		jr	movem2

movem1:		dec	a
		dec	a
		ld	(missile_vpos),a
		
		ld	hl,(missile_scrpos)
		ld	de,#-(2*BYTES_PER_LINE)
		add	hl,de
		ld	(missile_scrpos),hl

		ld	a,(missile_pixmask)
		and	#0xee
		ld	c,a
		
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a

		ld	a,(missile_pixmask)
		ld	d,a
		in	a,(PORTDATA)
		and	d
		jr	z,movem2

		push	hl
		call	check_hit		; Missile hit something
		pop	hl
		
		ld	a,#2	
		ld 	(missile_act),a
		ld	c,#0
		
movem2:		ld	b,#5
		ld	de,#BYTES_PER_LINE

movem3:		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		push	bc
		in	a,(PORTDATA)
		ld	b,a
		ld	a,(missile_pixmask)
		cpl
		and	b
		or	c
		pop	bc
		out	(PORTDATA),a
		add	hl,de
		djnz	movem3

		ld	b,#2
		ld	a,(missile_pixmask)
		cpl
		ld	c,a
movem4:		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		in	a,(PORTDATA)
		and	c
		out	(PORTDATA),a
		add	hl,de
		djnz	movem4
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

move_invaders:	ld	hl,(timer_invaders)
		ld	a,h
		or	l
		ret	nz
		ld	hl,(invaders_divider)
		ld	(timer_invaders),hl
		
		ld	a,(stepping)
		ld	b,#1
		xor	b
		ld	(stepping),a

		ld	a,(hdir_invaders)
		or	a
		jr	z,moveright

		ld	a,(col_invaders_px)	; Moving left
		or	a
		jr	z,revdir
		
		dec	a
		dec	a
		ld	(col_invaders_px),a
		jr	movupd
		
moveright:
		ld	a,(col_start)
		ld	b,a
		ld	a,(col_end)
		sub	b
		inc	a
		add	a,a
		add	a,a
		add	a,a
		add	a,a
		ld	b,a
		ld	a,#PLAYFIELD_WIDTH
		sub	b
		ld	b,a
		ld	a,(col_invaders_px)
		cp	b
		jr	z,revdir

		inc	a
		inc	a
		ld	(col_invaders_px),a

movupd:		call	update_scrpos
		jp	print_invaders

revdir:		ld	a,(hdir_invaders)
		xor	#1
		ld	(hdir_invaders),a
		ld	a,(row_invaders)
		add	a,#VSTEP
		ld	(row_invaders),a
		call	update_scrpos
		call	print_invaders
		jp	clear_lines

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

move_cannon:	ld	a,(timer_cannon)
		or	a
		ret	nz
		
		ld	a,#4
		ld	(timer_cannon),a
		
		in	a,(PORTBUTTONS)
		ld	c,a
		bit	0,a
		jr	z,newmis1

		ld	a,(missile_act)
		cp	#2
		ld	a,c
		jr	nz,movec0
		xor	a
		ld	(missile_act),a
		ld	a,c
		jr	movec0
		
newmis1:	ld	a,(missile_act)
		or	a
		ld	a,c
		jr	nz,movec0

		ld	a,#1
		ld	(missile_act),a
		
		ld	a,#CANNON_VPOS
		sub	a,#5
		ld	(missile_vpos),a
		ld	a,(cannon_hpos_px)
		add	a,#7
		ld	(missile_hpos_px),a
		
		ld	b,#0x0f
		bit	0,a
		jr	z,newmis2
		ld	b,#0xf0

newmis2:	ld	d,a
		ld	a,b
		ld	(missile_pixmask),a

		ld	a,d
		srl	a
		ld	e,a
		ld	d,#0
		ld	hl,#CANNON_SCR_OFS-(5*BYTES_PER_LINE)
		add	hl,de

		ld	(missile_scrpos),hl
		ld	a,c
		
movec0:		bit	5,a
		jr	nz,movec1
		bit	7,a
		ret	z
		
		ld	a,(cannon_hpos_px)	;decrement
		or	a
		ret	z

		dec	a
		ld	(cannon_hpos_px),a
		jp	print_cannon
		
movec1:		bit	7,a
		ret	nz

		ld	a,(cannon_hpos_px)
		cp	#(PLAYFIELD_WIDTH - 16)
		ret	nc
		inc	a
		ld	(cannon_hpos_px),a
		jp	print_cannon

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

clear_lines:	ld	hl,(scrpos_invaders)

		ld	a,(row_end)
		inc	a
		ld	b,a
		ld	c,#VSTEP
cleanln00:	push	hl
		push	bc

		ld	b,c
		ld	de,#BYTES_PER_LINE

clearln0:	push	bc
		xor	a
		sbc	hl,de

		;;;;;;;;;;;;;;;;;;;;; 1 pixel line

		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a

		ld	a,(col_start)
		ld	b,a
		ld	a,(col_end)
		sub	b
		inc	a
		add	a,a
		add	a,a
		add	a,a
		ld	b,a
		
		xor	a	;ld	a,#0x44
clearln1:	out	(PORTDATA),a
		djnz	clearln1
		pop	bc
		
		djnz	clearln0

		pop	bc
		pop	hl
		ld	de,#BYTES_PER_LINE*(8+INVADERS_VSPACING)
		add	hl,de
		ld	c,#VSTEP2
		djnz	cleanln00
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

print_invaders:	ld	hl,(scrpos_invaders)
		ld	(spritepos),hl

		ld	hl,#invader_matrix
		ld	a,(col_start)
		ld	e,a
		ld	d,#0
		add	hl,de
		ld	(invader_matnow),hl
		ld	(invader_matnow2),hl
		
		xor	a		; Row

print_inv1:	ld	(row_now),a

		ld	hl,(spritepos)
		ld	(spritenow),hl
		
		ld	a,(col_start)
		;ld	b,a
		;ld	c,#0
		;add	hl,bc

print_inv1a:	ld	(col_now),a	; Invader row
		;ld	a,(hl)
		
		ld	hl,(invader_matnow2)
		ld	a,(hl)
		inc	hl
		ld	(invader_matnow2),hl
		or	a
		jr	z,blk		; No invader here, blank
		
		ld	a,(row_now)	; Invader type here
		add	a,a
		ld	b,a
		ld	a,(stepping)
		add	a,b
		or	a
		jr	z,sq1a
		dec	a
		jr	z,sq1b
		dec	a
		jr	z,cr1a
		dec	a
		jr	z,cr1b
		dec	a
		jr	z,cr2a
		dec	a
		jr	z,cr2b
		dec	a
		jr	z,oc1a
		dec	a
		jr	z,oc1b
		dec	a
		jr	z,oc2a
		dec	a
		jr	z,oc2b
		
blk:		ld	bc,#blank		
		jr	sprok
sq1a:		ld	bc,#squid1a
		jr	sprok
sq1b:		ld	bc,#squid1b
		jr	sprok
cr1a:		ld	bc,#crab1a
		jr	sprok
cr1b:		ld	bc,#crab1b
		jr	sprok
cr2a:		ld	bc,#crab2a
		jr	sprok
cr2b:		ld	bc,#crab2b
		jr	sprok
oc1a:		ld	bc,#octo1a
		jr	sprok
		
sprok:		ld	hl,(spritenow)
		push	hl
		call	print_sprite
		pop	hl
		ld	de,#8
		add	hl,de
		ld	(spritenow),hl
		
		ld	a,(col_now)
		ld	b,a
		ld	a,(col_end)
		cp	b
		jr	z,print_inv2

		inc	b
		ld	a,b
		jr	print_inv1a	; End invader row

oc1b:		ld	bc,#octo1b
		jr	sprok
oc2a:		ld	bc,#octo2a
		jr	sprok
oc2b:		ld	bc,#octo2b
		jr	sprok
		
print_inv2:	ld	hl,(spritepos)
		ld	de,#BYTES_PER_LINE*(8+INVADERS_VSPACING)
		add	hl,de
		ld	(spritepos),hl

		ld	hl,(invader_matnow)
		ld	de,#INVADER_COLS
		add	hl,de
		ld	(invader_matnow),hl
		ld	(invader_matnow2),hl

		ld	a,(row_now)
		ld	b,a
		ld	a,(row_end)
		cp	b
		ret	z
		inc	b
		ld	a,b

	;	push	af
	;	call	move_cannon
	;	pop	af

		jp	print_inv1
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

print_sprite:	ld	d,b		; bc = sprite  hl = scrpos
		ld	e,c
		ld	c,#8
printlb1:	ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a

		ld	b,#8
printlb2:	ld	a,(de)
		out	(PORTDATA),a
		inc	de
		djnz	printlb2		

		ld	a,l
		add	a,#BYTES_PER_LINE
		ld	l,a
		jr	nc,printlb3
		inc	h

printlb3:	dec	c
		jr	nz,printlb1

		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

print_cannon:	ld	bc,#cannon1
		ld	a,(cannon_hpos_px)
		bit	0,a
		jr	z,baseis1
		ld	bc,#cannon2
baseis1:	ld	hl,#CANNON_SCR_OFS
		srl	a
		ld	e,a
		ld	d,#0
		add	hl,de		; hl = screen mem pos
		jp	print_sprite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

clrscr:		xor	a
		out	(PORTADDRL),a
		out	(PORTADDRH),a
		ld	c,#240
clrscr1:	ld	b,#BYTES_PER_LINE
clrscr2:	out	(PORTDATA),a
		djnz	clrscr2
		dec	c
		jr	nz,clrscr1
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
;;
;; CGA Colors
;; 0 BLACK      8 DARKGRAY
;; 1 BLUE       9 LIGHTBLUE
;; 2 GREEN     10 LIGHTGREEN
;; 3 CYAN      11 LIGHTCYAN
;; 4 RED       12 LIGHTRED
;; 5 MAGENTA   13 LIGHTMAGENTA
;; 6 BROWN     14 YELLOW
;; 7 GRAY      15 WHITE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

print_bunkers:	ld	hl,#BUNKER1_SCR_OFS
		call	print_bunker
		ld	hl,#BUNKER2_SCR_OFS
		call	print_bunker
		ld	hl,#BUNKER3_SCR_OFS
		call	print_bunker
		ld	hl,#BUNKER4_SCR_OFS
		call	print_bunker
		ret
		
print_bunker:	; HL = screen position
		
		; Row 1
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		xor	a
		out	(PORTDATA),a
		out	(PORTDATA),a
		ld	b,#7
		call	print_bunkline

		ld	de,#BYTES_PER_LINE

		; Row 2
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		xor	a
		out	(PORTDATA),a
		ld	a,#0x0c
		out	(PORTDATA),a
		ld	b,#7
		call	print_bunkline
		ld	a,#0xc0
		out	(PORTDATA),a

		; Row 3
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		xor	a
		out	(PORTDATA),a
		ld	b,#9
		call	print_bunkline

		; Row 4
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	a,#0x0c
		out	(PORTDATA),a
		ld	b,#9
		call	print_bunkline
		ld	a,#0xc0
		out	(PORTDATA),a

		; Rows 5-12
		ld	b,#8
pbunk5:		push	bc
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	b,#11
		call	print_bunkline
		pop	bc
		djnz	pbunk5

		; Row 13
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	b,#4
		call	print_bunkline
		xor	a
		out	(PORTDATA),a
		out	(PORTDATA),a
		out	(PORTDATA),a
		ld	b,#4
		call	print_bunkline

		; Row 14
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	b,#3
		call	print_bunkline
		ld	a,#0xc0
		out	(PORTDATA),a
		xor	a
		out	(PORTDATA),a
		out	(PORTDATA),a
		out	(PORTDATA),a
		ld	a,#0x0c
		out	(PORTDATA),a
		ld	b,#3
		call	print_bunkline

		; Rows 15-16
		ld	b,#2
pbunk15:	push	bc
		add	hl,de
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		ld	b,#3
		call	print_bunkline
		xor	a
		out	(PORTDATA),a
		out	(PORTDATA),a
		out	(PORTDATA),a
		out	(PORTDATA),a
		out	(PORTDATA),a
		ld	b,#3
		call	print_bunkline
		pop	bc
		djnz	pbunk15
		
		ret

print_bunkline:	ld	a,#0xcc

pbunkl:		out	(PORTDATA),a
		djnz	pbunkl
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BLANK (NO COLOR) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ........ ........
;; ........ ........
;; ........ ........
;; ........ ........
;; ........ ........
;; ........ ........
;; ........ ........
;; ........ ........
blank:		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SQUID1 (LIGHTGREEN) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .......# #.......
;; ......## ##......
;; .....### ###.....
;; ....##.# #.##....
;; ....#### ####....
;; ......#. .#......
;; .....#.# #.#.....
;; ....#.#. .#.#....
squid1a:	.byte	0x00,0x00,0x00,0x0a, 0xa0,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0xaa, 0xaa,0x00,0x00,0x00
		.byte	0x00,0x00,0x0a,0xaa, 0xaa,0xa0,0x00,0x00
		.byte	0x00,0x00,0xaa,0x0a, 0xa0,0xaa,0x00,0x00
		.byte	0x00,0x00,0xaa,0xaa, 0xaa,0xaa,0x00,0x00
		.byte	0x00,0x00,0x00,0xa0, 0x0a,0x00,0x00,0x00
		.byte	0x00,0x00,0x0a,0x0a, 0xa0,0xa0,0x00,0x00
		.byte	0x00,0x00,0xa0,0xa0, 0x0a,0x0a,0x00,0x00

;; .......# #.......
;; ......## ##......
;; .....### ###.....
;; ....##.# #.##....
;; ....#### ####....
;; .....#.# #.#.....
;; ....#... ...#....
;; .....#.. ..#.....
squid1b:	.byte	0x00,0x00,0x00,0x0a, 0xa0,0x00,0x00,0x00
		.byte	0x00,0x00,0x00,0xaa, 0xaa,0x00,0x00,0x00
		.byte	0x00,0x00,0x0a,0xaa, 0xaa,0xa0,0x00,0x00
		.byte	0x00,0x00,0xaa,0x0a, 0xa0,0xaa,0x00,0x00
		.byte	0x00,0x00,0xaa,0xaa, 0xaa,0xaa,0x00,0x00
		.byte	0x00,0x00,0x0a,0x0a, 0xa0,0xa0,0x00,0x00
		.byte	0x00,0x00,0xa0,0x00, 0x00,0x0a,0x00,0x00
		.byte	0x00,0x00,0x0a,0x00, 0x00,0xa0,0x00,0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CRAB1 (LIGHTGREEN) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ....#... ..#.....
;; ..#..#.. .#..#...
;; ..#.#### ###.#...
;; ..###.## #.###...
;; ..###### #####...
;; ...##### ####....
;; ....#... ..#.....
;; ...#.... ...#....
crab1a:		.byte	0x00,0x00,0xa0,0x00, 0x00,0xa0,0x00,0x00
		.byte	0x00,0xa0,0x0a,0x00, 0x0a,0x00,0xa0,0x00
		.byte	0x00,0xa0,0xaa,0xaa, 0xaa,0xa0,0xa0,0x00
		.byte	0x00,0xaa,0xa0,0xaa, 0xa0,0xaa,0xa0,0x00
		.byte	0x00,0xaa,0xaa,0xaa, 0xaa,0xaa,0xa0,0x00
		.byte	0x00,0x0a,0xaa,0xaa, 0xaa,0xaa,0x00,0x00
		.byte	0x00,0x00,0xa0,0x00, 0x00,0xa0,0x00,0x00
		.byte	0x00,0x0a,0x00,0x00, 0x00,0x0a,0x00,0x00
		
;; ....#... ..#.....
;; .....#.. .#......
;; ....#### ### ....
;; ...##.## #.##....
;; ..###### #####...
;; ..#.#### ###.#...
;; ..#.#... ..#.#...
;; .....##. ##......
crab1b:		.byte	0x00,0x00,0xa0,0x00, 0x00,0xa0,0x00,0x00
		.byte	0x00,0x00,0x0a,0x00, 0x0a,0x00,0x00,0x00
		.byte	0x00,0x00,0xaa,0xaa, 0xaa,0xa0,0x00,0x00
		.byte	0x00,0x0a,0xa0,0xaa, 0xa0,0xaa,0x00,0x00
		.byte	0x00,0xaa,0xaa,0xaa, 0xaa,0xaa,0xa0,0x00
		.byte	0x00,0xa0,0xaa,0xaa, 0xaa,0xa0,0xa0,0x00
		.byte	0x00,0xa0,0xa0,0x00, 0x00,0xa0,0xa0,0x00
		.byte	0x00,0x00,0x0a,0xa0, 0xaa,0x00,0x00,0x00	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CRAB2 (LIGHTCYAN) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ....#... ..#.....
;; ..#..#.. .#..#...
;; ..#.#### ###.#...
;; ..###.## #.###...
;; ..###### #####...
;; ...##### ####....
;; ....#... ..#.....
;; ...#.... ...#....
crab2a:		.byte	0x00,0x00,0xb0,0x00, 0x00,0xb0,0x00,0x00
		.byte	0x00,0xb0,0x0b,0x00, 0x0b,0x00,0xb0,0x00
		.byte	0x00,0xb0,0xbb,0xbb, 0xbb,0xb0,0xb0,0x00
		.byte	0x00,0xbb,0xb0,0xbb, 0xb0,0xbb,0xb0,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00
		.byte	0x00,0x0b,0xbb,0xbb, 0xbb,0xbb,0x00,0x00
		.byte	0x00,0x00,0xb0,0x00, 0x00,0xb0,0x00,0x00
		.byte	0x00,0x0b,0x00,0x00, 0x00,0x0b,0x00,0x00
		
;; ....#... ..#.....
;; .....#.. .#......
;; ....#### ### ....
;; ...##.## #.##....
;; ..###### #####...
;; ..#.#### ###.#...
;; ..#.#... ..#.#...
;; .....##. ##......
crab2b:		.byte	0x00,0x00,0xb0,0x00, 0x00,0xb0,0x00,0x00
		.byte	0x00,0x00,0x0b,0x00, 0x0b,0x00,0x00,0x00
		.byte	0x00,0x00,0xbb,0xbb, 0xbb,0xb0,0x00,0x00
		.byte	0x00,0x0b,0xb0,0xbb, 0xb0,0xbb,0x00,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00
		.byte	0x00,0xb0,0xbb,0xbb, 0xbb,0xb0,0xb0,0x00
		.byte	0x00,0xb0,0xb0,0x00, 0x00,0xb0,0xb0,0x00
		.byte	0x00,0x00,0x0b,0xb0, 0xbb,0x00,0x00,0x00	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; OCTO1 (LIGHTCYAN) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ......## ##......
;; ...##### #####...
;; ..###### ######..
;; ..###..# #..###..
;; ..###### ######..
;; .....##. .##.....
;; ....##.# #.##....
;; ..##.... ....##..
octo1a:		.byte	0x00,0x00,0x00,0xbb, 0xbb,0x00,0x00,0x00
		.byte	0x00,0x0b,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
		.byte	0x00,0xbb,0xb0,0x0b, 0xb0,0x0b,0xbb,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
		.byte	0x00,0x00,0x0b,0xb0, 0x0b,0xb0,0x00,0x00
		.byte	0x00,0x00,0xbb,0x0b, 0xb0,0xbb,0x00,0x00
		.byte	0x00,0xbb,0x00,0x00, 0x00,0x00,0xbb,0x00

;; ......## ##......
;; ...##### #####...
;; ..###### ######..
;; ..###..# #..###..
;; ..###### ######..
;; ....###. .###....
;; ...##..# #..##...
;; ....##.. ..##....
octo1b:		.byte	0x00,0x00,0x00,0xbb, 0xbb,0x00,0x00,0x00
		.byte	0x00,0x0b,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
		.byte	0x00,0xbb,0xb0,0x0b, 0xb0,0x0b,0xbb,0x00
		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
		.byte	0x00,0x00,0xbb,0xb0, 0x0b,0xbb,0x00,0x00
		.byte	0x00,0x0b,0xb0,0x0b, 0xb0,0x0b,0xb0,0x00
		.byte	0x00,0x00,0xbb,0x00, 0x00,0xbb,0x00,0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;; OCTO2 (LIGHTMAGENTA) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ......## ##......
;; ...##### #####...
;; ..###### ######..
;; ..###..# #..###..
;; ..###### ######..
;; .....##. .##.....
;; ....##.# #.##....
;; ..##.... ....##..
octo2a:		.byte	0x00,0x00,0x00,0xdd, 0xdd,0x00,0x00,0x00
		.byte	0x00,0x0d,0xdd,0xdd, 0xdd,0xdd,0xd0,0x00
		.byte	0x00,0xdd,0xdd,0xdd, 0xdd,0xdd,0xdd,0x00
		.byte	0x00,0xdd,0xd0,0x0d, 0xd0,0x0d,0xdd,0x00
		.byte	0x00,0xdd,0xdd,0xdd, 0xdd,0xdd,0xdd,0x00
		.byte	0x00,0x00,0x0d,0xd0, 0x0d,0xd0,0x00,0x00
		.byte	0x00,0x00,0xdd,0x0d, 0xd0,0xdd,0x00,0x00
		.byte	0x00,0xdd,0x00,0x00, 0x00,0x00,0xdd,0x00

;; ......## ##......
;; ...##### #####...
;; ..###### ######..
;; ..###..# #..###..
;; ..###### ######..
;; ....###. .###....
;; ...##..# #..##...
;; ....##.. ..##....
octo2b:		.byte	0x00,0x00,0x00,0xdd, 0xdd,0x00,0x00,0x00
		.byte	0x00,0x0d,0xdd,0xdd, 0xdd,0xdd,0xd0,0x00
		.byte	0x00,0xdd,0xdd,0xdd, 0xdd,0xdd,0xdd,0x00
		.byte	0x00,0xdd,0xd0,0x0d, 0xd0,0x0d,0xdd,0x00
		.byte	0x00,0xdd,0xdd,0xdd, 0xdd,0xdd,0xdd,0x00
		.byte	0x00,0x00,0xdd,0xd0, 0x0d,0xdd,0x00,0x00
		.byte	0x00,0x0d,0xd0,0x0d, 0xd0,0x0d,0xd0,0x00
		.byte	0x00,0x00,0xdd,0x00, 0x00,0xdd,0x00,0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;; LASER BASE (LIGHTCYAN) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .......# ........
;; ......## #.......
;; ......## #.......
;; ..###### #####...
;; .####### ######..
;; .####### ######..
;; .####### ######..
;; .####### ######..
cannon1:	.byte	0x00,0x00,0x00,0x0b, 0x00,0x00,0x00,0x00
  		.byte	0x00,0x00,0x00,0xbb, 0xb0,0x00,0x00,0x00
  		.byte	0x00,0x00,0x00,0xbb, 0xb0,0x00,0x00,0x00
  		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00
  		.byte	0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
  		.byte	0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
  		.byte	0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
  		.byte	0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00

;; ........ #.......
;; .......# ##......
;; .......# ##......
;; ...##### ######..
;; ..###### #######.
;; ..###### #######.
;; ..###### #######.
;; ..###### #######.
cannon2:	.byte	0x00,0x00,0x00,0x00, 0xb0,0x00,0x00,0x00
  		.byte	0x00,0x00,0x00,0x0b, 0xbb,0x00,0x00,0x00
  		.byte	0x00,0x00,0x00,0x0b, 0xbb,0x00,0x00,0x00
  		.byte	0x00,0x0b,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00
  		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0
  		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0
  		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0
  		.byte	0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

timer_isr:	ld	hl,(timer_invaders)
		ld	a,h
		or	l
		jr	z,timer_isr2
		dec	hl
		ld	(timer_invaders),hl
		
timer_isr2:	ld	a,(timer_cannon)
		or	a
		jr	z,timer_isr3

		dec	a
		ld	(timer_cannon),a

timer_isr3:	ld	a,(timer_missile)
		or	a
		jr	z,timer_isr4
		dec	a
		ld	(timer_missile),a
	
timer_isr4:	ld	a,(timer_bombs)
		or	a
		jr	z,timer_isr5
		dec	a
		ld	(timer_bombs),a

timer_isr5:	ld	a,(timer_newbomb)
		or	a
		jr	z,timer_isr6
		dec	a
		ld	(timer_newbomb),a


timer_isr6:	ld	hl,(isr2vector_copy)
		jp	(hl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

; Fibonacci LFSR
; New bit[0] = bit[10] ^ bit[12] ^ bit[13] ^ bit[15]

lfsr_update:	ld	hl,(lfsr_data)

		scf
		ccf
		
		bit	7,h
		jr	z,lfsr1
		ccf
lfsr1:		bit	5,h
		jr	z,lfsr2
		ccf
lfsr2:		bit	4,h
		jr	z,lfsr3
		ccf
lfsr3:		bit	2,h
		jr	z,lfsr4
		ccf
lfsr4:		rl	l
		rl	h
		ld	(lfsr_data),hl
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

newbomb:	ld	ix,#bomb_basedata
		ld	b,#NUM_BOMBS

newbomb1:	push	bc
		call	 newbomb_ix
		inc	ix
		pop	bc
		djnz	newbomb1

		ret

newbomb_ix:
		ld	a,(timer_newbomb)
		or	a
		ret	nz
		ld	a,#50
		ld	(timer_newbomb),a

		ld	a,_BOMB_ACT(ix)
		or	a
		ret	nz

		;ld	a,(col_start)
		ld	a,(lfsr_data)
newbomb0:	cp	#INVADER_COLS
		jr	c,newbomb1a
		sub	#INVADER_COLS
		jr	newbomb0

newbomb1a:
		ld	(col_now),a

		call	nb_testcol

		ld	a,d
		or	a
		ret	z

		ld	a,(row_invaders)
		add	a,#0x0c
		ld	_BOMB_VPOS(ix),a

		ld	a,e
		or	a
		jr	z,newbomb2
		ld	b,e
		ld	a,_BOMB_VPOS(ix)
		
newbomb1b:	add	#(8+INVADERS_VSPACING)
		djnz	newbomb1b

		ld	_BOMB_VPOS(ix),a

newbomb2:
		ld	a,(col_start)
		ld	b,a
		ld	a,(col_now)
		sub	b
		ld	b,a
		sla	b
		sla	b	;x16 (invader width)
		sla	b
		sla	b
		ld	a,(col_invaders_px)
		add	a,b
		add	a,#7
		ld	_BOMB_HPOS_PX(ix),a

		ld	b,#0x0f
		bit	0,a
		jr	z,newbomb3
		ld	b,#0xf0

newbomb3:	ld	a,b
		ld	_BOMB_PIXMASK(ix),a

		ld	a,_BOMB_VPOS(ix)	; Pixel line
		ld	hl,#0
		or	a
		jr	z,nbupd1a
		ld	de,#BYTES_PER_LINE
nbupd1:		add	hl,de
		dec	a
		jr	nz,nbupd1
	
nbupd1a:	ld	d,h
		ld	e,l
		ld	a,_BOMB_HPOS_PX(ix)
		srl	a
		ld	l,a
		ld	h,#0
		add	hl,de
		ld	de,#LEFT_OFFSET_BYTES
		add	hl,de
		ld	_BOMB_SCRPOS_L(ix),l
		ld	_BOMB_SCRPOS_H(ix),h

		ld	a,#1
		ld	_BOMB_ACT(ix),a

		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
nb_testcol:		
		; will test a column to launch a bomb
		; return  # if invaders in col in D, Lowest row w/ invader in col in E

		ld	hl,#invader_matrix	; top of scanned column
		ld	b,#0
		ld	a,(col_now)
		ld	c,a
		add	hl,bc			; H offset
		ld	de,#0			;
		ld	c,#0
		ld	b,#INVADER_ROWS
nbcc1:		ld	a,(hl)
		or	a
		jr	z,nbcc2
		ld	e,c
		inc	d		
nbcc2:		ld	a,l
		add	a,#INVADER_COLS
		ld	l,a
		jr	nc,nbcc3
		inc	h
nbcc3:		inc	c
		djnz	nbcc1

		ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

move_bombs:
		ld	a,(timer_bombs)
		or	a
		ret	nz
		ld	a,#4
		ld	(timer_bombs),a

		ld	ix,#bomb_basedata

		ld	b,#NUM_BOMBS
move_bombs1:
		push	bc
		call	move_bombs_ix
		inc	ix
		pop	bc
		djnz	move_bombs1

		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_bombs_ix:
		ld	a,_BOMB_ACT(ix)
		or	a
		ret	z

		ld	a,_BOMB_VPOS(ix)
		cp	#(CANNON_VPOS+8)
		jr	c,moveb1

		xor	a
		ld	_BOMB_ACT(ix),a
		ld	l,_BOMB_SCRPOS_L(ix)
		ld	h,_BOMB_SCRPOS_H(ix)
		ld	c,#0
		jr	moveb2

moveb1:		inc	a
		inc	a
		ld	_BOMB_VPOS(ix),a
		
		ld	l,_BOMB_SCRPOS_L(ix)
		ld	h,_BOMB_SCRPOS_H(ix)
		ld	de,#(2*BYTES_PER_LINE)
		add	hl,de
		ld	_BOMB_SCRPOS_L(ix),l
		ld	_BOMB_SCRPOS_H(ix),h

		ld	a,_BOMB_PIXMASK(ix)
		and	#0xee
		ld	c,a
		
		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a

		ld	a,_BOMB_PIXMASK(ix)
		ld	d,a
		in	a,(PORTDATA)
		and	d
		jr	z,moveb2

	;	push	hl
	;	call	check_hit		; TODO: Check bomb vs cannon hit
	;	pop	hl
		
		ld	a,#0
		ld 	_BOMB_ACT(ix),a
		ld	c,#0
		
moveb2:		ld	b,#5
		ld	de,#-BYTES_PER_LINE

moveb3:		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		push	bc
		in	a,(PORTDATA)
		ld	b,a
		ld	a,_BOMB_PIXMASK(ix)
		cpl
		and	b
		or	c
		pop	bc
		out	(PORTDATA),a
		add	hl,de
		djnz	moveb3

		ld	b,#2
		ld	a,_BOMB_PIXMASK(ix)
		cpl
		ld	c,a
moveb4:		ld	a,l
		out	(PORTADDRL),a
		ld	a,h
		out	(PORTADDRH),a
		in	a,(PORTDATA)
		and	c
		out	(PORTDATA),a
		add	hl,de
		djnz	moveb4
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

		.area _DATA

isr2vector_copy:.ds	2

cannon_hpos_px:	.ds	1
missile_hpos_px:.ds	1
missile_pixmask:.ds	1
missile_vpos:	.ds	1
missile_act:	.ds	1
missile_scrpos:	.ds	2

row_invaders:	.ds	1
col_invaders_px:.ds	1
hdir_invaders:	.ds	1
scrpos_invaders:.ds	2

invader_matrix:	.ds	INVADER_NUM
invader_count:	.ds	1
invader_matnow:	.ds	2
invader_matnow2:.ds	2
col_start:	.ds	1
col_end:	.ds	1
col_now:	.ds	1
row_now:	.ds	1
row_end:	.ds	1
stepping:	.ds	1
spritepos:	.ds	2
spritenow:	.ds	2
timer_div:	.ds	2
timer_invaders:	.ds	2
invaders_divider:.ds	2
timer_cannon:	.ds	1
timer_missile:	.ds	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bomb_basedata:
bomb_hpos_px:	.ds	NUM_BOMBS
bomb_pixmask:	.ds	NUM_BOMBS
bomb_vpos:	.ds	NUM_BOMBS
bomb_act:	.ds	NUM_BOMBS
bomb_scrpos_l:	.ds	NUM_BOMBS
bomb_scrpos_h:	.ds	NUM_BOMBS

_BOMB_HPOS_PX	.equ	(bomb_hpos_px - bomb_basedata)
_BOMB_PIXMASK	.equ	(bomb_pixmask - bomb_basedata)
_BOMB_VPOS	.equ	(bomb_vpos - bomb_basedata)
_BOMB_ACT	.equ	(bomb_act - bomb_basedata)
_BOMB_SCRPOS_L	.equ	(bomb_scrpos_l - bomb_basedata)
_BOMB_SCRPOS_H	.equ	(bomb_scrpos_h - bomb_basedata)

timer_bombs:	.ds	1
timer_newbomb:	.ds	1

lfsr_data:	.ds	2

