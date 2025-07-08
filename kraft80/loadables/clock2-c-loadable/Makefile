all:				clock.bin

clock.bin:			crt0-kraft80-loadable.s clock.c io-kraft80.c io-kraft80.h videodisp.c videodisp.h
				sdasz80 -o -l -s -g crt0-kraft80-loadable.s
				sdcc -c -V --disable-warning 85 -mz80 --opt-code-size --std-sdcc99 clock.c
				sdcc -c -V --disable-warning 85 -mz80 --opt-code-size --std-sdcc99 io-kraft80.c
				sdcc -c -V --disable-warning 85 -mz80 --opt-code-size --std-sdcc99 videodisp.c
				sdcc -mz80 --code-loc 0x2A00 --no-std-crt0 -Wl -b_MAIN=0x2100,-b_DATA=0x3300 crt0-kraft80-loadable.rel clock.rel io-kraft80.rel videodisp.rel
				mv crt0-kraft80-loadable.ihx clock.ihx
				objcopy --input-target=ihex --output-target=binary clock.ihx clock.bin

clean:
				rm -f *.ihx *.map *.sym *.lk *.rel *.lst *.noi *.asm *.mem *.hex *.bin

