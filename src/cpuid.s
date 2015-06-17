# ------------------------------------------------------------------------------
# Code for doing CPUID detection. This makes sure the CPU is a brand we can
# actually hijack, and if it is, it checks the feature set to make sure
# virtualization features are actually present.
# ------------------------------------------------------------------------------

cpuid_detect:
    # Call Initial CPUID.
    movq $0, %rax
    cpuid
    movl %eax, _leaf(%rip)

    # Extract CPU Name.
    movq $0, %rax
    movl %ebx, _cpu0(%rip)
    movl %edx, _cpu1(%rip)
    movl %ecx, _cpu2(%rip)

    # Extract CPU Feature Set.
    movq $1, %rax
    cpuid
    movl %ecx, _features(%rip)
    retq


cpuid_check:
    # Track Indexes into Strings.
    leaq _cpu0(%rip), %rcx
    leaq _cpus(%rip), %rdx
    decq %rdx

    # Loop Through Results.
    _cpuid_continue:
    incq %rdx
    cmpb $0, (%rdx)
    jz _cpuid_fail

    movb (%rcx), %al
    cmpb %al, (%rdx)
    jnz _cpuid_continue

    incq %rcx
    cmpb $0, (%rcx)
    jnz _cpuid_continue

    _cpuid_success:
    testq $32, _features(%rip)
    jz _cpuid_fail
    movq $1, %rax
    retq

    _cpuid_fail:
    movq $0, %rax
    retq



# ------------------------------------------------------------------------------
# State
# ------------------------------------------------------------------------------

# CPUID States.
_leaf:              .byte 0, 0, 0, 0
_cpu0:              .byte 0, 0, 0, 0
_cpu1:              .byte 0, 0, 0, 0
_cpu2:              .byte 0, 0, 0, 0
_family:            .byte 0
_features:          .byte 0, 0, 0, 0
_cpus:              .string "AuthenticAMDGenuineIntel"
                    .byte 0
