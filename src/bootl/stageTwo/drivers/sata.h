#include <stdint.h>
typedef struct {
        uint16_t deviceIdentifier;          // number used to identify the device with other functions
        uint32_t size;                      // size of device in bytes
        uint16_t sector_size;               // size of sector e.g. 512, 4096
} sataDevice;

void sata_read(uint64_t lba, uint32_t sectorCount, void* buffer);
void sata_scanAllPorts(uint8_t devices[256]);