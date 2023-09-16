ARIA2C_PATH			:=$(shell which aria2c)
RASPI_OF_IMG_URL	:=scripts/raspi_os_image_url.txt
DOWNLOAD_DIR		:=resource

get_image:
ifeq ($(ARIA2C_PATH),)
	sudo apt install aria2
endif
	aria2c -i $(RASPI_OF_IMG_URL) -d $(DOWNLOAD_DIR)
	cd resource && unzip '*.zip'
	cd resource && rm -f *.zip
