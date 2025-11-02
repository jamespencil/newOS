#include "sata.h"

// in and out instructions
static inline int inw(uint16_t port) {
    uint16_t value;
    asm volatile("inw %1, %0" : "=a"(value) : "Nd"(port));
    return value;
}


// find sata devices
sataDevice* sata_findDevices(void) {
    static sataDevice* devices = (sataDevice*)0;

    return devices;
}


void sata_read(uint64_t lba, uint32_t sectorCount, void* buffer) {
    
}