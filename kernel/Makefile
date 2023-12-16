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
	_start.S\
	init.c

OBJS=$(patsubst %.S,%.o,$(patsubst %.c,%.o,$(SRCS)))
DEPS=$(OBJS:.o=.d)

CFLAGS+=-mcmodel=large

ARCHIVE= $(notdir $(CURDIR)).a

all: $(OBJS) $(ARCHIVE)


%.o:%.c
	$(CC) -c $(CFLAGS) -o $@ $<
%.o:%.S
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	-rm $(OBJS)
	-rm $(ARCHIVE)

$(ARCHIVE): $(OBJS)
	$(AR) $(ARFLAGS) -o $@ $^
	cp $@ ..

-include $(DEPS)