.PHONY: build
build: base
	# Assemble Vitiate Assembly
	as src/vitiate.s -o vitiate.o

	# Manually Link
	ld -T vitiate.ld vitiate.o -o vitiate

	# Linked output is an object file, resolve an executable.
	g++ -N -nostartfiles -nostdlib -Wl,-e,_init vitiate.o -o vitiate

	# Strip out the text (executable) section into our payload.
	objcopy -j .text -O binary vitiate.o payload


.PHONY: base

LIB := \
	-nostdlib \
	-llua -Wl,-Bstatic \
	-lm \
	-lc \
	-Wl,-Bdynamic

MSL := /usr/lib/musl/lib/
LDD := -L. -L$(MSLL) -I. $(LIB)

base:
	musl-gcc $(LDD) src/base.c -o base


.PHONY: clean
clean:
	rm vitiate.o vitiate payload


.PHONY: disass
disass:
	objdump -D payload -b binary -m i386:x86-64
