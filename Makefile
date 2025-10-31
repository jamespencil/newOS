.PHONY: run build clean
build_dir = build
built_stageone = build/temp/bootl/stageone
built_stagetwo = build/temp/bootl/stagetwo


build: build/code.img

build/code.img: build/temp $(built_stageone) $(built_stagetwo)
	dd if=/dev/zero of=$@ bs=512 count=6000
	dd if=$(built_stageone) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(built_stagetwo) of=$@ bs=512 count=2046 seek=1 conv=notrunc

$(built_stageone): src/bootl/entry.asm
	nasm -f bin $< -o $@

$(built_stagetwo): src/bootl/stageTwo/stageTwo.c src/bootl/stageTwo/drivers/vga.c
	x86_64-elf-gcc -ffreestanding -nostdlib -m64 -march=x86-64 -c $< -o build/temp/bootl/stagetwo.o
	x86_64-elf-gcc -ffreestanding -nostdlib -m64 -march=x86-64 -c $(word 2,$^) -o build/temp/bootl/vga.o
	x86_64-elf-ld -nostdlib -Ttext 0x7E00 -e kernel_main -o build/temp/bootl/stagetwo.elf build/temp/bootl/stagetwo.o build/temp/bootl/vga.o
	x86_64-elf-objcopy -O binary build/temp/bootl/stagetwo.elf $@

build/temp: 
	mkdir -p $@
	mkdir -p $@/bootl
	mkdir -p $@/kernel

iso: build
	dd if=$(build_dir)/code.img of=cdos.iso bs=512
	

run: build
	qemu-system-x86_64 -device ahci,id=ahci -drive id=disk,file=$(build_dir)/code.img,if=none -device ide-hd,drive=disk,bus=ahci.0 # create ahci controller then define disk then connect disk to first SATA port

clean:
	rm -r build/