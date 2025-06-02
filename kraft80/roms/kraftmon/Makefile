all:			kraftmon.ihx

kraftmon.ihx:		kraftmon.c crt0-kraft80.s io-kraft80.c io-kraft80.h
			sdcc -c -V --disable-warning 85 -mz80 --opt-code-size --std-sdcc99 kraftmon.c
			sdcc -c -V --disable-warning 85 -mz80 --opt-code-size --std-sdcc99 io-kraft80.c
			sdasz80 -o -l -s -g crt0-kraft80.s
			#sdcc -mz80 --no-std-crt0 -Wl -b_CODE=0x200,-b_DATA=0x2000 crt0-kraft80.rel kraftmon.rel io-kraft80.rel
			sdcc -mz80 --no-std-crt0 -Wl -b_DATA=0x2000 crt0-kraft80.rel kraftmon.rel io-kraft80.rel
			mv crt0-kraft80.ihx kraftmon.ihx

clean:
			rm -f *.ihx *.map *.sym *.lk *.rel *.lst *.noi *.asm *.mem *.hex

