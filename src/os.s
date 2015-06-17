# ------------------------------------------------------------------------------
# Code for doing OS stuff.
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
