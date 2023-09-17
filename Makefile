TOP_DIR	:=$(PWD)
OUTPUT	:=$(TOP_DIR)/output
NPROC	:=$(shell nproc)
ARCH 	?=arm64

include scripts/essential.mk
include scripts/toolchain.mk
include scripts/nfs.mk
include scripts/resource.mk
include scripts/build_qemu.mk
include scripts/$(ARCH)/mount.mk
include scripts/$(ARCH)/build_linux.mk
include scripts/$(ARCH)/qemu.mk

all: run

.PHONY: $(phony)