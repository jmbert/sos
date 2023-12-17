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
.code32

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

.section .data

.align PGSTRUCT_SIZE
boot_pml5:
.space PGSTRUCT_SIZE
boot_pml5e:
.space PGSTRUCT_SIZE
boot_pml4e:
.space PGSTRUCT_SIZE
boot_pdpte:
.space PGSTRUCT_SIZE
boot_pde:
.space PGSTRUCT_SIZE

.section .bss

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
	jne _fail

	/* 	Give ourselves a stack
	 	EBP is set to 0 to indicate the end of the stackframe
		*/
	mov $boot_stack_start, %esp
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

	mov $KERNEL_PMA, %esi
	and 0xFFE00000, %esi
	mov %esi, %edi
	GET_PAGE(%edi)
	mov $0x200, %ecx

	mov $boot_pde, %edx

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

	/* PD Entry */
	mov $boot_pdpte, %edx
	mov $KERNEL_PMA, %edi
	GET_PTAB(%edi)

	mov $boot_pde, %eax
	or $PDE_P, %eax
	or $PDE_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)


	/* PDPT Entry */
	mov $boot_pml4e, %edx
	mov $KERNEL_PMA, %edi
	GET_PDIR(%edi)

	mov $boot_pdpte, %eax
	or $PDPTE_P, %eax
	or $PDPTE_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)

	/* PML4 Entry */
	mov $boot_pml5e, %edx
	mov $KERNEL_PMA, %edi
	GET_PDPTR(%edi)

	mov $boot_pml4e, %eax
	or $PML4E_P, %eax
	or $PML4E_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)

	/* PML5 Entry: Identity */
	mov $boot_pml5, %edx
	mov $KERNEL_PMA, %edi
	GET_PML4(%edi)

	mov $boot_pml5e, %eax
	or $PML5E_P, %eax
	or $PML5E_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)

	/* PML5 */
	mov $boot_pml5, %eax
	mov %eax, %cr3

	/* Enable Page Address Extension */
	mov %cr4, %eax
	or $CR4_PAE, %eax
	or $CR4_LA57, %eax
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

	/* 	We are now in compatability mode
		Once we reload the segments, we will be in long mode 
		Before we do this, we will set up the next stage
		in it's own page hierarchy
	 */

	 
.extern loadGdt
	pushl 0x0
	call loadGdt
.code64
	/* PML5 Entry: Higher */
	mov $boot_pml5, %rdx
	movabs $KERNEL_VMA, %rdi
	GET_PML4(%rdi)

	mov $boot_pml5e, %rax
	or $PML5E_P, %rax
	or $PML5E_RW, %rax
	mov %rax, (%rdx,%rdi,PGSTRUCTENTRY_SIZE)
	

	movabs $HIGH_OFFSET, %rax
	add %rax, %rsp
	mov %rbp, %rbx /* Multiboot structure from earlier */
	xor %rbp, %rbp

	add $.higher, %rax
	jmp *%rax

.higher:
	/*	We need to unmap the identity pml5e 
		for cleanliness
	 */
	mov $boot_pml5, %rdx
	mov $KERNEL_PMA, %rdi
	GET_PML4(%rdi)

	movq $0, (%rdx,%rdi,PGSTRUCTENTRY_SIZE)
	
	/*	Now we just map in literally all of physical memory
		Easy, right?
	 */

	mov %rbx, %rdi /* Multiboot info */
	movabs $_start, %rax
	jmp *%rax

_fail:
	cli
	hlt
	jmp _fail