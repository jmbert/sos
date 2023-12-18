/*    Small Operating System
    Copyright (C) 2023 jmbert

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/

/*
	Gets information about the kernel from the linker
	and makes it available to C code
*/

#ifndef _KINFO_H
#define _KINFO_H

#include <getlink.h>

extern void *KERNEL_VMA_START;
extern void *KERNEL_VMA_END;
extern void *KERNEL_LOAD_SIZE;
extern void *KERNEL_PMA_START;
extern void *HIGHER_MEMORY_HALF;


#endif