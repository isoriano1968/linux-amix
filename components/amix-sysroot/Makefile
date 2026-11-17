# The AMIX 2.1c system headers and libraries (patch level 2a), as published in
# amigaux/amix-system under Amiga Corporation's approval: the sysroot every
# AMIX cross compiler links against.  Same content as the OpenIndiana package
# developer/amix/sysroot.
NAME      = amix-sysroot
VERSION   = 2.1.2
ARCH      = all
SECTION   = devel
SUMMARY   = Amiga UNIX (AMIX) 2.1c sysroot for the AMIX cross compilers

SOURCES   = system amix
# the files, and the amix repository that pins and checks them
AMIX_SYSTEM_COMMIT = debb2e14bce281995d22bd5607a8db1afd4db677
URL_system    = https://github.com/amigaux/amix-system/archive/$(AMIX_SYSTEM_COMMIT).tar.gz
FILE_system   = amix-system-$(AMIX_SYSTEM_COMMIT).tar.gz
SHA256_system = 17a24bc82077beb88bc0a3682065a95b6814b61a0fe7d82ff5597cecefd23ba4
DIR_system    = amix-system-$(AMIX_SYSTEM_COMMIT)
AMIX_COMMIT   = 24bbf59fd1dc81fd793ca0f8891b84cbb5591e25
URL_amix      = https://github.com/amigaux/amix/archive/$(AMIX_COMMIT).tar.gz
FILE_amix     = amix-$(AMIX_COMMIT).tar.gz
SHA256_amix   = 5a4887546cf32e5a14786ea7e18dad9ecc5eb5be323af4d8d1d37808883c5b33
DIR_amix      = amix-$(AMIX_COMMIT)

SYSROOT   = /opt/m68k-amix-sysroot

define BUILD
grep -q " $(AMIX_SYSTEM_COMMIT)$$" $(SRC_amix)/system/amix-system.pin || \
	{ echo "amix $(AMIX_COMMIT) does not pin amix-system $(AMIX_SYSTEM_COMMIT)"; exit 1; }
sh $(SRC_amix)/system/check-amix-system $(SRC_system)
endef

define INSTALL
mkdir -p $(PROTO)$(SYSROOT)/etc
cd $(SRC_system) && tar --numeric-owner -cf - usr | (cd $(PROTO)$(SYSROOT) && tar --no-same-owner -xf -)
$(PYTHON) -I $(COMP_DIR)/files/relink-sysroot.py $(PROTO)$(SYSROOT)
printf '%s\n' amix-sysroot=1 kind=package "package=$(NAME) $(VERSION)-$(REVISION)" \
	"amix-release=2.1c patch level 2a" amix-system=$(AMIX_SYSTEM_COMMIT) amix=$(AMIX_COMMIT) \
	> $(PROTO)$(SYSROOT)/etc/amix-sysroot.release
endef

include ../../make-rules/component.mk
