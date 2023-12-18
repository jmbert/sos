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
#include <meminfo.h>


#define BOOT_STACK_SIZE 0x1000

#define START_PHYS_PDPT 0x111
#define END_PHYS_PDPT 	0x191
#define PHYS_PDPT_LEN 	0x80
.set 	PHYS_GIG_PAGES, PGSTRUCT_LEN*PHYS_PDPT_LEN 	

.section .multiboot

.align 32

MB_HEADER

MB_HEADER_PASS

.section .data

.align PGSTRUCT_SIZE
boot_pml4:
.space PGSTRUCT_SIZE
boot_pml4e:
.space PGSTRUCT_SIZE

boot_phys_pdpts:
.space PGSTRUCT_SIZE*PHYS_PDPT_LEN

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



	/*
		Identity map current GB
	*/
	mov $0x0, %eax
	or $PDPTE_P, %eax
	or $PDPTE_RW, %eax
	or $PDPTE_PS, %eax
	mov %eax, boot_pml4e
	/*
		Map GB containing kernel
	*/
	mov $boot_pml4e, %edx
	mov $0x1fe, %edi
	mov $0x0, %eax
	or $PDPTE_P, %eax
	or $PDPTE_RW, %eax
	or $PDPTE_PS, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)
	
	/* 
		Identity map first GB so we can run
	*/
	mov $boot_pml4e, %eax
	or $PML4E_P, %eax
	or $PML4E_RW, %eax
	mov %eax, boot_pml4

	/* 
		Map in higher region that the kernel will run in
	*/
	mov $boot_pml4, %edx
	mov $0x1ff, %edi
	mov $boot_pml4e, %eax
	or $PML4E_P, %eax
	or $PML4E_RW, %eax
	mov %eax, (%edx,%edi,PGSTRUCTENTRY_SIZE)

	/* PML4 */
	mov $boot_pml4, %eax
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

	/*
		Now enter long mode by reloading segment registers
	*/

.extern loadGdt
	pushl 0x0
	call loadGdt
.code64
	

	movabs $HIGH_OFFSET, %rax
	add %rax, %rsp
	mov %rbp, %r10 /* Multiboot structure from earlier */
	xor %rbp, %rbp

	add $.higher, %rax
	jmp *%rax

.higher:
	
	/*	Now we just map in literally all of physical memory
		Easy, right?
	 */
	xor %rsi, %rsi /* Physical Address of 1G Page */
	xor %rdi, %rdi /* PDPTE Index */
	mov $boot_phys_pdpts, %rdx
.fill_phys_pdpts:
	mov %rsi, %rax
	or $PDPTE_P, %rax
	or $PDPTE_RW, %rax
	or $PDPTE_PS, %rax
	mov %rax, (%rdx,%rdi,PGSTRUCTENTRY_SIZE)

	add $HUGEPGSIZE, %rsi
	inc %rdi
	cmp $PHYS_GIG_PAGES, %rdi
	jne .fill_phys_pdpts

	mov $boot_phys_pdpts, %rsi
	mov $START_PHYS_PDPT, %rdi /* PML4E Index */
	mov $boot_pml4, %rdx
.fill_phys_pml4es:
	mov %rsi, %rax
	or $PML4E_P, %rax
	or $PML4E_RW, %rax
	mov %rax, (%rdx,%rdi,PGSTRUCTENTRY_SIZE)

	add $PGSTRUCT_SIZE, %rsi
	inc %rdi
	cmp $END_PHYS_PDPT, %rdi
	jne .fill_phys_pml4es

	/*	We need to unmap the identity pml4e and pdpte
		for cleanliness
	 */
	movabs $PHYS_VMA_BEGIN, %rbx

	mov $boot_pml4e, %rdi

	add %rbx, %rdi
	movq $0x0, (%rdi)

	mov $boot_pml4, %rdi
	add %rbx, %rdi
	movq $0x0, (%rdi)

	mov %r10, %rdi /* Multiboot info */
	movabs $_start, %rax
	jmp *%rax

_fail:
	cli
	hlt
	jmp _fail