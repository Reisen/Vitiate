.globl _setjmp
_setjmp:
    mov %rbx,(%rdi)
    mov %rbp,0x8(%rdi)
    mov %r12,0x10(%rdi)
    mov %r13,0x18(%rdi)
    mov %r14,0x20(%rdi)
    mov %r15,0x28(%rdi)
    lea 0x8(%rsp),%rax
    mov %rax,0x30(%rdi)
    mov (%rsp),%rax
    mov %rax,0x38(%rdi)
    mov $0x0,%rax
    retq

.globl _longjmp
_longjmp:
    movq %rsi,%rax
    movq 0x8(%rdi),%rbp
    movq 0x30(%rdi),%rsp
    pushq 0x38(%rdi)
    movq (%rdi),%rbx
    movq 0x10(%rdi),%r12
    movq 0x18(%rdi),%r13
    movq 0x20(%rdi),%r14
    movq 0x28(%rdi),%r15
    retq
