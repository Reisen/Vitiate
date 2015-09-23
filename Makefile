.PHONY: build
build:
	# Assemble Vitiate Assembly
	as src/vitiate.s -o vitiate.o

	# Manually Link
	ld -T vitiate.ld vitiate.o -o vitiate

	# Linked output is an object file, resolve an executable.
	g++ -N -nostartfiles -nostdlib -Wl,-e,_init vitiate.o -o vitiate

	# Strip out the text (executable) section into our payload.
	objcopy -j .text -O binary vitiate.o payload


.PHONY: clean
clean:
	rm vitiate.o vitiate payload


.PHONY: disass
disass:
	objdump -D payload -b binary -m i386:x86-64
