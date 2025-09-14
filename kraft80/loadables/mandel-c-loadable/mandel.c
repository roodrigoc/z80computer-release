/*
MANDEL.C
Example program for the KRAFT 80
2025 - ARM Coder
*/

#include <stdio.h>
#include <ctype.h>

#include "io-kraft80.h"

#pragma codeseg MAIN

#define X0 160.0
#define Y0 120.0
#define SCALE 80
#define ITMAX 15

////////////////////////////////////////////////////////////////////////////////
void plot (int x, int y, int color){

	video_setpos(y, x >> 1);

	int b = video_in();
	if (x & 1){
		b &= 0xf0;
		b |= (color & 0x0f);
	}
	else{
		b &= 0x0f;
		b |= (color << 4);
	}

	video_out(b);
}

////////////////////////////////////////////////////////////////////////////////
void plot2 (int x, int y, int color){

	int b = color << 4; b |= (color & 0x0f);

	video_setpos(y, x >> 1);
	video_out(b);
	video_setpos(y+1, x >> 1);
	video_out(b);
}

////////////////////////////////////////////////////////////////////////////////
void main (void){

	video_begin(1);

	int ix,iy;

	float x0;
	float y0;
	float x;
	float y;
	int itcount;
	float xtemp,xx,yy;

	int step = 4;

	for (iy = 0; iy < 240; iy+=step){

		for (ix = 0; ix < 320; ix+=step){

			x0 = ((float)ix - X0)/SCALE;
			y0 = ((float)iy - Y0)/SCALE;
			x = 0.0;
			y = 0.0;
			itcount = 0;

			while (itcount < ITMAX) {

				xx = x*x;
				yy = y*y;

				if (xx + yy > 4.0)
					break;

				xtemp = xx-yy+x0;
				y = 2 * x*y + y0;
				x = xtemp;
				itcount++;
			}

			if (step == 1)
				plot (ix, iy, itcount);
			else
			for (int i = 0; i < step; i+=2){
				for (int j = 0; j < step; j++)
					plot2 (ix+j, iy+i, itcount);
			}
		}
	}

	for (;;);
}










