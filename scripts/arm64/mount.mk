RASPIOS 	:=resource/2020-08-20-raspios-buster-arm64-lite.img

mount:
	mkdir -p boot
	mkdir -p rootfs
	rm -f loopdev.txt
	$(eval LOOP_DEV=$(shell sudo losetup --show -fP $(RASPIOS)))
	echo $(LOOP_DEV) > loopdev.txt
	sudo mount $(LOOP_DEV)p1 boot
	sudo mount $(LOOP_DEV)p2 rootfs

umount:
	$(eval LOOP_DEV=$(shell cat loopdev.txt))
	sudo umount boot
	sudo umount rootfs
	sudo losetup -d $(LOOP_DEV)
	rm -f loopdev.txt
