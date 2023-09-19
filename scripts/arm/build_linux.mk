KSRC_DIR		:=$(TOP_DIR)/linux-rpi-5.4.y
CROSS_COMPILE	:=arm-none-linux-gnueabihf-
DEFCONFIG		:=bcm2709_defconfig
ARCH			:=arm
KERNEL			:=kernel7
KERNEL_OUTPUT	:=$(OUTPUT)/$(ARCH)/linux
BOOT_DIR		:=$(TOP_DIR)/boot
ROOTFS_DIR		:=$(TOP_DIR)/rootfs
TARGET			:=zImage modules dtbs

phony+=defconfig
defconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) $(DEFCONFIG)

phony+=menuconfig
menuconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) menuconfig

phony+=xconfig
xconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) xconfig

phony+=build
build:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) $(TARGET) -j $(NPROC)

phony+=install
install: img_mount
	sudo $(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) INSTALL_MOD_PATH=$(ROOTFS_DIR) modules_install -j $(NPROC)
# update nfs mount script
	sudo mkdir -p $(ROOTFS_DIR)/root/nfs
	echo "#!/bin/bash" | sudo tee $(ROOTFS_DIR)/root/mount.sh
	echo "mount -t nfs $(HOST_IP):/nfsroot nfs" | sudo tee -a $(ROOTFS_DIR)/root/mount.sh
	sudo chmod +x $(ROOTFS_DIR)/root/mount.sh
# rm symbolic link
	sudo rm -f $(ROOTFS_DIR)/lib/modules/build
	sudo rm -f $(ROOTFS_DIR)/lib/modules/source
# to boot partition
	sudo cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/overlays/*.dtb* $(BOOT_DIR)/overlays/
	sudo cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/*.dtb $(BOOT_DIR)/
# to output
	mkdir -p $(OUTPUT)/$(ARCH)/boot && cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/*.dtb $(OUTPUT)/$(ARCH)/boot/
	cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/zImage $(OUTPUT)/$(ARCH)/boot/$(KERNEL).img
	echo "pwd: $(PWD)"
	$(MAKE) ARCH=$(ARCH) img_umount
