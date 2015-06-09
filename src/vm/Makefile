.PHONY: a.out
a.out:
	@echo

	@tput setaf 4
	@echo [Building Virtual Machines]
	@tput sgr0
	as vm_a.s -o vm_a.o
	@echo

	@tput setaf 4
	@echo [Extracting Virtual Machines]
	@tput sgr0
	objcopy -O binary vm_a.o vm_a.bin
	@echo

	@tput setaf 4
	@echo [Building Instruction Cache]
	@tput sgr0
	as cache.s -o cache.o
	@echo

	@tput setaf 4
	@echo [Extracting Instruction Cache]
	@tput sgr0
	objcopy -O binary cache.o cache.bin
	@echo

	@tput setaf 4
	@echo [Generating Instruction Index]
	@tput sgr0
	objdump -d cache.o | grep '<.' | sed 's/\([0-9a-f]\+\) <\(.\+\)>:/{0x\1, "\2"},/' > instruction_cache.hpp
	@echo

	@tput setaf 4
	@echo [Building Obfuscator Launcher]
	@tput sgr0
	g++ -g -std=gnu++11 -c vm.cpp -o vm.o
	as vm.s -o meta.o
	g++ vm.o meta.o -o a.out
	@echo
