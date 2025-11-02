#include <stdint.h>
typedef struct {
        uint16_t deviceIdentifier;          // number used to identify the device with other functions
        uint32_t size;                      // size of device in bytes
        uint16_t sector_size;               // size of sector e.g. 512, 4096
} sataDevice;

// in and out instructions
static inline int inw(uint16_t port);


// find sata devices
sataDevice* sata_findDevices(void);


void sata_read(uint64_t lba, uint32_t sectorCount, void* buffer);