#include "drivers/vga.h"
#include "drivers/sata.h"

// kernel.c
void stageTwo() {
    vga_clear();
    vga_print("Stage Two Loaded");
    while(1);
}
