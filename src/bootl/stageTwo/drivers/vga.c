#include "vga.h"

void vga_clear() {
    volatile unsigned short *video = (unsigned short *)0xB8000;
    for (int i = 0; i < 80 * 25; i++) {
        video[i] = (0x07 << 8) | ' ';
    }
}

void vga_print(const char* str, int16_t x, uint8_t y) {
    volatile unsigned short *video = (unsigned short *)0xB8000;
    int cx = x;
    int cy = y;

    for (int i = 0; str[i]; i++) {
        if (str[i] == '\n') {
            cy++;
            cx = x;
            continue;
        }

        if (cx >= 80) {
            cx = 0;
            cy++;
        }
        if (cy >= 25)
            break;

        video[cy * 80 + cx] = (0x07 << 8) | str[i];
        cx++;
    }
}
