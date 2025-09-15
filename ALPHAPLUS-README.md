## Preamble

  This README is supplied solely for historic purposes, its contents is not 

needed to understand the workings of the Kraft80 project.
  

## How it began

  There's a guy here in Brazil that offers training in several electronics

disciplines, including microprocessor / microcontroller programming. One of his

courses is Z80-based, and he also offers for sale a parts kit and schematics to

build a computer, that he calls "Z80 Alpha". This kit is suggested as a 

complement to his Z80 programming course.


  (Just for the record, his website is www.wrkits.com.br).


  I bought the parts kit and built the aformentioned Z80 Alpha on a universal

PCB and LOTS of wire (good thing the kit included the DIP sockets and a ZIF

socket for the BIOS memory).


## What is the 'AlphaPlus' directory?

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

```

  VALID COMBINATIONS:

  +--------------------+-------+------+-------+
  | JP8  JP5  JP6  JP7 |  U2   |  U9  |  U90  |        
  +--------------------+-------+------+-------+----------------------+
  | 1-2  1-2  1-2  1-2 | 28C16 | 6116 |REMOVED| Z80 ALPHA (Original) |
  +--------------------+-------+------+-------+----------------------+
  | 2-3  2-3  2-3  2-3 | 28C64 | 62256| 62256 | Z80 ALPHA PLUS       |
  +--------------------+-------+------+-------+----------------------+

```

## Are there any software for the 'AlphaPlus'?

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


## Will there be any future developments or software for the AlphaPlus?

  No. See the 'Kraft80' project instead.


## Acknlowledgements

  Thanks to Wagner Rambo from WRKits for the inspiration!

