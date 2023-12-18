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

#ifndef _COMPILER_H
#define _COMPILER_H

#define __noreturn [[noreturn]]

#define __packed [[gnu::packed]]

#define __align(_n) [[gnu::aligned(_n)]]


#ifdef __ASSEMBLER__
	#define __fail ud2
#else
	#define __fail __builtin_unreachable
#endif


#endif