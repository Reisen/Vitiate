# Find Program Size. First 8 bytes.
movq (%rsi), %rcx
addq $8, %rsi

# Instruction Loop. Save pointer to VM region.
pushq %rsi
_iloop:
movq (%rsi), %rdx    # Load Address to some entry in _instruction_cache.
call *%rdx           # Call instruction.
addq $8, %rsi        # Increment VM pointer.
cmpq $0, (%rsi)      # Check for end of instruction.
jnz _iloop           # Still executing an Opcode
addq $8, %rsi        # Increment VM pointer.
decq %rcx            # Decrement instruction counter.
cmpq $0, %rcx        # Program End?
jnz _iloop           # Keep Executing if Not.
popq %rsi            # Restore VM pointer.

# End Of Program. This triggers the VM to be rewritten. The code this is
# rewritten to is found by running an exlusive or against the current VM
# resulting in the new VM. VM Selection is randomized.

retq                 # Done!
