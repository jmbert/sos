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

#include <compiler.h>
#include <mbinfo.h>
#include <elf.h>
#include <stddef.h>
#include <getlink.h>
#include <pgsizes.h>
#include <pgflags.h>

LINKVALUE(high_offset, BOOT_HIGHER_OFFSET, unsigned long);

unsigned long long pml4[PGSTRUCT_LEN] __align(PGSIZE);
unsigned long long pdpt[PGSTRUCT_LEN] __align(PGSIZE);
unsigned long long pd[PGSTRUCT_LEN] __align(PGSIZE);
unsigned long long pt[PGSTRUCT_LEN] __align(PGSIZE);

static int _strcmp(char *s1, char *s2)
{
    while(*s1 && (*s1 == *s2))
    {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

static elf_ehdr64 *search_kernel(mb_module *modules, unsigned int modlen)
{
	for (unsigned int i = 0;i < modlen;i++)
	{
		mb_module mod = modules[i];
		if (!_strcmp("kernel", (char*)mod.modname + high_offset))
		{
			return (elf_ehdr64*)(mod.modstart + high_offset);
		}
	}
	return NULL;
}

static int validate_kernel_elf(elf_ehdr64 *kernel)
{
	return (
		(kernel->ident.eident_ver == 1 &&
		kernel->ehdr_version == 1) &&
		
		kernel->ehdr_type == ELF_TYPE_EXEC &&

		kernel->ehdr_entry != 0 &&

		kernel->ident.eident_magic == ELF_MAGIC
	);
}

static void add_page(unsigned long addr, unsigned long paddr)
{
	unsigned int pdptindex = 	(addr & 		((unsigned long long)(0x1FF) << 39)) >> 39;
	unsigned int pdindex = 		(addr & 		((unsigned long long)(0x1FF) << 30)) >> 30;
	unsigned int ptindex = 		(addr & 		((unsigned long long)(0x1FF) << 21)) >> 21;
	unsigned int pindex = 		(addr & 		((unsigned long long)(0x1FF) << 12)) >> 12;
	
	pml4[pdptindex] = 	((unsigned long)pdpt - high_offset) | (PML4E_P | PML4E_RW);
	pdpt[pdindex] = 	((unsigned long)pd - high_offset)| (PDPTE_P | PDPTE_RW);
	pd[ptindex] = 		((unsigned long)pt - high_offset)| (PDE_P | PDE_RW);
	pt[pindex] = 		((paddr & 0xFFFFFFFFF000) - high_offset)| (PTE_P | PTE_RW);
}

static void add_phdr(elf_phdr64 phdr, unsigned long fstart)
{
	unsigned int phaddr = phdr.p_vaddr;
	unsigned int phsize = phdr.p_size;
	if (phsize == 0)
	{
		return;
	}
	unsigned int phpaddr = fstart+phdr.p_off;

	unsigned int done_size = 0;
	do
	{
		add_page(phaddr+done_size, phpaddr+done_size);
		done_size += PGSIZE;
	} while (done_size < phsize);
}

static void setup_pml4(elf_phdr64 *phdrs, unsigned int phdrlen, unsigned long fstart)
{
	for (unsigned int i = 0; i < phdrlen; i++)
	{
		add_phdr(phdrs[i], fstart);
	}
}

char empty_page[PGSIZE];

static void map_entry(unsigned long entry, unsigned long long *page_table)
{
	entry -= high_offset;
	unsigned int pindex = ((entry-1) & ((unsigned long long)(0x1FF) << 12)) >> 12;

	page_table[pindex] = (unsigned long long)(empty_page - high_offset) | (PTE_P | PTE_RW) ;
}

__noreturn extern void switch_to_kernel(unsigned long entry, unsigned long pml4);

__noreturn
void load_elf(mb_info_t *mbinfo, unsigned long long *page_table)
{

	mbinfo = (mb_info_t*)((unsigned long)(mbinfo) + high_offset);
	if (!(mbinfo->mb_flags & MB_MODS))
	{
		__fail();
	}

	mb_module *mods = (mb_module*)(mbinfo->mb_modaddr + high_offset);
	unsigned int modlen = mbinfo->mb_modcount;
	
	elf_ehdr64 *kernel = search_kernel(mods, modlen);
	if (kernel == NULL)
	{
		__fail();
	}

	if (!validate_kernel_elf(kernel))
	{
		__fail();
	}

	unsigned long long entry = kernel->ehdr_entry;

	elf_phdr64 *phrds = ((unsigned long)kernel)+(kernel->ehdr_phoff);

	setup_pml4(phrds, kernel->ehdr_phnum, (unsigned long)kernel);

	map_entry(entry, page_table);

	switch_to_kernel(entry, (unsigned long)pml4 - high_offset);

	__fail();
}