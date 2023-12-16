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

.extern loadGdt
.global switch_to_kernel
switch_to_kernel:
	push %ebp
	mov %esp, %ebp

	pushl $0x0 /* So the return address is a 64-bit address */
	call loadGdt /* Yay: Now finally in 64-bit mode */

	/* 	Now for the tricky part 
		We have to copy the page-switching code to just before the entry point
		If everything goes well, we will slide right into the new kernel
	*/
	mov $switch_pml4.end, %ecx
	sub $switch_pml4, %ecx
	mov %ecx, %edx

	mov 0x8(%ebp), %edi /* Entry point */
	sub %ecx, %edi
	mov $switch_pml4, %esi /* PML4 Switch */

	rep movsb /* The copy */

	/* The switch code is now set up */
	mov 0x8(%ebp), %eax /* Entry point */
	sub %edx, %eax
	jmp *%eax

	ud2 /* Unreachable */


switch_pml4:
	mov 0xc(%ebp), %eax /* PML4 */
	mov %eax, %cr3
switch_pml4.end: