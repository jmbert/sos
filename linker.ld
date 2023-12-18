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

ENTRY(_entry)

KERNEL_PMA = 1M;
HIGH_OFFSET = 0xFFFFFFFF80000000;
KERNEL_VMA = HIGH_OFFSET+KERNEL_PMA;

SECTIONS
{
	. = KERNEL_PMA;

	.boot :
	{
		boot.o ( .multiboot );
		boot.o ( .text );
		boot.o ( .data );
		boot.o ( .bss );
	} : boot

	. += HIGH_OFFSET;

	.text : AT ( ADDR ( .text ) - HIGH_OFFSET )
	{
		
		* ( .text )
		. = ALIGN ( 4096 );
	} : text

	.data : AT ( ADDR ( .data ) - HIGH_OFFSET )
	{
		* ( .data )
	} : data

	.bss : AT ( ADDR ( .bss ) - HIGH_OFFSET )
	{
		* ( .bss )

		* ( COMMON )
	} : data

	KERNEL_END = .;
	KERNEL_SIZE = KERNEL_VMA-KERNEL_END;

	/DISCARD/ :
	{
		* ( .comment )
	}
}

PHDRS
{
	boot PT_LOAD FILEHDR PHDRS;
	text PT_LOAD;
	data PT_LOAD;
}