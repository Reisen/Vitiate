#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <iterator>
#include <algorithm>

/* Start the Metamorphic Engine. Written in asm. */
extern size_t *vm_push;
extern size_t *vm_pop;
extern size_t *vm_add;

extern "C" {
    int      Metamorph(void *, size_t *);
}

void
load_segment(const char *filename, uint8_t    *position) {
    __builtin_printf("--- Mapping Memory ---------------------\n");

    struct stat stat_d;
    auto handle = open(filename, O_RDONLY);
    if(handle == -1) {
        __builtin_printf("Failed: open(%s, O_RDONLY)", filename);
        exit(1);
    }

    fstat(handle, &stat_d);
    __builtin_printf("Opening: %s (ID: %d, Size: %d)\n", filename, handle, stat_d.st_size);
    auto memory = (uint8_t*)mmap
        ( nullptr
        , stat_d.st_size
        , PROT_READ
        , MAP_SHARED
        , handle
        , 0
        );
    __builtin_printf("Mapping: 0x%x\n", memory);

    memcpy
        ( position
        , memory
        , stat_d.st_size
        );
    __builtin_printf("Copying: %s\n", (memory[0] == position[0]) ? "done" : "failed");
    __builtin_printf("----------------------------------------\n\n");
}

int
main() {
    /*
     * ------------------------------------------------------------------------
     * Allocate VM Memory.
     *
     * First 4096 Bytes: VM Itself
     * Next 16384 Bytes: Instruction Cache and Shadow Instruction Cache
     * Final 8192 Bytes: VM Stack.
     * ------------------------------------------------------------------------
     */
    auto buffer = (uint8_t*)mmap
        ( nullptr
        , 28672
        , PROT_EXEC | PROT_READ | PROT_WRITE
        , MAP_PRIVATE | MAP_ANONYMOUS
        , -1
        , 0
        );

    /* Initialize Virtual Machine. */
    load_segment("vm_a.bin", buffer);
    load_segment("cache.bin", buffer + 4096);

    /* Load, Create, and Scramble Instruction Index. */
    struct Instruction {
        size_t index;
        const char *name;

        bool operator==(Instruction const& other) const {
            return strncmp(name, other.name, strlen(name)) == 0;
        }
    };

    Instruction
    instruction_index[] = {
        #include "instruction_cache.hpp"
    };

    __builtin_printf("--- Shuffling Instructions--------------\n");
    Instruction
    shuffling_index[] = {
        #include "instruction_cache.hpp"
    };

    // Copy the Index to keep he original intact.
    std::copy(std::begin(instruction_index), std::end(instruction_index), std::begin(shuffling_index));

    // Randomly Shuffle the Index
    srand(time(0));
    std::random_shuffle
        ( std::begin(shuffling_index)
        , std::end(shuffling_index) - 1
        );

    // Keeps Track of Write Position in Shadow Instruction Cache.
    size_t shuffle_offset = 0;

    // Iterate Shuffled Index and Create that in the Shadow Cache.
    for(auto &entry : shuffling_index) {
        __builtin_printf("Index(%02d): %s\n", ((size_t)&entry - (size_t)shuffling_index) / sizeof(Instruction), entry.name);

        // Find instruction in the old index, in order to find its size.
        auto instruction = std::find
            ( std::begin(instruction_index)
            , std::end(instruction_index) - 1
            , entry
            );

        // Find size of instruction.
        signed difference = (instruction + 1)->index - instruction->index + 1;

        // Ignore the last dummy instruction (always has a negative offset)
        if(difference > 0) {
            __builtin_printf
                ( "Distance: (%d - %d) = %d\n"
                , (instruction + 1)->index
                , instruction->index
                , difference
                );

            // Write the instruction into Shadow Cache.
            memcpy
                ( buffer + 8192
                , buffer + 4096 + entry.index
                , difference
                );

            // Update the Index.
            entry.index = shuffle_offset;
            shuffle_offset += difference;

        }
    }
    __builtin_printf("----------------------------------------\n\n");

    /*
     * ------------------------------------------------------------------------
     * Display instruction confirmations.
     * ------------------------------------------------------------------------
     */
    for(auto &entry : instruction_index) {
        auto shuffled = std::find
            ( std::begin(shuffling_index)
            , std::end(shuffling_index)
            , entry
            );

        __builtin_printf
            ( "%12s: 0x%x 0x%x\n"
            , entry.name
            , *(buffer + 4096 + entry.index)
            , *(buffer + 8192 + shuffled->index)
            );
    }


    /*
     * ------------------------------------------------------------------------
     * Compiling VM assembly.
     * ------------------------------------------------------------------------
     */
    size_t program[] = {
        2,
        (size_t)buffer + 4096,
        (size_t)buffer + 4096,
        (size_t)buffer + 4096,
        0,
        (size_t)buffer + 4096,
        (size_t)buffer + 4096,
        (size_t)buffer + 4096,
        0
    };

    int result = Metamorph(buffer,program);
    __builtin_printf("Result: %d\n\n", result);
}
