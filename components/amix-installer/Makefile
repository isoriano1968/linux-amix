# The AMIX Installer: a GTK 4 / libadwaita app that makes an Amiga UNIX disk
# for an Amiga 3000/2500 or FS-UAE from your own AMIX core system.  Same files
# as the OpenIndiana package desktop/amix-installer, under /usr.
NAME      = amix-installer
VERSION   = 0.6.2
ARCH      = all
SECTION   = otherosfs
DEPENDS   = python3 (>= 3.9), python3-gi, gir1.2-gtk-4.0 (>= 4.12), gir1.2-adw-1 (>= 1.4)
# what it needs to make kernels and boot disks: installed with it by default
RECOMMENDS = amix-pvmk, amix-gcc-27, amix-kernel-kit-tools, amix-rtgfb-kit, \
	amix-zz9000-kit, amix-va2000-kit, amix-hydra-kit, amix-xsurf100-kit, \
	amix-zz9000eth-kit, amix-z3660eth-kit, amix-z3660scsi-kit, amix-z3660rtg-kit, amix-buddha-kit, amix-a4091-kit, fs-uae, xdg-user-dirs
SUMMARY   = makes Amiga UNIX (AMIX) disks for an Amiga or FS-UAE

SOURCES   = au
AU_COMMIT = 1c63a2bb53f0e03ea7858f2856957cc561daf22d
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = 97785766ba2abab00f665d42883b4de6fde67297b70cded81b98000ddf1c1a98
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
