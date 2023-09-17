KSRC_DIR		:=$(TOP_DIR)/linux-rpi-5.4.y
CROSS_COMPILE	:=aarch64-none-linux-gnu-
DEFCONFIG		:=bcm2711_defconfig
ARCH			:=arm64
KERNEL			:=kernel8
KERNEL_OUTPUT	:=$(OUTPUT)/$(ARCH)/linux
BOOT_DIR		:=$(TOP_DIR)/boot
ROOTFS_DIR		:=$(TOP_DIR)/rootfs
TARGET			:=Image modules dtbs

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
# rm symbolic link
	sudo rm -f $(ROOTFS_DIR)/lib/modules/build
	sudo rm -f $(ROOTFS_DIR)/lib/modules/source
# to boot partition
	sudo cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/overlays/*.dtb* $(BOOT_DIR)/overlays/
	sudo cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/broadcom/*.dtb $(BOOT_DIR)/
# to output
	mkdir -p $(OUTPUT)/$(ARCH)/boot && cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/broadcom/*.dtb $(OUTPUT)/$(ARCH)/boot/
	cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/Image $(OUTPUT)/$(ARCH)/boot/$(KERNEL).img
	echo "pwd: $(PWD)"
	$(MAKE) ARCH=$(ARCH) img_umount
