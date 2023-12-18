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
	See KINFO.txt for where these values come from
*/

#ifndef _MEMINFO_H
#define _MEMINFO_H

#define USER_VMA_BEGIN 		0x0000000000000000
#define USER_VMA_END 		0x00007FFFFFFFFFFF

#define PHYS_VMA_BEGIN 		0xFFFF888000000000
#define PHYS_VMA_END		0xFFFFC87FFFFFFFFF
#define PHYS_VMA_SIZE		0x0000400000000000

#define physaddr_begin PHYS_VMA_BEGIN

#define KERNEL_VMA_BEGIN 	0xFFFFFFFF80000000
#define KERNEL_VMA_END 		0xFFFFFFFFFFFFFFFF

#endif