#include "sata.h"

// in and out instructions
static inline uint32_t in(uint16_t port) {
    uint32_t value;
    asm volatile ("inl %1, %0" : "=a"(value) : "Nd"(port));
    return value;
}

static inline void outl(uint16_t port, uint32_t value) {
    asm volatile("outl %0, %1" : : "a"(value), "Nd"(port));
}

uint8_t isSataDrive(uint16_t bus, uint8_t device) {
    uint32_t addr = (1 << 31)
                |   (bus << 16)
                |   (device << 11)
                |   (0 << 8)
                |   (0x0C & 0xFC);
    outl(0xCF8, addr);
    uint32_t value = in(0xCFC);
    uint8_t baseClass = (value >> 24) & 0xFF;
    uint8_t subClass  = (value >> 16) & 0xFF;
    if (baseClass == 0x01 && subClass == 0x06) 
        return 1;
    return 0;
}

void sata_scanAllPorts(uint8_t devices[256]) {
    for (uint16_t bus = 0; bus < 256; bus++) {
        for (uint8_t device = 0; device < 32; device++) {
            devices[bus * 32 + device] = isSataDrive(bus, device);
        }
    }
}

void sata_read(uint64_t lba, uint32_t sectorCount, void* buffer) {
    
}
