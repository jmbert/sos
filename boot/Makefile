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

SRCS=\
	entry.S

OBJS=$(patsubst %.S,%.o,$(SRCS))
DEPS=$(OBJS:.o=.d)

CFLAGS+= -m32
ARFLAGS= -Tbootlink.ld -melf_i386

ARCHIVE= boot_kernel.elf
EMPTY_ARCH= boot.a

all: $(OBJS) $(ARCHIVE) 

%.o:%.S
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	-rm $(OBJS)
	-rm $(ARCHIVE)

$(ARCHIVE): $(OBJS)
	$(AR) $(ARFLAGS) -o $@ $^
	cp $@ ..
	ar cru boot.a
	cp boot.a ../

-include $(DEPS)