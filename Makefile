
build:
	as src/hijack.s -o hijack.o
	objcopy -j .text -O binary hijack.o hijack

d:
	objdump -D hijack -b binary -m i386:x86-64
