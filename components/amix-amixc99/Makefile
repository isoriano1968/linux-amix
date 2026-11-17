# libamixc99 in the AMIX sysroot: the C99 and POSIX functions AMIX SVR4.0's
# libc lacks, with its headers and pkg-config file, for programs built with
# amix-gcc-14.  Same as the OpenIndiana package developer/amix/amixc99.
NAME      = amix-amixc99
VERSION   = 1
ARCH      = all
SECTION   = devel
DEPENDS   = amix-sysroot (>= 2.1.2), amix-gcc-14 (>= 14.2.0)
SUMMARY   = libamixc99: C99 and POSIX functions for AMIX programs (sysroot)

SOURCES   = au
AU_COMMIT = 7b5c96b18852f1b020f3894641e76039be12522a
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = 952b2c4a535f57489fb20c3aa0c633af09b2f5c96fd11f31cd97141a09b096f3
DIR_au    = amix-userland-$(AU_COMMIT)

SYSROOT   = /opt/m68k-amix-sysroot
TOOLS     = /opt/m68k-amix/bin
C99       = $(SRC_au)/components/library/amixc99

define BUILD
$(MAKE) -C $(C99) stage AMIX_TOOLS=$(TOOLS) AMIX_SYSROOT=$(SYSROOT) PREFIX=/usr/local
endef

# the same library the compiler links by default
define INSTALL
mkdir -p $(PROTO)$(SYSROOT)
cd $(C99)/build/stage && tar --numeric-owner -cf - usr | (cd $(PROTO)$(SYSROOT) && tar --no-same-owner -xf -)
cmp $(PROTO)$(SYSROOT)/usr/local/lib/libamixc99.a `$(TOOLS)/m68k-elf-gcc -print-file-name=libamixc99.a`
endef

include ../../make-rules/component.mk
