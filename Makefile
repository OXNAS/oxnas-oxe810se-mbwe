CROSS_COMPILE?=arm-none-linux-gnueabi-

.phony : all clean checktoolchain

all: checktoolchain u-boot/u-boot.bin stage1/stage1.wrapped linux/arch/arm/boot/uImage

checktoolchain: 
	$(CROSS_COMPILE)gcc --version

u-boot/u-boot.bin:
	( cd u-boot ; $(MAKE) CROSS_COMPILE=$(CROSS_COMPILE))
	ln -s u-boot/u-boot.bin

stage1/stage1.wrapped:
	( cd stage1 ; $(MAKE) CROSS_COMPILE=$(CROSS_COMPILE))
	ln -s stage1/stage1.wrapped

linux/arch/arm/boot/uImage:
	( cd linux ; $(MAKE) ARCH=arm oxnas_810_eabi_wd_prod_defconfig)
	( cd linux ; $(MAKE) ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) uImage)
	ln -s linux/arch/arm/boot/uImage

clean:
	( cd u-boot ; $(MAKE) clean ; rm u-boot u-boot.* )
	( cd stage1 ; $(MAKE) clean )
	( cd linux ; $(MAKE) ARCH=arm clean )
	-rm u-boot.bin stage1.wrapped uImage
