; =============================================================================
;
;   KRAFT 80 Z80 Computer
;   Core Test 1 Program for the Kraft 80 computer
;   2025-Jul-09
;   Milton Maldonado Jr. (ARMCoder)
;
;   LCD Controller functions (lcd_begin >> end):
;     Author: Dr. Eng. Wagner Rambo
;     Date:   2025, January       
;
; =============================================================================


; =============================================================================
; --- Hardware Mapping ---
PORTBUTTONS     .equ 0x00 ;PORTX address (Read) 
PORTLEDS        .equ 0x00 ;PORTA address (Write)
PORTB           .equ 0x10 ;PORTB address (Write)
EN		.equ	0x01				;LCD enable pin (PORTB bit 1)
RS		.equ	0x01				;LCD RS pin (uses or logic)

ROMBASE         .equ 0
ROMSZ           .equ 0x2000
RAMBASE         .equ 0x2000
RAMSZ           .equ 0x6000

RAMHBASE	.equ 0x8000
RAMHSZ		.equ 0x8000

STACKTOP .equ	(RAMBASE+RAMSZ)

; =============================================================================
; --- Reset Vector ---

	.area	_HEADER (ABS)

	.org	0x0000			;origem no endereço 00h de memória

; =============================================================================
; --- Main Program ---

	ld	sp,#STACKTOP		;pilha de memória 
	call	lcd_begin		;inicializa LCD no modo 4 bits		
	ld	d,#2			;carrega 2d em d 
	call	dx100ms			;aguarda 500ms 				
	ld	b,#0x0C			;desliga cursor e blink 
	call	lcd_cmd 		;envia comando 
	call	msg_init 		;escreve título "Alpha Z80" 
	ld	d,#10			;carrega 10d em d 
	call	dx100ms			;aguarda 1 seg. 

	call	lcd_clear

	call	test_rams

	ld	hl,#0xc000
	ld	d,#1

loop:	inc	hl
	ld	a,h
	or	l
	jr	nz,loop

	ld	hl,#0xc000

	in	a,(PORTBUTTONS)
	cpl
	ld	c,a
	ld	a,d
	or	c

	out	(PORTLEDS),a

	rrc	d
	jr	loop

; =============================================================================
test_rams:

	ld	hl,#RAMBASE
	ld	b,#(RAMSZ-0x100) / 0x100  ;Protects the top to not trample the stack
	ld	de,#0x100
	ld	a,#1
testra1:
	ld	(hl),a
	inc	a
	add	hl,de
	djnz	testra1
	
	ld	hl,#RAMHBASE
	ld	b,#RAMHSZ / 0x100
	ld	a,#3
testra2:
	ld	(hl),a
	inc	a
	add	hl,de
	djnz	testra2

	ld	ix,#0

	ld	hl,#RAMBASE
	ld	b,#(RAMSZ-0x100) / 0x100  ;Protects the top to not trample the stack
	ld	de,#0x100
	ld	c,#1
testra3:
	ld	a,(hl)
	cp	c
	jr	nz,ramloerr
	inc	c
	add	hl,de
	djnz	testra3
	jr	testra4ini

ramloerr:
	inc	ix
	
testra4ini:
	ld	hl,#RAMHBASE
	ld	b,#RAMHSZ / 0x100
	ld	c,#3
testra4:
	ld	a,(hl)
	cp	c
	jr	nz,ramhierr
	inc	c
	add	hl,de
	djnz	testra4
	jr	testra5
	
ramhierr:
	inc	ix
	inc	ix

testra5:
	ld	b,#'R'
	call 	lcd_write 
	ld	b,#'A'
	call 	lcd_write 
	ld	b,#'M'
	call 	lcd_write 
	ld	b,#'0'
	call 	lcd_write 
	ld	b,#':'
	call 	lcd_write 

	push	ix
	pop	hl
	bit	0,l
	jr	nz,err_raml

	ld	b,#'O'
	call 	lcd_write 
	ld	b,#'K'
	call 	lcd_write 
	jr	ramh

err_raml:
	ld	b,#'E'
	call 	lcd_write 
	ld	b,#'R'
	call 	lcd_write 

ramh:
	ld	b,#' '
	call 	lcd_write 
	ld	b,#' '
	call 	lcd_write 
	ld	b,#'R'
	call 	lcd_write 
	ld	b,#'A'
	call 	lcd_write 
	ld	b,#'M'
	call 	lcd_write 
	ld	b,#'1'
	call 	lcd_write 
	ld	b,#':'
	call 	lcd_write 

	push	ix
	pop	hl
	bit	1,l
	jr	nz,err_ramh

	ld	b,#'O'
	call 	lcd_write 
	ld	b,#'K'
	call 	lcd_write 
	ret

err_ramh:
	ld	b,#'E'
	call 	lcd_write 
	ld	b,#'R'
	jp 	lcd_write 

	ret
	
; =============================================================================
; --- Inicializa LCD modo de 4 bits ---
lcd_begin:
		ld		d,#50		;carrega 50d em d 
		call	dx1ms			;tempo para estabilização (50ms)
		ld		b,#0x30		;protocolo de inicialização
		ld		c,#0x00		;envio de comando
		call	send_nibble		;envia 30h para o LCD
		ld		d,#5		;carrega 5d em d 
		call	dx1ms			;aguarda 5ms (tempo superior ao datasheet)
		ld		b,#0x30		;protocolo de inicialização
		ld		c,#0x00		;envio de comando
		call	send_nibble		;envia 30h para o LCD		
		call	d1ms 			;aguarda 1ms (tempo superior ao datasheet)
		ld		b,#0x30		;protocolo de inicialização
		ld		c,#0x00		;envio de comando
		call	send_nibble		;envia 30h para o LCD
		ld		b,#0x20		;LCD no modo 4 bits
		ld		c,#0x00		;envio de comando
		call	send_nibble		;envia 30h para o LCD
		ld		b,#0x28		;5x8 pontos por caractere, duas linhas
		call	lcd_cmd			;envia comando 28h
		ld		b,#0x0F		;liga display, cursor e blink
		call	lcd_cmd			;envia comando 0Fh
		ld		b,#0x01		;limpa LCD
		call	lcd_cmd			;envia comando 01h
		ld		b,#0x06		;modo de incremento de endereço para direita, movendo apenas o cursor 
		call	lcd_cmd			;envia comando 06h
		call	lcd_clear		;limpa o display
		ret				;retorno da sub-rotina
		

; =============================================================================
; --- Envia Comandos / Escreve no LCD ---
lcd_cmd:
		ld		c,#0x00
		jr		send_byte
lcd_write:
		ld		c,#0x01			;01h para envio de caracteres
send_byte:		
		call	send_nibble		;envia nibble mais significativo
		ld		a,b				;carrega conteúdo de b em acc
		rla						;rotaciona acc para esquerda 4x
		rla						;
		rla						;
		rla						;
		and		#0xF0			;máscara para preservar nibble mais significativo
		ld		b,a				;atualiza b
		call	send_nibble		;envia nibble menos significativo
		ret						;retorno da sub-rotina
		

;==============================================================================
; --- Envia cada nibble separadamente e gera pulso de enable ---
send_nibble:
		ld		a,#0x00			;zera conteúdo de ACC
		bit		0,c				;bit 0 de c em LOW?
		jp		z,rs_clr		;sim, desvia para manter RS limpo
		ld		a,#(0x00|RS)		;não, seta bit RS
rs_clr:
		bit		7,b				;bit7 de B em LOW?
		jp		z,b6aval		;sim, desvia para avaliar bit6
		set		7,a				;não, seta bit 7 de acc
b6aval:
		bit		6,b				;bit6 de B em LOW?
		jp		z,b5aval		;sim, desvia para avaliar bit5
		set		6,a				;não, seta bit 6 de acc
b5aval:
		bit		5,b				;bit5 de B em LOW?
		jp		z,b4aval		;sim, desvia para avaliar bit4
		set		5,a				;não, seta bit 5 de acc
b4aval:
		bit		4,b				;bit4 de B em LOW?
		jp		z,lcd_en		;sim, desvia para pulso de enable
		set		4,a				;não, set bit 4 de acc
lcd_en:
		set		EN,a			;pino enable em HIGH
		out		(PORTB),a		;escreve no PORTB 
		ld		d,#2				;carrega 2d em d 
		call    dx1ms           ;aguarda 2ms 
		res		EN,a			;pino enable em LOW 
		out		(PORTB),a 		;escreve no PORTB 
		ld		d,#2				;carrega 2d em d
		call    dx1ms           ;aguarda 2ms 		
		ret						;retorno da sub-rotina
		

; =============================================================================
; --- Limpa LCD ---
lcd_clear:
		ld		b,#0x02		;return home
		call	lcd_cmd			;envia 02h para o LCD
		ld		b,#0x01		;limpa o display
		call	lcd_cmd			;envia 01h para o LCD
		ret						;retorno da sub-rotina		
		

; =============================================================================
; --- Imprime o título na segunda linha do LCD ---
msg_init:
		ld		b,#0xC0		;posiciona cursor na linha 1, coluna 0
		call	lcd_cmd			;envia comando 
		ld		b,#'C' 			;imprime "Alpha Z80" 
		call	lcd_write 
		ld		b,#'o'
		call 	lcd_write 
		ld		b,#'r'
		call 	lcd_write 
		ld		b,#'e'
		call 	lcd_write 
		ld		b,#'t'
		call 	lcd_write
		ld		b,#'e'
		call 	lcd_write 	
		ld		b,#'s'
		call 	lcd_write 
		ld		b,#'t'
		call 	lcd_write 		
		ld		b,#'2'
		call 	lcd_write 		
		ld		b,#0x80		;posiciona cursor na linha 0, coluna 0
		call	lcd_cmd			;envia comando 
		ret						;retorna da sub-rotina 


; =============================================================================
; --- dx1ms multiplies 1ms delay ---	
dx1ms:				
		call	d1ms			; 1ms (delay time)
		dec 	d 				; 1.0µs    4 T States 
		jp 		nz,dx1ms  		; 2.5µs   10 T States 		
		ret						; 2.5µs   10 T States 


; =============================================================================
; --- aprox. 1ms delay (clock 4MHz) ---
d1ms:							; 4.25µs  17 T States (call)
		push	bc				; 2.75µs  11 T States 
		ld		b,#0xDB			; 1.75 µs  7 T States 
dloop:
		dec		b				; 1.0µs    4 T States 
		nop 					; 1.0µs    4 T States 
		jp		nz,dloop		; 2.5µs   10 T States 								
		pop		bc				; 2.5µs   10 T States 
		ret						; 2.5µs   10 T States 


; =============================================================================
; --- dx100ms multiplies 100ms delay ---	
dx100ms: 
		call	d100ms			; 1ms (delay time)
		dec 	d 				; 1.0µs    4 T States 
		jp 		nz,dx100ms 		; 2.5µs   10 T States 	
		ret						; 2.5µs   10 T States 
		
		
; =============================================================================
; --- aprox. 100ms delay (clock 4MHz) ---
d100ms:							; 4.25µs  17 T States
		push	bc 				; 2.75µs  11 T States 
		ld		b,#0x97			; 1.75µs   7 T States 
aux1:
		ld		c,#0xBD			; 1.75µs   7 T States 
aux2:
		dec		c				; 1.0µs    4 T States 
		jp		nz,aux2 		; 2.5µs   10 T States 
		dec		b 				; 1.0µs    4 T States 
		jp		nz,aux1 		; 2.5µs   10 T States 
		pop		bc 				; 2.5µs   10 T States 
		ret 					; 2.5µs   10 T States 


;=======================================================
; --- Final do Programa ---
	.area _DATA

