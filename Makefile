.PHONY: run build clean cleanup
build_dir = build
built_stageone = build/temp/stageone


build: build/code.img cleanup

build/code.img: build/temp src/bootl/entry.asm
	nasm -f bin $(word 2, $^) -o $(built_stageone)
	dd if=/dev/zero of=$@ bs=512 count=24
	dd if=$(built_stageone) of=$@ bs=512 count=1 conv=notrunc

build/temp:
	mkdir -p $@
cleanup:
	rm -r build/temp


run: build
	qemu-system-x86_64 -hda $(build_dir)/code.img

clean:
	rm -r build/