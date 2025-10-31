#include "stageTwo.h"
#include "drivers/vga.h"

// kernel.c
void kernel_main() {
    vga_clear();
    vga_print("Stage Two Loaded");
    while(1);
}
