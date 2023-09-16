ARCH :=arm
include scripts/$(ARCH)/build_linux.mk
include scripts/$(ARCH)/mount.mk
include scripts/$(ARCH)/qemu.mk
include scripts/resource.mk

all:
	echo "ARIA2C_PATH: $(ARIA2C_PATH)"
