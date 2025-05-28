all:		picalc.ihx

picalc.ihx:	picalc.s
		sdasz80 -o -l -s -g picalc.s
		#sdcc -mz80 --no-std-crt0 -Wl -b_CODE=0x0000,-b_DATA=0x2000 picalc.rel
		sdcc -mz80 --no-std-crt0 picalc.rel

clean:
		rm *.ihx *.map *.sym *.lk *.rel *.lst *.noi *.asm *.mem *.hex

