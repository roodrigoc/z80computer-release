# Kraft80
# A Z80-based computer for nostalgic enthusiasts
# 2025 - ARMCoder
# Kraftmon - A Memory Monitor - version 1.3.2

Description
===========

  Kraftmon is a console monitor that allows some basic memory operations: manual
  
edit, memory dump, code execution and load programs from serial port.


How to Use
==========

  Plug the USB/Serial adapter to the computer and use a TTY terminal program. 

The serial config is 19200 8N1. Enable RTS/CTS flow control if possible, and

disable any other flow control methods.


  With the serial up and running, by pressing the Kraft80's Reset pushbutton,
  
Kraftmon will reboot and greet the user through the terminal:

        Kraft 80 - Z80 Computer

        KRAFTMON 1.3.2 by ARMCoder
        Ready...

        :


  You can ask for help by pressing '?' and ENTER:
  
        Kraft 80 - Z80 Computer

        KRAFTMON 1.3.2 by ARMCoder
        Ready...

        :?

        HELP
        e [nnnn] : Edit memory
        d [nnnn] : Dump memory
        g [nnnn] : Go
        load     : Load IHEX
        loadx    : Load XMODEM
        cpm      : Enter "CP/M" mode (RAM @0x0000)

        :

  Let's see the commands.
  

Edit Memory
===========

  Allows the user to directly input values to the RAM. The default address is

0x2100. For example:

        :e ENTER

        2100:_

  
  You may type the example program:

        :e ENTER

        2100:db 00 d3 00 18 fa_


  Press ENTER to finish the edit.


Run the code
============

  Press 'g' (Go) and ENTER:
  
        :g
   
        Go!

  
  All IO LEDs will light up. Press the pushbuttons SW1 to SW8 to see the LEDs go

dark for the corresponding button.


Reboot / Dump memory
====================

  Press the Reset pushbutton. The LEDs will go off and the initial greeting will

be printed again.

        Kraft 80 - Z80 Computer

        KRAFTMON 1.3.2 by ARMCoder
        Ready...

        :


  Now press 'd' and ENTER.

        :d
             0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F

        2100:DB 00 D3 00 18 FA F3 76 01 1D 00 78 B1 28 08 11
        2110:06 33 21 AA 26 ED B0 C9 CD 8E 2C 21 F9 FF 39 F9
        2120:21 04 FF 22 00 33 3E 55 CD 45 25 CD 11 26 CD 7A
        2130:26 CD 26 2C 2A 00 33 7E 23 32 02 33 7E 32 03 33
        2140:CD 1F 23 2A 00 33 01 6A 23 71 23 70 CD 21 23 CD
        2150:42 23 3A 0A 33 F5 33 3A 09 33 6F 3A 08 33 CD BC
        2160:2B CD 48 25 4F C5 CD 48 25 C1 DD 77 F9 A9 DD 77
        2170:FA DD 36 FB 00 DD 7E FA E6 01 06 00 DD 71 FC DD

        :
  

  The first bytes are the ones you've typed before (db 00 d3 00 18 fa), the rest 

are just leftovers from previously loaded programs or random garbage from 

uninitialized RAM.


Loading a IHEX program
======================

  This feature loads an image formatted in Intel Hex (aka IHEX). Type 'load' and

ENTER.

        :load
        Send the IHEX file, [ENTER] to abort


  Open the desired IHEX file (ex: clock.ihx in the project clock-c-loadable), 

select all and paste the copied data into the terminal.


        Verify OK.

        ...
        
        Verify OK.

        Verify OK.

        Verify OK.

        Verify OK.

        End of transfer.


  Sometimes the IHEX file may have been fully transfered but the 'End of 

transfer' message may not appear. This happens when the last line of the IHEX

is not terminated with and 'end of line', so a way to fix it is to type the

missing end of line and save the file. 


  Again, to run the program you just loaded, just type 'g' and ENTER.


Loading a program via XMODEM
============================

  This feature loads a binary image using the XMODEM protocol. It's way faster

than the previous method.

        :loadx
        Send the binary via XMODEM, [ENTER] to abort


  Unlike the IHEX file, the binary file does not carry information on where it

'wants' to be positioned in memory, so the 'loadx' command always loads the

binary starting in the position 0x2100.


  Some terminal programs have built-in XMODEM sender functions, this makes
  
things much more practical than having to close the terminal to open a different

XMODEM application, send the file, and reopen the terminal.  


  And, for the last time, to run the program you just loaded, just type 'g' and

ENTER.


The 'cpm' Command
=================

  This command unlocks all the 64k bytes of RAM. At boot, the Kraft80's memory

map is set as 8 kbytes ROM + 56 kbytes RAM. With this command the BIOS ROM is

disabled and the first 8 kbytes are freed to expose the RAM at the same 

location.

  
  Some code trickery is used to copy the reset / interrupt handlers (originally
  
located in the ROM) to the corresponding space in the newly enabled RAM, so

apparently nothing changes when the command is executed. 


  (The LED D11 will light up whenever this special memory mapping is in effect.)


  For now there's no practical use for this feature, its intended (future) use

is to allow execution of the CP/M operating system, hence the 'cpm' command 

name here.


License
=======

  GPL v2.

