TOP_DIR	:=$(PWD)
OUTPUT	:=$(TOP_DIR)/output
NPROC	:=$(shell nproc)
ARCH 	?=arm64
HOST_IP :=$(shell hostname -I | awk '{print $1}' | tr -d ' ')

include scripts/resource.mk
include scripts/build_qemu.mk
include scripts/$(ARCH)/mount.mk
include scripts/$(ARCH)/build_linux.mk
include scripts/$(ARCH)/qemu.mk

all: run

info:
	echo "HOST_IP: $(HOST_IP)hello"
	echo "#!/bin/bash" | tee mount.sh
	echo "mount -t nfs $(HOST_IP):/nfsroot nfs" | tee -a mount.sh

.PHONY: $(phony)