# Name: Makefile
# Author: Noah Huetter <noahhuetter@gmail.com>



# DEVICE         The AVR device you compile for
# CLOCK          Target AVR clock rate in Hertz
# OBJECTS        The object files created from source files
# PROGRAMMER     Options to avrdude
# FUSES          Parameters for avrdude to flash the fuses appropriately.

DEVICE     = attiny2313
CLOCK      = 8000000
PROGRAMMER = -c arduino -P /dev/tty.usb* -b 19200 
OBJECTS    = main.o
FUSES      = -U lfuse:w:0x64:m -U hfuse:w:0xdd:m -U efuse:w:0xff:m

######################################################################

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
CC = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)
OBJCOPY = avr-objcopy

# symbolic targets:
all: main.hex

.c.o:
	$(CC) -c $< -o $@

.S.o:
	$(CC) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(CC) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

install: flash fuse

clean:
	rm -f main.hex main.elf $(OBJECTS)

# file targets:
main.elf: $(OBJECTS)
	$(CC) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex
	$(OBJCOPY) -j .text -j .data -O ihex main.elf main.hex

