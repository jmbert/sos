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

#ifndef _ELF_H
#define _ELF_H

typedef unsigned char elf_u8;
typedef unsigned short elf_u16;
typedef unsigned int elf_u32;
typedef unsigned long long elf_u64;

#define ELF_MAGIC (elf_u32) 0x464C457F
enum
{
	ELF_CLASS_NONE = 0,
	ELF_CLASS_32,
	ELF_CLASS_64,
};
enum
{
	ELF_NOENDIAN,
	ELF_LITTLEENDIAN,
	ELF_BIGENDIAN,
};
enum 
{
	ELF_ABI_SYSV,
	ELF_ABI_HPUX,
	ELF_ABI_NBSD,
	ELF_ABI_LINUX,
	ELF_ABI_GNUHURD,
	ELF_ABI_SOLARIS,
	ELF_ABI_AIX,
	ELF_ABI_IRIX,
	ELF_ABI_FBSD,
	ELF_ABI_TRU64,
	ELF_ABI_MODESTO,
	ELF_ABI_OBSD,
	ELF_ABI_OVMS,
	ELF_ABI_NSKER,
	ELF_ABI_AROS,
	ELF_ABI_FENIX,
	ELF_ABI_CLOUD,
	ELF_ABI_STRATUS,
};
enum
{
	ELF_TYPE_NONE = 0,
	ELF_TYPE_REL,
	ELF_TYPE_EXEC,
	ELF_TYPE_DYN,
	ELF_TYPE_CORE,

	ELF_TYPE_LOOS = 0xFE00,
	ELF_TYPE_HIOS = 0xFEFF,

	ELF_TYPE_LOPROC = 0xFF00,
	ELF_TYPE_HIPROC = 0xFFFF,
};
enum
{
	ELF_MACHINE_AMD64 = 0x3E,
};

typedef struct __packed
{
	elf_u32 eident_magic;
	elf_u8 	eident_size;
	elf_u8 	eident_endian;
	elf_u8 	eident_ver;
	elf_u8 	eident_osabi;
	elf_u8 	eident_abiver;
	
	elf_u8 ehdr_padding[7];
}elf_eident;

typedef struct __packed
{
	elf_eident ident;

	elf_u16 ehdr_type;

	elf_u16 ehdr_machine;

	elf_u32 ehdr_version;

	elf_u64 ehdr_entry;

	elf_u64 ehdr_phoff;
	elf_u64 ehdr_shoff;

	elf_u32 ehdr_flags;

	elf_u16 ehdr_size;
	elf_u16 ehdr_phentsize;
	elf_u16 ehdr_phnum;
	elf_u16 ehdr_shentsize;
	elf_u16 ehdr_shnum;
	elf_u16 ehdr_shstrndx;
}elf_ehdr64;

enum
{
	ELF_PT_NULL,
	ELF_PT_LOAD,
	ELF_PT_DYNAMIC,
	ELF_PT_INTERP,
	ELF_PT_NOTE,
	ELF_PT_SHLIB,
	ELF_PT_PHDR,
	ELF_PT_TLS,

	ELF_PT_LOOS = 0x60000000,
	ELF_PT_HIOS = 0x6FFFFFFF,

	ELF_PT_LOPROC = 0x70000000,
	ELF_PT_HIPROC = 0x7FFFFFFF,
};

enum
{
	ELF_PF_X,
	ELF_PF_W,
	ELF_PF_R,
};

typedef struct __packed
{
	elf_u32 p_type;
	elf_u32 p_flags;

	elf_u64 p_off;
	elf_u64 p_vaddr;
	elf_u64 p_paddr;
	elf_u64 p_size;
	elf_u64 p_memsz;
	elf_u64 p_align;
}elf_phdr64;

enum
{
	SHT_NULL,
	SHT_PROGBITS,
	SHT_SYMTAB,
	SHT_STRTAB,
	SHT_RELA,
	SHT_HASH,
	SHT_DYNAMIC,
	SHT_NOTE,
	SHT_NOBITS,
	SHT_REL,
	SHT_SHLIB,
	SHT_DYNSYM,
	SHT_INIT_ARRAY,
	SHT_FINI_ARRAY,
	SHT_PREINIT_ARRAY,
	SHT_GROUP,
	SHT_SYMTAB_SHNDX,
	SHT_NUM,

	SHT_LOSS = 0x60000000,
};

enum
{
	SHF_WRITE = 0x1,
	SHF_ALLOC = 0x2,
	SHF_EXECINSTR = 0x4,
	SHF_MERGE = 0x10,
	SHF_STRINGS = 0x20,
	SHF_INFO_LINK = 0x40,
	SHF_LINK_ORDER = 0x80,
	SHF_OS_NONCONFORMING = 0x100,
	SHF_GROUP = 0x200,
	SHF_TLS = 0x400,
	SHF_MASKOS = 0x0FF00000,
	SHF_MASKPROC = 0xF0000000,
	SHF_ORDERED = 0x4000000,
	SHF_EXCLUDE = 0x8000000,
};

typedef struct __packed
{
	elf_u32 sh_name;
	elf_u32 sh_type;
	elf_u64 sh_flags;
	elf_u64 sh_addr;
	elf_u64 sh_offset;
	elf_u64 sh_size;
	elf_u32 sh_link;
	elf_u32 sh_info;
	elf_u64 sh_align;
	elf_u64 sh_entsize;
}elf_shdr64;

#endif