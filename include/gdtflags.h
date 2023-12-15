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

#ifndef _GDTFLAGS_H
#define _GDTFLAGS_H

#define GDT_PRESENT 1 << 7
#define GDT_DESC 1 << 4
#define GDT_EXEC 1 << 3
#define GDT_DC 1 << 2
#define GDT_RW 1 << 1
#define GDT_A 1 << 0

#endif