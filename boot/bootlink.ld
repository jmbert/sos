

ENTRY(_entry)

BOOT_KERNEL_BEGIN = 1M;

BOOT_HIGHER_OFFSET = 0xC0000000;

SECTIONS
{
	. = BOOT_KERNEL_BEGIN;
	. += BOOT_HIGHER_OFFSET;

	.text ALIGN ( 4096 ) : AT ( ADDR ( .text ) - BOOT_HIGHER_OFFSET )
	{
		* ( .multiboot )
		* ( .text )
	}

	.data ALIGN ( 4096 ) : AT ( ADDR ( .data ) - BOOT_HIGHER_OFFSET )
	{
		* ( .data )
	}

	.bss ALIGN ( 4096 ) : AT ( ADDR ( .bss ) - BOOT_HIGHER_OFFSET )
	{
		* ( .bss )

		* ( COMMON )
	}

	BOOT_KERNEL_END = .;

	/DISCARD/ :
	{
		* ( .comment )
	}
}