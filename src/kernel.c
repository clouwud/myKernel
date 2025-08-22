#include <stddef.h>
#include <stdint.h>

static uint16_t* const VGA_BUFFER = (uint16_t*)0xB8000;
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

static size_t row = 0;
static size_t col = 0;
static uint8_t color = 0x0F; // white on black

static void putchar(char c) {
    if (c == '\n') {
        col = 0;
        if (++row == VGA_HEIGHT) row = 0;
        return;
    }
    const size_t index = row * VGA_WIDTH + col;
    VGA_BUFFER[index] = (uint16_t)c | (uint16_t)color << 8;
    if (++col == VGA_WIDTH) {
        col = 0;
        if (++row == VGA_HEIGHT) row = 0;
    }
}

static void puts(const char* str) {
    for (size_t i = 0; str[i] != '\0'; i++)
        putchar(str[i]);
}

void kernel_main(void) {
    puts("Hello, World!\n");
}
