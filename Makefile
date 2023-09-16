ARCH :=arm
include scripts/$(ARCH)/build_linux.mk
include scripts/$(ARCH)/mount.mk
include scripts/$(ARCH)/qemu.mk
include scripts/resource.mk

all:
