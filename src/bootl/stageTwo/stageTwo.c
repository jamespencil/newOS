#include "drivers/vga.h"
#include "drivers/sata.h"

// kernel.c
void stageTwo() {
    vga_clear();
    vga_print("Stage two loaded.", 0, 0);
    
    uint8_t devices[256];
    sata_scanAllPorts(devices);
    for (int i = 0; i < 256; i++) {
        if (devices[i] == 1)
            vga_print("Device found!", 0, 1);
    }
    while(1);
}
