.PHONY: build
build:
	as src/vitiate.s -o vitiate.o
	ld -T vitiate.ld vitiate.o -o vitiate
	g++ -N -nostartfiles -nostdlib -Wl,-e,_init vitiate.o -o vitiate
	objcopy -j .text -O binary vitiate.o payload

.PHONY: disass
disass:
	objdump -D payload -b binary -m i386:x86-64
