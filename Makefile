.PHONY: build
build:
	as src/vitiate.s -o vitiate.o
	objcopy -j .text -O binary vitiate.o vitiate

.PHONY: disass
disass:
	objdump -D vitiate -b binary -m i386:x86-64
