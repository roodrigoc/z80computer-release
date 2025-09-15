# Kraft80
A Z80-based computer for nostalgic enthusiasts\
2025 - ARMCoder

<IMG SRC="https://github.com/ARMCoderBR/z80computer-release/blob/main/kraft80/kraft80-1.jpg?raw=true" width=600>


## Q & A

## What is this?

  For starters, this is no more than a hobby project: a Z80-based computer. By

no means it aims to be a practical solution to anything, as any modern 

microcontroller can do much better with lower cost, lower complexity, lower

power consumption and much more ease of use. You can eventually make changes on

it to perform some practical automation tasks and it WILL work, it's just not

recommended nowadays. Get a PIC or Arduino instead.


## Why did you build it?

  There's a guy here in Brazil that offers training in several electronics

disciplines, including microprocessor / microcontroller programming. One of his

courses is Z80-based, and he also offers for sale a parts kit and schematics to

build a computer, that he calls "Z80 Alpha". This kit is suggested as a 

complement to his Z80 programming course.


  (Just for the record, his website is www.wrkits.com.br).


  I bought the parts kit and built the aformentioned Z80 Alpha on a universal

PCB and LOTS of wire (good thing the kit included the DIP sockets and a ZIF

socket for the BIOS memory).

  See ALPHAPLUS-README.md for historic background on this specific project.



## What is the Kraft80 computer, then?

  Now that you have a slight notion of what the 'Z80 Alpha Plus' is all about, 

let's see what Kraft80 has to offer. The Kraft80, basically, 'grew' over the Z80

Alpha Plus. Now it's a great time to find the 'Kraft80.pdf' schematic and look 

around.

<IMG SRC="https://github.com/ARMCoderBR/z80computer-release/blob/main/kraft80/kraft80-2.jpg?raw=true" width=600>

  The first change is that the memory types and sizes got fixed, so there are no

longer 'memory type select' nor 'addressing mode select' jumpers. This allowed 

for some cleanup in the board.

  
  The IO decoding was streamlined to accomodate the new peripherals: a UART, an
  
interrupt controller, a pair of D-flipflops and (yes!) a video controller!

  
## Kraft80 Basic Characteristics

```
  CPU:   Z80A, 4 MHz

  BIOS:  8 kbytes

  RAM:   8 kbytes (disabled at boot) + 56 kbytes (the lower 8 k can be remapped
         over the BIOS, yielding the full 64 kbytes ready for use)

  IO PORTS:

      PORT 0x00 (R):  8 pushbuttons

      PORT 0x00 (W):  8 programmable LEDs

      PORT 0x10 (W):  LCD 16x2 Alphanumeric

      PORT 0x20 (RW): 8251 UART

      PORT 0x30 (RW): 8259 Interrupt Controller (UART + Timer)

      PORT 0x40 (W):  Aux Flipflops

      PORT 0x50 (RW): Video Controller Data (R/W)
      PORT 0x51 (W):  Video Controller Address L
      PORT 0x52 (W):  Video Controller Address H

  POWER: 5V 1A (via USB)

  COMM:  Async 19200 BPS, 8N1

  VIDEO: VGA 640x480 @60Hz (mapped as 320x240, 4BPP, 16 colors) - HDMI output
```

What can the Kraft80 currently do?
==================================

  Through its serial port, it can have software downloaded to its RAM. A serial

monitor, 'Kraftmon' (that runs on the BIOS ROM), is supplied for this purpose.


  Kraftmon also has functions to edit and display the RAM contents using the

serial terminal, so it supersedes the old Amon2 monitor (that's also supplied

for the Kraft80, BTW) by far.


  BASIC Interpreter: one of the available ROM images is the Microsoft BASIC 4.7b

interpreter. I did the adjustments to make this BASIC work in Text mode over the

serial port on the Kraft80. For those really nostalgic, there are some nice

text-only games written in BASIC at this repository:

                    http://vintage-basic.net/games.html


  Remember that in order to switch ROM programs, the actual ROM chip needs to be

replaced (and because of that, a ZIF socket is instrumental to keep the process

smooth and safe!). 


  As the VGA controller is the latest addition to the Kraft80, not much software

is available for it (yet). Currently, there's a clock demo (written in C) and

I'm writing a Space Invaders clone (this one in pure Assembly). I'm planning to

find out whether I can integrate graphics function into that BASIC interpreter!


Need more info?
===============

  Checkout the other documents in this package for more detais in the build and

operation of the Kraft80, there are tons of details!

