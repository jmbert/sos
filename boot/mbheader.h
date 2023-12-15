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

#ifndef _MBHEADER_H
#define _MBHEADER_H

#include <mbvideo.h>

#define MB_HEADER_MAGIC 0x1BADB002

#define MB_FLAGS_HEADER_PALIGN 1<<0
#define MB_FLAGS_HEADER_MEM 1<<1
#define MB_FLAGS_HEADER_VIDEO 1<<2
#define MB_FLAGS (MB_FLAGS_HEADER_PALIGN | MB_FLAGS_HEADER_MEM | MB_FLAGS_HEADER_VIDEO)
#define MB_CHECKSUM -(MB_HEADER_MAGIC + MB_FLAGS)

#define MB_HEADER \
	.long MB_HEADER_MAGIC; \
	.long MB_FLAGS; \
	.long MB_CHECKSUM;

#define MB_HEADER_PASS \
	.space 24;\
	.long MB_HEADER_VIDEO_MODE; \
	.long MB_HEADER_VIDEO_WIDTH; \
	.long MB_HEADER_VIDEO_HEIGHT; \
	.long MB_HEADER_VIDEO_DEPTH;

#endif