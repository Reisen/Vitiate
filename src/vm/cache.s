vm_push:
movq %rax, (%rbx)
decq %rbx
retq

vm_pop:
movq (%rbx), %rax
incq %rbx
retq

vm_add:
push %rcx
movq (%rbx), %rax
incq %rbx
movq (%rbx), %rcx
incq %rbx
addq %rcx, %rax
pop %rcx
retq

vm_read:
movq (%rax), %rax
retq

vm_write:
movq %r8, (%rax)
retq

# Ignored. Just fills the last Index with a known instruction size for doing VM
# shuffling operations without worrying about where to stop.
vm_dummy:
retq
