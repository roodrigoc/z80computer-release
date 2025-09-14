all:				invaders.bin

invaders.bin:			invaders.s
				sdasz80 -o -l -s -g invaders.s
				sdcc -mz80 --no-std-crt0 invaders.rel
				objcopy --input-target=ihex --output-target=binary invaders.ihx invaders.bin

clean:
				rm -f *.ihx *.map *.sym *.lk *.rel *.lst *.noi *.asm *.mem *.hex *.bin

