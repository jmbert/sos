#    Small Operating System
#    Copyright (C) 2023 jmbert
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

PREFIX?=$(HOME)/opt/cross/

TARGET?=x86_64-elf

CC=$(TARGET)-gcc
CCVER=$(shell $(CC) -dumpversion)
LD=$(TARGET)-ld
AR=$(LD)
ARFLAGS=-r

CCLIB=$(PREFIX)lib/gcc/$(TARGET)/$(CCVER)/

CFLAGS= -mcmodel=large -m64 -Wno-int-conversion --std=gnu2x -mno-red-zone -mno-mmx -mno-sse -mno-sse2 \
		 -ffreestanding -nostdlib -MD -Wall -D__in_kernel -I$(realpath $(CURDIR))/include
LDFLAGS= -L$(CCLIB) -lgcc --whole-archive

DISKOUTSIZE=100
DISKOUTCHUNKS=1048576

export CC AR AS LD CFLAGS ARFLAGS

SUBDIRS= \
	boot\
	kernel

SUBDIRTARGETS= $(patsubst %,%.d,$(SUBDIRS))

SUBDIRSCLEAN= $(patsubst %,%.clean,$(SUBDIRTARGETS))
SUBARCHIVES=$(patsubst %,%.o,$(SUBDIRS))

all: $(SUBDIRTARGETS) kernel.elf kernel.dd

clean: $(SUBDIRSCLEAN)
	-rm kernel.elf
	-rm kernel.dd
	-rm -rf sysroot
	-rm -rf sysboot

sysroot:
	-mkdir sysroot
	-mkdir -p sysroot/usr/include
	-mkdir -p sysroot/usr/lib

%.d:
	cd $* && $(MAKE) all

%.d.clean:
	cd $* && $(MAKE) clean

kernel.elf: $(SUBARCHIVES) linker.ld
	$(LD) -Tlinker.ld $(LDFLAGS) -o $@ $(SUBARCHIVES)

kernel.dd: kernel.elf mkdiskimg sysroot
	DISKSIZE=$(DISKOUTSIZE) DISKCHUNKS=$(DISKOUTCHUNKS) ./mkdiskimg $@ sysroot
	