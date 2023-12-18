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

#ifndef _PGSIZES_H
#define _PGSIZE_H

#define PGSTRUCT_SIZE 0x1000
#define PGSTRUCTENTRY_SIZE 8
#define PGSTRUCT_LEN 0x200

#define PGSIZE 0x1000
#define BIGPGSIZE 0x200000
#define HUGEPGSIZE 0x20000000

#define SH_PAGE 	0xc
#define SH_PTAB 	0x15
#define SH_PDIR 	0x1e
#define SH_PDPTR 	0x27

#define MASK_STRUCT	0b111111111 /* 9 Bits*/

#define GET_PAGE(_RM) \
	shr $SH_PAGE, _RM;\
	and $MASK_STRUCT, _RM
#define GET_PTAB(_RM) \
	shr $SH_PTAB, _RM;\
	and $MASK_STRUCT, _RM
#define GET_PDIR(_RM) \
	shr $SH_PDIR, _RM;\
	and $MASK_STRUCT, _RM;
#define GET_PDPTR(_RM) \
	shr $31, _RM;\
	shr $8, _RM;\
	and $MASK_STRUCT, _RM

#endif