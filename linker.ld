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

ENTRY(kinit)

HIGHER_HALF = 0xC0000000;
KERNEL_VMA = HIGHER_HALF+1M;

SECTIONS
{
	. = KERNEL_VMA;

	.text : AT ( ADDR ( .text ) - KERNEL_VMA )
	{
		
		* ( .text )
		. = ALIGN ( 4096 );
	}

	.data : AT ( ADDR ( .data ) - KERNEL_VMA )
	{
		* ( .data )
	}

	.bss : AT ( ADDR ( .bss ) - KERNEL_VMA )
	{
		* ( .bss )

		* ( COMMON )
	}

	_KERNEL_END = .;

	/DISCARD/ :
	{
		* ( .comment )
	}
}