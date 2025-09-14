#include <stdio.h>
#include <ctype.h>
#include "io-kraft80.h"
#include "videodisp.h"

const char d0[] = { 
            0b00000000,
            0b01111100,
            0b10000010,
            0b10000010,
            0b10000010,
            0b10000010,
            0b01111100,
            0b00000000
};

const char d1[] = { 
            0b00000000,
            0b00010000,
            0b00110000,
            0b01010000,
            0b00010000,
            0b00010000,
            0b01111000,
            0b00000000,
};

const char d2[] = { 
            0b00000000,
            0b01111100,
            0b10000010,
            0b00011100,
            0b01100000,
            0b10000000,
            0b11111110,
            0b00000000,
};

const char d3[] = { 
            0b00000000,
            0b01111100,
            0b10000010,
            0b00011100,
            0b00000010,
            0b10000010,
            0b01111100,
            0b00000000,
};

const char d4[] = { 
            0b00000000,
            0b00011000,
            0b00101000,
            0b01001000,
            0b11111110,
            0b00001000,
            0b00001000,
            0b00000000,
};

const char d5[] = { 
            0b00000000,
            0b11111100,
            0b10000000,
            0b11111100,
            0b00000010,
            0b10000010,
            0b01111100,
            0b00000000,
};

const char d6[] = { 
            0b00000000,
            0b01111100,
            0b10000000,
            0b11111100,
            0b10000010,
            0b10000010,
            0b01111100,
            0b00000000,
};

const char d7[] = { 
            0b00000000,
            0b11111110,
            0b00000100,
            0b00001000,
            0b00010000,
            0b00100000,
            0b01000000,
            0b00000000,
};

const char d8[] = { 
            0b00000000,
            0b01111100,
            0b10000010,
            0b01111100,
            0b10000010,
            0b10000010,
            0b01111100,
            0b00000000,
};

const char d9[] = { 
            0b00000000,
            0b01111100,
            0b10000010,
            0b10000010,
            0b01111110,
            0b00000010,
            0b01111100,
            0b00000000,
};

const char d10[] = { 
            0b00000000,
            0b00000000,
            0b00110000,
            0b00110000,
            0b00000000,
            0b00110000,
            0b00110000,
            0b00000000,
};

const char * base[] = { d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10 };

////////////////////////////////////////////////////////////////////////////////
// CGA Colors
// 0 BLACK      8 DARKGRAY
// 1 BLUE       9 LIGHTBLUE
// 2 GREEN     10 LIGHTGREEN
// 3 CYAN      11 LIGHTCYAN
// 4 RED       12 LIGHTRED
// 5 MAGENTA   13 LIGHTMAGENTA
// 6 BROWN     14 YELLOW
// 7 GRAY      15 WHITE

// .......# ........
// ......## #.......
// ......## #.......
// ..###### #####...
// .####### ######..
// .####### ######..
// .####### ######..
// .####### ######..
const char laserbase1[] = {

  0x00,0x00,0x00,0x0b, 0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0xbb, 0xb0,0x00,0x00,0x00,
  0x00,0x00,0x00,0xbb, 0xb0,0x00,0x00,0x00,
  0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xb0,0x00,
  0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00,
  0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00,
  0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00,
  0x0b,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00,
};

// ........ #.......
// .......# ##......
// .......# ##......
// ...##### ######..
// ..###### #######.
// ..###### #######.
// ..###### #######.
// ..###### #######.
const char laserbase2[] = {

  0x00,0x00,0x00,0x00, 0xb0,0x00,0x00,0x00,
  0x00,0x00,0x00,0x0b, 0xbb,0x00,0x00,0x00,
  0x00,0x00,0x00,0x0b, 0xbb,0x00,0x00,0x00,
  0x00,0x0b,0xbb,0xbb, 0xbb,0xbb,0xbb,0x00,
  0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0,
  0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0,
  0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0,
  0x00,0xbb,0xbb,0xbb, 0xbb,0xbb,0xbb,0xb0,
};

int laserbase_mpos;

////////////////////////////////////////////////////////////////////////////////
void init_invaders(){
  
  laserbase_mpos = 200*160;
}

int mmpos;
////////////////////////////////////////////////////////////////////////////////
void printsprite (char *sprite, int mpos){

  int i,j;
  int index = 0;
  mmpos = mpos;
  for (i = 0; i < 8; i++){
  
  __asm

      ld hl,(_mmpos)
      ld a,l
      out (0x51),a
      ld a,h
      out (0x52),a

    __endasm;
    
    for (j = 0; j < 8; j++)
      video_out(sprite[index++]);
    mmpos += 160;
  }
}

////////////////////////////////////////////////////////////////////////////////
void printsprite2 (char *sprite, int mpos){

  int i,j;
  int index = 0;
  mmpos = mpos;
  for (i = 0; i < 8; i++){
  
  __asm

      ld hl,(_mmpos)
      ld a,l
      out (0x51),a
      ld a,h
      out (0x52),a

    __endasm;
    
    for (j = 0; j < 8; j++)
      video_out(sprite[index++]);
    mmpos += 160;
  }
}

////////////////////////////////////////////////////////////////////////////////
void print_laserbase(int hpos){

  if (hpos & 1)
    printsprite(laserbase2,laserbase_mpos + (hpos>>1));
  else
    printsprite(laserbase1,laserbase_mpos + (hpos>>1));
}

////////////////////////////////////////////////////////////////////////////////
void rasterchar(char d, int line){

    char *base1 = base[d];
    
    char b = 0;
    
    int mask=128;
    int i;
    for (i = 0; i < 4; i++){
      b = 0;
      if (base1[line] & mask)
        b = 0x20;
      mask >>= 1;
      if (base1[line] & mask)
        b |= 0x02;
      mask >>= 1;

      video_out(b);
    }
}

////////////////////////////////////////////////////////////////////////////////
void rasterdec(char d, int line){

    char *base1 = base[d / 10];
    char *base2 = base[d % 10];
    
    char b = 0;
    
    int mask=128;
    int i;
    for (i = 0; i < 4; i++){
      b = 0;
      if (base1[line] & mask)
        b = 0x40;
      mask >>= 1;
      if (base1[line] & mask)
        b |= 0x04;
      mask >>= 1;
    
      video_out(b);
    }

    b = 0;
    mask=128;
    for (i = 0; i < 4; i++){
      b = 0;
      if (base2[line] & mask)
        b = 0x40;
      mask >>= 1;
      if (base2[line] & mask)
        b |= 0x04;
      mask >>= 1;

      video_out(b);
    }
}

////////////////////////////////////////////////////////////////////////////////
void video_printtime(char h, char m, char s){

  int i;
  
  for (i = 0; i < 8; i++){

    video_setpos(i + 110, 48);

    rasterdec(h,i);
    rasterchar(10,i);
    rasterdec(m,i);
    rasterchar(10,i);
    rasterdec(s,i);
  }
}

////////////////////////////////////////////////////////////////////////////////
void video_border(){

  int row = 0;
  int col;
  
  for (row = 1; row < 239; row++){
    video_setpos(row,0); 
    video_out(0x60);
    video_setpos(row,159); 
    video_out(0x06);
  }

  video_setpos(0,0); 
  for (col = 0; col < 160; col++)
    video_out(0x66);
#if 0
  video_setpos(1,0); 
  for (col = 0; col < 160; col++)
    video_out(0xe3);
  video_setpos(2,0); 
  for (col = 0; col < 160; col++)
    video_out(0x5f);
#endif

  video_setpos(239,0); 
  for (col = 0; col < 160; col++)
    video_out(0x66);
}

