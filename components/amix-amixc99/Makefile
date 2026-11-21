# libamixc99 in the AMIX sysroot: the C99 and POSIX functions AMIX SVR4.0's
# libc lacks, as the shared libamixc99.so.1 that amix-gcc-14 builds (2: the
# archive of 1 is gone), with its headers, pkg-config file and link stub.
# Same as the OpenIndiana package developer/amix/amixc99.
NAME      = amix-amixc99
VERSION   = 2
ARCH      = all
SECTION   = devel
DEPENDS   = amix-sysroot (>= 2.1.2), amix-gcc-14 (>= 14.2.0-2)
SUMMARY   = libamixc99: C99 and POSIX functions for AMIX programs (sysroot)

SOURCES   = au
AU_COMMIT = 5bae14a830d0c7f866c84fd5cab8808eec6ac9d9
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = f25b862c59ee1665811dc1e7b068dff175985ce3bdf50c0764b43a2480b387d3
DIR_au    = amix-userland-$(AU_COMMIT)

SYSROOT   = /opt/m68k-amix-sysroot
TOOLS     = /opt/m68k-amix/bin
C99       = $(SRC_au)/components/library/amixc99

define BUILD
PATH=$(TOOLS):$$PATH $(MAKE) -C $(C99) stage AMIX_TOOLS=$(TOOLS) AMIX_SYSROOT=$(SYSROOT) PREFIX=/usr/local
endef

# the same library the compiler links by default
define INSTALL
mkdir -p $(PROTO)$(SYSROOT)
cd $(C99)/build/stage && tar --numeric-owner -cf - usr | (cd $(PROTO)$(SYSROOT) && tar --no-same-owner -xf -)
cmp $(PROTO)$(SYSROOT)/usr/lib/libamixc99.so.1 `$(TOOLS)/m68k-elf-gcc -print-file-name=libamixc99.so.1`
endef

include ../../make-rules/component.mk
