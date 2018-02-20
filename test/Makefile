# Name: Makefile
# Author: Noah Huetter <noahhuetter@gmail.com>



# DEVICE         The AVR device you compile for
# CLOCK          Target AVR clock rate in Hertz
# OBJECTS        The object files created from source files
# PROGRAMMER     Options to avrdude
# FUSES          Parameters for avrdude to flash the fuses appropriately.

######################################################################
MCU            = uc3c1512c
PART           = AVR32_UC3C1512CREVC
AVRDUDEDEVICE  = 

CLOCK      = 8000000
PROGRAMMER = -c arduino -P /dev/tty.usb* -b 19200 
OBJECTS    = main.o
FUSES      = -U lfuse:w:0x64:m -U hfuse:w:0xdd:m -U efuse:w:0xff:m
######################################################################

# C Header files
INC    = loop.h defs.h
INCDIR = -I/usr/local/avr32/atmel-headers-6.1.3.1475
# C sources
CSRC    = main.c
COBJ    = $(CSRC:.c=.o)
# Libraries
LIBS   = 
# output name
TARGET = main


######################################################################
# binaries
CC      = avr32-gcc
OBJCOPY = avr32-objcopy

RM      = rm -rf

AVRDUDE = avrdude $(PROGRAMMER) -p $(AVRDUDEDEVICE)

# Flags
CFLAGS  = -Wall -DF_CPU=$(CLOCK) -D$(PART) -mmcu=$(DEVICE)
LIBPATH = -L.
LDFLAGS = -o $(TARGET) $(LIBPATH) $(LIBS)


# Compile and Assemble C Source Files into Object Files
%.o: %.c
       $(CC) $(CFLAGS) -c $< -o $@

# Link all Object Files with external Libraries into Binaries
$(TARGET).elf: $(COBJ)
       $(CC) $(LDFLAGS) $(COBJ)

$(TARGET).hex: $(TARGET).elf
       $(OBJCOPY) -j .text -j .data -O ihex $(TARGET).elf $(TARGET).hex

# Objects depend on these Libraries
$(COBJ): $(INC)

flash:	$(TARGET)
	$(AVRDUDE) -U flash:w:main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

install: flash fuse

# default target
all: $(TARGET).hex

# Clean Up Objects, Exectuables, Dumps out of source directory
clean:
       $(RM) $(COBJ) $(TARGET).elf $(TARGET).hex

.PHONY: all clean flash fuse install
######################################################################



