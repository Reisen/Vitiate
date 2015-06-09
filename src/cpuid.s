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
    movl %ecx, _feature(%rip)
    retq


cpuid_check:
    # Confirm CPUID results.
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
