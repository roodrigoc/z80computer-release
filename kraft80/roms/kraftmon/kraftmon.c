/*
KRAFTMON.C
Monitor Program (Memory Editor and Loader) for the KRAFT 80 computer
2025 - ARM Coder
*/

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>

#include "io-kraft80.h"

#pragma codeseg MAIN

#define BUFSIZE 250

////////////////////////////////////////////////////////////////////////////////
int last_edit = 0x2100;
int last_dump = 0x2100;
int last_go = 0x2100;

////////////////////////////////////////////////////////////////////////////////
void conv_strupr(char *dest, const char *src){

    while (*src){
    
        *dest = toupper(*src);
        src++; dest++;
    }
    *dest = 0;
}

////////////////////////////////////////////////////////////////////////////////
void filter_buf(char *buf){

    int len = strlen(buf);
    int i,j;

    if (!buf[0]) return;
        
    for (i = 0; i < len; i++)
        if (buf[i] == 0x09)
            buf[i] = ' ';

    if (buf[0] == ' '){

        for (i = 0; i < len; i++){

            if (buf[i] != ' '){

                j = 0;
                while (buf[i]){
                
                    buf[j++] = buf[i++];
                }
                buf[j] = 0;
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
int isnibble(char c){

    if ((c >='0') && (c <= '9')) return 1;
    if ((c >='a') && (c <= 'f')) return 1;
    if ((c >='A') && (c <= 'F')) return 1;

    return 0;
}

////////////////////////////////////////////////////////////////////////////////
uint8_t getnibble(char c){

    if ((c >='0') && (c <= '9')) return c - '0';
    if ((c >='a') && (c <= 'f')) return c - 'a' + 10;
    if ((c >='A') && (c <= 'F')) return c - 'A' + 10;

    return 0;
}

////////////////////////////////////////////////////////////////////////////////
const char dighex[] = "0123456789ABCDEF";
void puthex8(char a){

    putchar(dighex[a>>4]);
    putchar(dighex[a&0x0f]);
}

////////////////////////////////////////////////////////////////////////////////
int get_prm16(char *buf){

    filter_buf(buf);
    int prm = -1;
    int i;
    
    for (i = 0; i < 4; i++){

	if (isnibble(buf[i])){
	    if (prm == -1)
	        prm = 0;
	    prm <<= 4;
	    prm |= getnibble(buf[i]);
	}
	else
	    break;
    }
        
    return prm;
}

////////////////////////////////////////////////////////////////////////////////
char get_prm8(char *buf){

    filter_buf(buf);
    char prm = 0;
    int i;
    
    for (i = 0; i < 2; i++){

	if (isnibble(buf[i])){
	    prm <<= 4;
	    prm |= getnibble(buf[i]);
	}
	else
	    break;
    }
        
    return prm;
}

////////////////////////////////////////////////////////////////////////////////
void crlf(){

    putstr("\r\n");
}

////////////////////////////////////////////////////////////////////////////////
void prompt(){

    crlf();
    putchar(':');
}

////////////////////////////////////////////////////////////////////////////////
int edit_mem(int addr){

    char *p = (char*)addr;
    char buf[120];

    crlf();
    
    puthex8(addr>>8);
    puthex8(addr&0xff);
    putchar(':');

    lgets(buf,sizeof(buf));

    int i = 0;
    while(buf[i]){

        filter_buf(buf+i);

        if (!isnibble(buf[i]))
            break;
    
        *p++ = get_prm8(buf+i);
        i++;
        if (isnibble(buf[i]))
            i++;
        addr++;
    }

    crlf();
    
    return addr;
}

////////////////////////////////////////////////////////////////////////////////
int dump_mem(int addr){

#define DUMPLEN 128

    int addr1 = addr;
    addr &= 0xfff0;
    char *p = (char*)addr;
    
    int i;
    int cols = 16;    
    putstr("\r\n     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\r\n");
    for (i = 0; i < DUMPLEN; i++){
    
        if (cols == 16){
            cols = 0;
            crlf();
            puthex8(addr>>8);
            puthex8(addr&0xff);
            putchar(':');
        }
        if (addr < addr1)
            putstr("  ");
        else
            puthex8(p[i]);
        cols++;
        putchar(' ');
        addr++;
    }

    crlf();
    
    return addr;
}

////////////////////////////////////////////////////////////////////////////////
void go(int last_go) __naked {

    __asm

    push bc
    ld bc,#retgo
    push bc
    jp (hl)
retgo:
    pop bc
    ret
    
    __endasm;
}

////////////////////////////////////////////////////////////////////////////////
void cpm_mode_on() __naked{

    __asm

    di
    ld hl,#0
    ld de,#0xc000
    ld bc,#0x2000
    ldir
    ld hl,#code1
    ld de,#0xe000
    ld bc,#0x100
    ldir
    jp 0xe000
code1:
    ld a,#1
    out (#0x40),a
    ld hl,#0xc000
    ld de,#0
    ld bc,#0x2000
    ldir
    ei
    ret    

    __endasm;
}

////////////////////////////////////////////////////////////////////////////////
void proc_intelhex(char *buf){

    crlf();

    unsigned char checksum = 0;
    buf++;
    int nbytes = get_prm8(buf);
    buf += 2;
    checksum = nbytes;

    int addr = get_prm16(buf);
    buf += 4;
    checksum += (addr >> 8);
    checksum += (addr & 0xff);

    int type = get_prm8(buf);
    buf += 2;
    if (type==1) {

        putstr("End of transfer.\r\n");
        return;
    }
    
    int i;
    char *bufbytes = buf;
    for (i = 0; i < nbytes; i++){
    
        unsigned char c = get_prm8(buf);
	checksum += c;
	buf += 2;
    }

    unsigned char ck2 = get_prm8(buf);
    
    if ((checksum + ck2) & 0xff)
        putstr("Checksum error!\r\n");
    else{
    
        char *p = (char *)addr;
        for (i = 0; i < nbytes; i++){    
            
            p[i] = get_prm8(bufbytes);
            bufbytes += 2;
        }
        putstr("Verify OK.\r\n");
    }
}

////////////////////////////////////////////////////////////////////////////////
void load_ihex(char *buf){

    putstr("\r\nSend the IHEX file, [ENTER] to abort\r\n");
    
    for(;;){

        lgets_noecho(buf, BUFSIZE);
        if (!buf[0]) return;
        proc_intelhex(buf);
    }
}

#define SOH 1
#define EOT 4
#define ACK 6
#define NAK 21
#define ESC 27

////////////////////////////////////////////////////////////////////////////////
void load_xmodem(char *buf){

    unsigned char lastseq = 1;
    unsigned char *p;

    putstr("\r\nSend the binary via XMODEM, [ENTER] to abort\r\n");

    last_edit = 0x2100;

    int count = 30000;

    for (;;){

        if (kbhit()){
    
            char c = getchar();
            if (c == EOT) {
                
                putchar(ACK);
                return;
            }

            if ((c == ESC)||(c == 0x0d)) return;

            if (c == SOH) {

                c = getchar();
                if (c == lastseq){

                    c = getchar() ^ 0xFF;
                    if (c == lastseq){

                        int i;
                        unsigned char chksum = 0;

                        p = (unsigned char *)last_edit;

                        for (i = 0; i < 128; i++){

                            c = getchar();
                            chksum += c;
                            *p = c; p++;
                        }
                        c = getchar();
                        if (c == chksum){
        
                            last_edit += 128;
                            lastseq++;
                            putchar(ACK);
                        }
                        else{
send_nak:
                            putchar(NAK);
                        }
                    }
                }
            }
        }
        else{
        
            count--;
            if (!count){
                count = 30000;
                putchar(NAK);
            }
        }

    }
}

////////////////////////////////////////////////////////////////////////////////
void parse_buf(char *buf){

    filter_buf(buf);
    int res;
    
    if (!strcmp(buf,"cpm")){
    
	cpm_mode_on();
	putstr("\r\nCP/M mode is on\r\n");
	return;
    }

if (!strcmp(buf,"load")){
    
	load_ihex(buf);
	return;
    }

    if (!strcmp(buf,"loadx")){
    
	load_xmodem(buf);
	return;
    }
    
    switch(buf[0]){
    
        case '?':
            putstr("\r\n\nHELP\r\n"
                   "e [nnnn] : Edit memory\r\n"
                   "d [nnnn] : Dump memory\r\n"
                   "g [nnnn] : Go\r\n"
                   "load     : Load IHEX\r\n"
                   "loadx    : Load XMODEM\r\n"
                   "cpm      : Enter \"CP/M\" mode (RAM @0x0000)\r\n"
                   );
            break;
            
        case 'e':
            res = get_prm16(buf+1);
            if (res != -1)
            	last_edit = res;
                crlf();
            	last_edit = edit_mem(last_edit);
            break;
        
        case 'd':
            res = get_prm16(buf+1);
            if (res != -1)
                last_dump = res;
            last_dump = dump_mem(last_dump);
            break;
            
        case 'g':
            res = get_prm16(buf+1);
            if (res != -1)
                last_go = res;
            putstr("\r\n\nGo!\r\n");
            go(last_go);
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////
void main (void){

    char buf[BUFSIZE];
    //setleds(0x55);
    //lcd_begin();

    putstr ("\r\nKRAFTMON 1.3.2 by ARMCoder\r\n");
    putstr ("Ready...\r\n");

    last_edit = 0x2100;
    last_dump = 0x2100;
    last_go = 0x2100;

    for (;;){

        prompt();
        lgets(buf,sizeof(buf));
        parse_buf(buf);
    }
}

