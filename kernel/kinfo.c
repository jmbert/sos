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

#include <kinfo.h>

LINKVALUE(KERNEL_VMA_START, KERNEL_VMA, void *);
LINKVALUE(KERNEL_VMA_END, KERNEL_END, void *);
LINKVALUE(KERNEL_LOAD_SIZE, KERNEL_SIZE, void *);
LINKVALUE(KERNEL_PMA_START, KERNEL_PMA, void *);
LINKVALUE(HIGHER_MEMORY_HALF, HIGH_OFFSET, void *);