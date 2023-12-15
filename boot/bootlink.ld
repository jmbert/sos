

ENTRY(_entry)

BOOT_KERNEL_BEGIN = 1M;

BOOT_HIGHER_OFFSET = 0xC0000000;

SECTIONS
{
	. = BOOT_KERNEL_BEGIN;

	.text ALIGN ( 4096 ) : 
	{
		* ( .multiboot )
		* ( .text )
	}

	.data ALIGN ( 4096 ) :
	{
		* ( .data )
	}

	.bss ALIGN ( 4096 ) :
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