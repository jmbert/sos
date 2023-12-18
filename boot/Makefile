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
	entry.S\
	loadgdt.S

OBJS=$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SRCS)))
DEPS=$(OBJS:.o=.d)

ARCHIVE= $(notdir $(CURDIR)).o

all: $(OBJS) $(ARCHIVE) 

%.o:%.c
	$(CC) -c $(CFLAGS) -o $@ $<
%.o:%.S
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	-rm $(OBJS)
	-rm $(ARCHIVE)
	-rm $(DEPS)

$(ARCHIVE): $(OBJS)
	$(AR) $(ARFLAGS) -o $@ $^
	cp $@ ..

-include $(DEPS)