#include <stdio.h>

/* Who even knows. */
int
_IO_getc(void* fp) {
    return 0;
}

int*
__errno_location() {
    return (int*)0;
}

/* Redefine std* because we don't care about them. */
#undef stderr
#undef stdout
#undef stdin

FILE *const stderr;
FILE *const stdin;
FILE *const stdout;

/* Functions Lua needs (that we don't). */
size_t fopen64() { return 0; }
size_t freopen64() { return 0; }
void* sbrk(ssize_t change) { return 0; }
void kill() { }
int getpid() { return 0; }
int write() { return 0; }
int close() { return 0; }
int isatty() { return 0; }
int fstat() { return 0; }
int lseek() { return 0; }
int read() { return 0; }
void *gettimeofday() { return (void*)0; }
void _exit() { }
void _setjmp() {}
