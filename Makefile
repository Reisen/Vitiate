
build:
	as src/vitiate.s -o vitiate.o
	objcopy -j .text -O binary vitiate.o vitiate

d:
	objdump -D vitiate -b binary -m i386:x86-64
