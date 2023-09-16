TOP_DIR			:=$(PWD)
KSRC_DIR		:=$(TOP_DIR)/linux-rpi-5.4.y
CROSS_COMPILE	:=aarch64-none-linux-gnu-
DEFCONFIG		:=bcm2711_defconfig
ARCH			:=arm64
KERNEL			:=kernel8
KERNEL_OUTPUT	:=$(TOP_DIR)/output/$(ARCH)/linux
ROOTFS_OUTPUT	:=$(TOP_DIR)/output/$(ARCH)/rootfs
TARGET			:=Image modules dtbs
NPROC			:=$(shell nproc)

defconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) $(DEFCONFIG)

menuconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) menuconfig

xconfig:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) xconfig

build:
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) $(TARGET) -j $(NPROC)

install:
	@rm -rf $(MODULE_OUTPUT)
	@mkdir -p $(ROOTFS_OUTPUT)/boot
	@mkdir -p $(ROOTFS_OUTPUT)/boot/overlays
	$(MAKE) -C $(KSRC_DIR) CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) KERNEL=$(KERNEL) O=$(KERNEL_OUTPUT) INSTALL_MOD_PATH=$(ROOTFS_OUTPUT)/lib/modules modules_install -j $(NPROC)
	rm -f $(ROOTFS_OUTPUT)/lib/modules/build
	rm -f $(ROOTFS_OUTPUT)/lib/modules/source
	cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/*.dtb $(ROOTFS_OUTPUT)/boot
	cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/dts/overlays/*.dtb* $(ROOTFS_OUTPUT)/boot/overlays/
	cp $(KERNEL_OUTPUT)/arch/$(ARCH)/boot/zImage $(ROOTFS_OUTPUT)/boot/$(KERNEL).img
