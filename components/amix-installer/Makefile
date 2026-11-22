# The AMIX Installer: a GTK 4 / libadwaita app that makes an Amiga UNIX disk
# for an Amiga 3000/2500 or FS-UAE from your own AMIX core system.  Same files
# as the OpenIndiana package desktop/amix-installer, under /usr.
NAME      = amix-installer
VERSION   = 0.9.1
ARCH      = all
SECTION   = otherosfs
DEPENDS   = python3 (>= 3.9), python3-gi, gir1.2-gtk-4.0 (>= 4.12), gir1.2-adw-1 (>= 1.4), \
	git, make, curl, pkg-config
# what it needs to make kernels and boot disks, and the compiler and sysroot
# of the Build tab (AMIX packages built here from amix-userland; git, make,
# curl and pkg-config are dependencies): installed with it by default
RECOMMENDS = amix-pvmk, amix-gcc-14, amix-sysroot, amix-gcc-27, amix-kernel-kit-tools, amix-rtgfb-kit, \
	amix-zz9000-kit, amix-va2000-kit, amix-hydra-kit, amix-xsurf100-kit, \
	amix-zz9000eth-kit, amix-z3660eth-kit, amix-z3660scsi-kit, amix-z3660rtg-kit, amix-buddha-kit, amix-a4091-kit, fs-uae, xdg-user-dirs, pkexec
# the Debian host tools with which every component builds in the Build tab
# (amix-userland's components/desktop/amix-installer/README.md): suggested
# only, as most of them matter for a few components
SUGGESTS  = meson, ninja-build, cmake, autoconf, automake, libtool, gettext, texinfo, \
	gperf, libfl-dev, x11proto-dev, libx11-dev, libxt-dev, libxext-dev, xfonts-utils, \
	python3-pil, libpng-dev, cython3, gcc-arm-none-eabi, libnewlib-arm-none-eabi, \
	libstdc++-arm-none-eabi-newlib, python3-mako
SUMMARY   = makes Amiga UNIX (AMIX) disks for an Amiga or FS-UAE

SOURCES   = au
AU_COMMIT = 554b20a0e2f4464d3cf3d772ac4dc47e8ff38378
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = a759acbf2a272a5b1624dd4db6f08e231f799ae32a836dfe461a3dd86a61c87b
DIR_au    = amix-userland-$(AU_COMMIT)

APP       = $(SRC_au)/components/desktop/amix-installer

define BUILD
$(MAKE) -C $(APP) build PYTHON=$(PYTHON)
$(MAKE) -C $(APP) test PYTHON=$(PYTHON)
endef

define INSTALL
$(MAKE) -C $(APP) install DESTDIR=$(PROTO) HOST_PREFIX=/usr PYTHON=$(PYTHON)
endef

include ../../make-rules/component.mk
