###################################################
# Kraft80                                         #
# A Z80-based computer for nostalgic enthusiasts  #
# 2025 - ARMCoder                                 # 
###################################################

Q & A
=====

What is this?
=============

  For starters, this is no more than a hobby project: a Z80-based computer. By

no means it aims to be a practical solution to anything, as any modern 

microcontroller can do much better with lower cost, lower complexity, lower

power consumption and much more ease of use. You can eventually make changes on

it to perform some practical automation tasks and it WILL work, it's just not

recommended nowadays. Get a PIC or Arduino instead.


Why did you build it?
=====================

  There's a guy here in Brazil that offers training in several electronics

disciplines, including microprocessor / microcontroller programming. One of his

courses is Z80-based, and he also offers for sale a parts kit and schematics to

build a computer, that he calls "Z80 Alpha". This kit is suggested as a 

complement to his Z80 programming course.


  (Just for the record, his website is www.wrkits.com.br).


  I bought the parts kit and built the aformentioned Z80 Alpha on a universal

PCB and LOTS of wire (good thing the kit included the DIP sockets and a ZIF

socket for the BIOS memory).


What is the 'AlphaPlus' directory?
==================================

  Very soon I noticed that the original "Z80 Alpha" was very lacking in memory

(just 2 kbytes BIOS + 2 kbytes RAM), so I made changes to it, yielding 8 kbytes 

BIOS + 56 kbytes RAM).


  This first iteration, then, is what I called 'Z80 Alpha Plus' and can be found
in the AlphaPlus directory and its children.


  If you check the schematics (AlphaPlus.pdf), you will find there U2, U9 and 

U90, the memory chips. Close to U2 and U9 there are jumpers (JP8/JP5/JP6) that

select the memory types, and also JP7 close to U3/U91 that change the address

decoding. The resulting hardware is then dual-role, the original "Z80 Alpha"

and also the "Z80 Alpha Plus" depending on the jumpers and chips used.


  VALID COMBINATIONS:

  +--------------------+-------+------+-------+
  | JP8  JP5  JP6  JP7 |  U2   |  U9  |  U90  |        
  +--------------------+-------+------+-------+----------------------+
  | 1-2  1-2  1-2  1-2 | 28C16 | 6116 |REMOVED| Z80 ALPHA (Original) |
  +--------------------+-------+------+-------+----------------------+
  | 2-3  2-3  2-3  2-3 | 28C64 | 62256| 62256 | Z80 ALPHA PLUS       |
  +--------------------+-------+------+-------+----------------------+


Are there any software for the 'AlphaPlus'?
===========================================

  The AlphaPlus is a project that I didn't want to keep developing for long, so
  
there are just two runnable demos: 'picalc-alphaplus' and 'amon2-alphaplus'.

Both must be written in a type of compatible parallel ROM (EPROM or EEPROM,

typically) and run natively from the BIOS socket. A 28C64 will do the job,

although these programs are small and can fit in smaller chips.


  The 'picalc-alphaplus' is a small demo that calculates PI with a high degree
  
of precision and prints the result in the LCD display. It uses real floating-

point math and a relatively fast method called 'BBP' - not that the Z80 can be

considered any fast by today standards.


  The 'amon2-alphaplus' is a minimalistic memory monitor that uses the
  
pushbuttons and the LCD to input values into the RAM and then execute the code

inserted. It's not very practical but works, and can be used for small, quick

tests. This program is essentially the same that's shipped with the original

'Z80 Alpha' files bundle from wrkits.com.br, I just adjusted some constants to

make it compatible with the new memory map.


Will there be any future developments or software for the AlphaPlus?
====================================================================

  No. See the 'Kraft80' project instead.


What is the Kraft80 computer, then?
===================================

  Now that you have a slight notion of what the 'Z80 Alpha Plus' is all about, 

let's see what Kraft80 has to offer. The Kraft80, basically, 'grew' over the Z80

Alpha Plus. Now it's a great time to find the 'Kraft80.pdf' schematic and look 

around.


  The first change is that the memory types and sizes got fixed, so there are no

longer 'memory type select' nor 'addressing mode select' jumpers. This allowed 

for some cleanup in the board.

  
  The IO decoding was streamlined to accomodate the new peripherals: a UART, an
  
interrupt controller, a pair of D-flipflops and (yes!) a video controller!

  
Kraft80 Basic Characteristics
=============================

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

