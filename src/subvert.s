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
