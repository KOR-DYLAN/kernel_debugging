TOP_DIR			:=$(PWD)
QEMU			:=qemu-system-arm
QEMU_IMG		:=qemu-img
MACHINE			:=raspi2b
DRAM			:=1G
KERNEL_IMG		:=$(OUTPUT)/$(ARCH)/boot/$(KERNEL).img
FDT_IMG			:=$(OUTPUT)/$(ARCH)/boot/bcm2709-rpi-2-b.dtb
SDC_IMG			:=resource/2020-08-20-raspios-buster-armhf-lite.img # Linux version 5.4.79-v7+
BOOTARG_FILE	:=resource/bootcmd.txt
BOOTARGS		:=$(shell cat $(BOOTARG_FILE))
QFLAGS			+=-serial stdio -no-reboot -device usb-kbd -device usb-tablet -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2222-:22

phony+=run
run:
	$(QEMU) -m $(DRAM) -M $(MACHINE) -kernel $(KERNEL_IMG) -dtb $(FDT_IMG) -drive format=raw,file=$(SDC_IMG) -append $(BOOTARGS)  $(QFLAGS)
	
phony+=cvtimg
cvtimg:
# Resize the image to 2GB (it should be a power of 2)
	$(QEMU_IMG) resize $(SDC_IMG) 2G
