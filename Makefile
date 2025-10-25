.PHONY: run build clean cleanup
build_dir = build
built_stageone = build/temp/stageone
built_stagetwo = build/temp/stagetwo


build: build/code.img

build/code.img: build/temp $(built_stageone) $(built_stagetwo)
	dd if=$(built_stagetwo) of=$@ bs=512 count=2046 seek=1 conv=notrunc
	dd if=/dev/zero of=$@ bs=512 count=6000
	dd if=$(built_stageone) of=$@ bs=512 count=1 conv=notrunc
	dd if=$(built_stagetwo) of=$@ bs=512 count=2046 seek=1 conv=notrunc

$(built_stageone): src/bootl/entry.asm
	nasm -f bin $< -o $@

$(built_stagetwo): src/bootl/stageTwo.asm
	nasm -f bin $< -o $@ -i src/bootl

build/temp: 
	mkdir -p $@


run: build
	qemu-system-x86_64 -device ahci,id=ahci -drive id=disk,file=$(build_dir)/code.img,if=none -device ide-hd,drive=disk,bus=ahci.0 # create ahci controller then define disk then connect disk to first SATA port

clean:
	rm -r build/