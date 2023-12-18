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

#include <gdtflags.h>
#include <gdtsegs.h>

.section .text

.global loadGdt
loadGdt:
	mov $gdtr, %eax
	lgdt (gdtr)
	jmp $GDT_KCODE,$.reloadSegments
.reloadSegments:
.code64	
	mov $GDT_KDATA, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss
	ret

.section .data

gdtr:
.short (gdt_start-gdt_end)
.long (gdt_start)

gdt_start:
.quad 0 /* NULL */

/* Kernel Code */
.short 0xFFFF
.short 0x0000
.byte 0x00
.byte 0x9A
.byte 0xFA
.byte 0x00

/* Kernel Data */
.short 0xFFFF
.short 0x0000
.byte 0x00
.byte 0x92
.byte 0xFC
.byte 0x00

/* User Code */
.short 0xFFFF
.short 0x0000
.byte 0x00
.byte 0xFA
.byte 0xFA
.byte 0x00

/* User Data */
.short 0xFFFF
.short 0x0000
.byte 0x00
.byte 0xF2
.byte 0xFC
.byte 0x00

gdt_end: