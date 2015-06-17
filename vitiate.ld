ENTRY(_init);

SECTIONS
{
    . = 0x8000;
    .text :
    {
        *(.text)
    }
}

MEMORY
{
    exec (rwx) : org = 0x8000, len = 0x8000
}
