RASPIOS 	:=resource/2020-08-20-raspios-buster-arm64-lite.img

phony+=img_mount
img_mount:
	mkdir -p $(PWD)/boot
	mkdir -p $(PWD)/rootfs
	rm -f loopdev.txt
	$(eval LOOP_DEV=$(shell sudo losetup --show -fP $(RASPIOS)))
	echo $(LOOP_DEV) > loopdev.txt
	sudo mount $(LOOP_DEV)p1 $(PWD)/boot
	sudo mount $(LOOP_DEV)p2 $(PWD)/rootfs

phony+=img_umount
img_umount:
	$(eval LOOP_DEV=$(shell cat loopdev.txt))
	sudo umount $(PWD)/boot
	sudo umount $(PWD)/rootfs
	sudo losetup -d $(LOOP_DEV)
	rm -f loopdev.txt
