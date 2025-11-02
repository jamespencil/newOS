.PHONY: run build clean
build_dir = build
built_stageone 	= build/temp/bootl/stageone
built_stagetwo 	= build/temp/bootl/stagetwo
built_kernel	= build/temp/kernel/kernel.elf
bootl_linker	= src/bootl/stageTwo/linker.ld
kernel_linker	= src/kernel/linker.ld


build: $(built_kernel)

build/code.img: build/temp $(built_stageone) $(built_stagetwo) $(built_kernel)
	dd if=/dev/zero of=$@ bs=512 count=6000
	dd if=$(built_stageone) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(built_stagetwo) of=$@ bs=512 count=2046 seek=1 conv=notrunc

$(built_stageone): src/bootl/entry.asm
	nasm -f bin $< -o $@

$(built_stagetwo): src/bootl/stageTwo/*.c src/bootl/stageTwo/drivers/*.c
	for src in $(shell find src/bootl/stageTwo -name '*.c'); do \
		echo "Compiling $$src"; \
		x86_64-elf-gcc -ffreestanding -nostdlib -m64 -march=x86-64 -c $$src -o build/temp/bootl/$$(basename $$src .c).o; \
	done
	x86_64-elf-ld -T $(bootl_linker) build/temp/bootl/stageTwo.o build/temp/bootl/vga.o build/temp/bootl/sata.o

$(built_kernel): build/code.img
	for src in $(shell find src/bootl/stageTwo -name '*.c'); do \
		echo "Compiling $$src"; \
		x86_64-elf-gcc -ffreestanding -nostdlib -m64 -march=x86-64 -c $$src -o build/temp/kernel/$$(basename $$src .c).o; \
	done
	x86_64-elf-ld -T $(kernel_linker) build/temp/kernel/*.o
	sfdisk $< < ./sfdiskinput.txt
	mformat -i $<@@1048576 -F ::
	mcopy -i $<@@1048576 $(built_kernel) ::


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