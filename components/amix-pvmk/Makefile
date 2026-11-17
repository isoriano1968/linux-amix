# pvmk, the boot loader and paravirtualising microkernel for the Amiga 3000
# (68030/040/060): its boot block and image, the boot menu template, and the
# host tools mkadf and mkhdf that write the AMIX Installer's boot disk.
# Built with amix-gcc-14 (m68k-elf).  Same as the OpenIndiana package
# developer/amix/pvmk.
NAME      = amix-pvmk
VERSION   = 2026.11.8
ARCH      = any
SECTION   = otherosfs
SHLIBDEPS = yes
SUMMARY   = pvmk: Amiga 3000 boot loader and microkernel for AMIX, with mkadf/mkhdf

SOURCES   = pvmk
PVMK_COMMIT = 79c08e13c4cc733b7b8f2029adc106abd59769f1
PVMK_EPOCH  = 1794132672
URL_pvmk    = https://github.com/isoriano1968/pvmk/archive/$(PVMK_COMMIT).tar.gz
FILE_pvmk   = pvmk-$(PVMK_COMMIT).tar.gz
SHA256_pvmk = dadf400e5311e234fcf8c03eab76e5c8cac893d6a196b953e5fa4aa8fd871328
DIR_pvmk    = pvmk-$(PVMK_COMMIT)
# the m68k-elf toolchain of amix-gcc-14, as on OpenIndiana (for upstream pvmk)
PATCHES_pvmk = patches/0001-build-the-AMIX-m68k-elf-toolchain-and-non-GNU-hosts.patch

PVMK_VERSION = $(shell echo $(PVMK_COMMIT) | cut -c1-7)
PVMK_MAKE = SOURCE_DATE_EPOCH=$(PVMK_EPOCH) $(MAKE) -C $(SRC_pvmk) B=$(WORK)/pvmk \
	CROSS=/opt/m68k-amix/bin/m68k-elf- LIBGCC= HOSTCC=gcc PYTHON=$(PYTHON) \
	VERSION=$(PVMK_VERSION)

define BUILD
$(PVMK_MAKE) all
$(PVMK_MAKE) check $(WORK)/pvmk/host/mkhdf
endef

define INSTALL
mkdir -p $(PROTO)/usr/share/pvmk/conf $(PROTO)/usr/lib/pvmk
cp $(WORK)/pvmk/bootblock.bin $(WORK)/pvmk/pvmk.bin $(PROTO)/usr/share/pvmk/
echo $(PVMK_VERSION) > $(PROTO)/usr/share/pvmk/VERSION
cp $(SRC_pvmk)/conf/pvmk.conf $(SRC_pvmk)/conf/README.disk $(PROTO)/usr/share/pvmk/conf/
cp $(WORK)/pvmk/host/mkadf $(WORK)/pvmk/host/mkhdf $(PROTO)/usr/lib/pvmk/
endef

include ../../make-rules/component.mk
