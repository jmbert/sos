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

#include "mbheader.h"
#include <mbinfo.h>
#include <bits/x86/ctrlregs.h>
#include <bits/x86/msrs.h>
#include <pgsizes.h>
#include <pgflags.h>
#include <gdtflags.h>
#include <gdtsegs.h>


#define BOOT_STACK_SIZE 0x1000

.section .multiboot

.align 32

MB_HEADER

MB_HEADER_PASS

.section .data.low

.align PGSTRUCT_SIZE
boot_pml4:
.space PGSTRUCT_SIZE
boot_pml4e:
.space PGSTRUCT_SIZE
boot_pdpte:
.space PGSTRUCT_SIZE
boot_pde:
.space PGSTRUCT_SIZE

.section .bss.low

boot_stack_end:
.space BOOT_STACK_SIZE
boot_stack_start:

.section .text
.global _entry
.type _entry, @function
_entry:

	/* 	So first we have to check that we have been booted 
		by a multiboot-compatible header */
	cmp $MB_BOOT_MAGIC, %eax
	jne _catchexit

	/* 	Give ourselves a stack
	 	EBP is set to 0 to indicate the end of the stackframe
		*/
	mov $boot_stack_start, %esp
	sub $BOOT_HIGHER_OFFSET, %esp
	mov %ebx, %ebp /* Multiboot info structure for later use */

	/* 	Now our job as the second-stage bootloader is 
		to enable long mode, and jump to the actual kernel */

	/*	To do this, we must:
			- Disable Paging
			- Set the PAE enable bit
			- Load PML4 into CR3
			- Set LME bit
			- Enable paging
		We will also enable level-5 paging
		*/

	/* 	Luckily, the multiboot standard says paging must be disabled
		when we are loaded
		*/

	/* 	Load page table entry with boot kernel
		ESI: Page start
		EDI: PDTE Index
		ECX: Number of page entries left
		*/

	mov $BOOT_KERNEL_BEGIN, %eax
	mov $PGSIZE, %ebx
	xor %edx, %edx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	xor %edx, %edx
	mul %ebx
	xor %edx, %edx
	mov $PGSIZE, %ebx
	mul %ebx
	mov %eax, %esi


	mov %esi, %eax
	mov $PGSIZE, %ebx
	xor %edx, %edx
	div %ebx
	mov %eax, %edi
	
	mov $0x200, %ecx

	mov $boot_pde, %edx
	sub $BOOT_HIGHER_OFFSET, %edx

.fill_pdte:

	mov %esi, %eax
	or $PTE_P, %eax
	or $PTE_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)
	inc %edi
	add $PGSIZE, %esi
	sub $0x1, %ecx
	jne .fill_pdte

	/* Now we just need to load everything in */

	/* Zero edx so we can divide */
	xor %edx, %edx

	/* PD Entry: Identity */
	mov $boot_pdpte, %edi
	sub $BOOT_HIGHER_OFFSET, %edi
	mov $BOOT_KERNEL_BEGIN, %eax
	mov $PGSIZE, %ebx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	mov %eax, %ecx

	mov $boot_pde, %eax
	sub $BOOT_HIGHER_OFFSET, %eax
	or $PML4E_P, %eax
	or $PML4E_RW, %eax
	mov %eax, (%edi,%ecx,PGSTRUCTENTRY_SIZE)

	xor %edx, %edx

	/* PDPT Entry: Identity */
	mov $boot_pml4e, %edi
	sub $BOOT_HIGHER_OFFSET, %edi
	mov $BOOT_KERNEL_BEGIN, %eax
	mov $PGSIZE, %ebx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	xor %edx, %edx
	div %ebx
	mov %eax, %ecx

	mov $boot_pdpte, %eax
	sub $BOOT_HIGHER_OFFSET, %eax
	or $PML5E_P, %eax
	or $PML5E_RW, %eax
	mov %eax, (%edi,%ecx,PGSTRUCTENTRY_SIZE)

	/* PDPT Entry: Higher */
	mov $boot_pml4e, %edi
	sub $BOOT_HIGHER_OFFSET, %edi
	mov $BOOT_KERNEL_BEGIN, %eax
	add $BOOT_HIGHER_OFFSET, %eax
	mov $PGSIZE, %ebx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	xor %edx, %edx
	div %ebx
	mov %eax, %ecx

	mov $boot_pdpte, %eax
	sub $BOOT_HIGHER_OFFSET, %eax
	or $PML5E_P, %eax
	or $PML5E_RW, %eax
	mov %eax, (%edi,%ecx,PGSTRUCTENTRY_SIZE)

	xor %edx, %edx
	/* PML4 Entry */
	mov $boot_pml4, %edi
	sub $BOOT_HIGHER_OFFSET, %edi
	mov $BOOT_KERNEL_BEGIN, %eax
	mov $PGSIZE, %ebx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	xor %edx, %edx
	div %ebx
	xor %edx, %edx
	div %ebx
	mov %eax, %ecx

	mov $boot_pml4e, %eax
	sub $BOOT_HIGHER_OFFSET, %eax
	or $PML5E_P, %eax
	or $PML5E_RW, %eax
	mov %eax, (%edi,%ecx,PGSTRUCTENTRY_SIZE)

	/* PML4 */
	mov $boot_pml4, %eax
	sub $BOOT_HIGHER_OFFSET, %eax
	mov %eax, %cr3

	/* Enable Page Address Extension */
	mov %cr4, %eax
	or $CR4_PAE, %eax
	mov %eax, %cr4

	/* Enable LME bit in EFER MSR */
	mov $EFER_MSR, %ecx
	rdmsr
	or $EFER_LME, %eax
	wrmsr
	
	/* Enable Paging */ 
	mov %cr0, %eax
	or $CR0_PG, %eax
	mov %eax, %cr0

	add $BOOT_HIGHER_OFFSET, %esp /* Higher stack */

	/* 	We are now in compatability mode
		Once we reload the segments, we will be in long mode 
		Before we do this, we will set up the next stage
		in it's own page hierarchy
	 */

	mov $.higher, %eax
	jmp *%eax
.higher:

	/*	We need to unmap the identity page 
		for cleanliness
	 */
	
	mov $boot_pml4e, %edi
	sub $BOOT_HIGHER_OFFSET, %edi
	mov $BOOT_KERNEL_BEGIN, %eax
	mov $PGSIZE, %ebx
	div %ebx
	xor %edx, %edx
	mov $PGSTRUCT_LEN, %ebx
	div %ebx
	xor %edx, %edx
	div %ebx
	mov %eax, %ecx
	mov $0, (%edi,%ecx,PGSTRUCTENTRY_SIZE)

.extern load_elf
	push $boot_pde
	push %ebp /* Multiboot info structure */
	xor %ebp, %ebp /* No stackframe */
	call load_elf



_catchexit:
	cli
	hlt
	jmp _catchexit