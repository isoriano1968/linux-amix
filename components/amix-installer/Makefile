# The AMIX Installer: a GTK 4 / libadwaita app that makes an Amiga UNIX disk
# for an Amiga 3000/2500 or FS-UAE from your own AMIX core system.  Same files
# as the OpenIndiana package desktop/amix-installer, under /usr.
NAME      = amix-installer
VERSION   = 0.6.0
ARCH      = all
SECTION   = otherosfs
DEPENDS   = python3 (>= 3.9), python3-gi, gir1.2-gtk-4.0 (>= 4.12), gir1.2-adw-1 (>= 1.4)
# what it needs to make kernels and boot disks: installed with it by default
RECOMMENDS = amix-pvmk, amix-gcc-27, amix-kernel-kit-tools, amix-rtgfb-kit, \
	amix-zz9000-kit, amix-va2000-kit, amix-hydra-kit, amix-xsurf100-kit, \
	amix-zz9000eth-kit, amix-z3660eth-kit, amix-z3660scsi-kit, amix-z3660rtg-kit, fs-uae, xdg-user-dirs
SUMMARY   = makes Amiga UNIX (AMIX) disks for an Amiga or FS-UAE

SOURCES   = au
AU_COMMIT = 8586c07f7e9a66f754b4819a6603911c4e09e6c7
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = 64098b057feddc354f8c2ee9eb343540cf8a8a27f15d64cc3147d8f6e6311336
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
