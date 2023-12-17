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
#define HUGEPGSIZE 0x20000000000


#define SH_PAGE 	12
#define SH_PTAB 	21
#define SH_PDIR 	30
#define SH_PDPTR 	39
#define SH_PML4 	48

#define MASK_STRUCT	0b111111111 /* 9 Bits*/

#define MASK_PAGE 	0x0000000001FF000
#define MASK_PTAB 	0x00000003FE00000
#define MASK_PDIR 	0x000007FB0000000
#define MASK_PDPTR 	0x000FF8000000000
#define MASK_PML4 	0x1FF000000000000

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
#define GET_PML4(_RM) \
	shr $31, _RM;\
	shr $17, _RM;\
	and $MASK_STRUCT, _RM

#define VADDR_BITS 57 /* Change if not using LA57 */
#define MEMLOW_END	 	0x01FFFFFFFFFFFFFF
#define MEMHIGH_START 	0xFE00000000000000

#define PHYS_ADDR_BEGIN 0xFFFF000000000000

#endif