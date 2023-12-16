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

#ifndef _MBINFO_H
#define _MBINFO_H

#include <compiler.h>

#define MB_BOOT_MAGIC 0x2BADB002

#ifndef __ASSEMBLER__

typedef unsigned char mb_u8;
typedef unsigned short mb_u16;
typedef unsigned int mb_u32;
typedef unsigned long long mb_u64;

enum
{
	MB_MEMINFO = 1<<0,
	MB_BOOTDEV = 1<<1,
	MB_CMD = 1<<2,
	MB_MODS = 1<<3,
	MB_AOUTSYM = 1<<4,
	MB_ELFSYM = 1<<5,
	MB_MMAP = 1<<6,
	MB_DRIVES = 1<<7,
	MB_CFGTABLE = 1<<8,
	MB_BOOTNAME = 1<<9,
	MB_APMTABLE = 1<<10,
	MB_VBEINFO = 1<<11,
	MB_FRAMEBUFFER = 1<<12,
};

typedef struct __packed
{
	mb_u32 mb_flags;

	mb_u32 mb_memlow;
	mb_u32 mb_memhigh;

	mb_u32 mb_bootdev;

	mb_u32 mb_cmd;

	mb_u32 mb_modcount;
	mb_u32 mb_modaddr;

	union __packed
	{
		struct __packed
		{
			mb_u32 tabsize;
			mb_u32 strsize;
			mb_u32 addr;
			mb_u32 res;
		}aout;
		
		struct __packed
		{
			mb_u32 num;
			mb_u32 size;
			mb_u32 addr;
			mb_u32 shndx;
		}elf;
	}mb_syms;

	mb_u32 mb_mmap_len;
	mb_u32 mb_mmap_addr;

	mb_u32 mb_drive_len;
	mb_u32 mb_drive_addr;

	mb_u32 mb_cfg_table;

	mb_u32 mb_bootid;

	mb_u32 mb_apm_table;

	mb_u32 mb_vbe_ctrl_info;
	mb_u32 mb_vbe_mode_info;
	mb_u16 mb_vbe_mode;
	mb_u16 mb_vbe_interface_seg;
	mb_u16 mb_vbe_interface_off;
	mb_u16 mb_vbe_interface_len;

	mb_u64 mb_framebuffer_addr;
	mb_u32 mb_framebuffer_pitch;
	mb_u32 mb_framebuffer_width;
	mb_u32 mb_framebuffer_height;
	mb_u8  mb_framebuffer_bpp;
	mb_u8  mb_framebuffer_type;

	union __packed
	{
		struct __packed
		{
			mb_u32 pal_addr;
			mb_u32 pal_ncol;
		}col_indexed;

		struct __packed
		{
			mb_u8 red_field_position;   
			mb_u8 red_mask_size;        
			mb_u8 green_field_position; 
			mb_u8 green_mask_size;      
			mb_u8 blue_field_position;  
			mb_u8 blue_mask_size;       
		}col_direct;
	}mb_framebuffer_cinfo;
}mb_info_t;

typedef struct __packed
{
	mb_u32 modstart;
	mb_u32 modend;
	mb_u32 modname;
	mb_u32 reserved;
}mb_module;

enum
{
	MB_FRAMEBUFFER_INDEXED,
	MB_FRAMEBUFFER_DIRECT,
	MB_FRAMEBUFFER_TEXT,
};

typedef struct __packed
{
	mb_u8 r;
	mb_u8 g;
	mb_u8 b;
}mb_col_desc;

typedef struct __packed
{
	mb_u64 base_addr;
	mb_u64 len;
	mb_u32 type;
}mb_mmap_entry;

enum
{
	MB_MMAP_AVL = 1,
	MB_MMAP_ACPI = 3,
	MB_MMAP_RESRV = 4,
	MB_MMAP_BADRAM = 5,
};

typedef struct __packed
{
	mb_u32 size;
	mb_u8 drive_num;
	mb_u8 drive_mode;
	mb_u16 drive_cylinders;
	mb_u8 drive_heads;
	mb_u8 drive_sectors;
	mb_u16 drive_ports[];
}mb_drive_entry;

enum
{
	MB_DRIVE_CHD,
	MB_DRIVE_LBA,
};

typedef struct
{
	mb_u16 version;
	mb_u16 cseg;

	mb_u32 offset;

	mb_u16 cseg_16;
	mb_u16 dseg;
	mb_u16 flags;
	mb_u16 cseg_len;
	mb_u16 cseg_16_len;
	mb_u16 dseg_len;
}mb_apm_table;

#endif

#endif