all:				mandel.bin

mandel.bin:			mandel.c ../io-kraft80/io-kraft80.h ../io-kraft80/crt0-kraft80-loadable.rel ../io-kraft80/io-kraft80.rel 
				sdcc -c -V --disable-warning 85 -mz80 -I../io-kraft80 --opt-code-size --std-sdcc99 mandel.c
				#sdcc -mz80 --code-loc 0x3200 -DUSE_KRAFTMON=1 --no-std-crt0 -Wl -b_MAIN=0x2100,-b_DATA=0x3800 ../io-kraft80/crt0-kraft80-loadable.rel ../io-kraft80/io-kraft80.rel mandel.rel
				sdcc -mz80 --code-loc 0x5400 -DUSE_KRAFTMON=0 --no-std-crt0 -Wl -b_MAIN=0x4200,-b_DATA=0x5900 ../io-kraft80/crt0-kraft80-loadable.rel ../io-kraft80/io-kraft80.rel mandel.rel
				mv crt0-kraft80-loadable.ihx mandel.ihx
				objcopy --input-target=ihex --output-target=binary mandel.ihx mandel.bin

clean:
				rm -f *.ihx *.map *.sym *.lk *.rel *.lst *.noi *.asm *.mem *.hex *.bin

