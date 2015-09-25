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
	-nodefaultlibs \
	-Wl,-Bstatic \
	-llua \
	-lm \
	-lg \
	-lc

MSL := newlib-cygwin/newlib/libc/include/
LDD := -L. -I$(MSL) -I. $(LIB)
CXX := $(LDD) -std=c11 -Wall -fpie -pie

base:
	as -c src/base.S -o base_asm.o
	gcc base_asm.o src/base.c $(CXX) -o base


.PHONY: clean
clean:
	rm vitiate.o vitiate payload


.PHONY: disass
disass:
	objdump -D payload -b binary -m i386:x86-64
