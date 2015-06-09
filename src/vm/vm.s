.globl Metamorph
.text
    Metamorph:
    # Store RBX, as from now on. That will be our stack poitner.
    pushq %rbx

    # Setup the Stack.
    movq %rdi, %rbx
    addq $0x500, %rbx

    # Jump Start VM Execution
    call *%rdi

    # Restore RBX and finish VM execution
    popq %rbx
    retq
