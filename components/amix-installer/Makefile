# The AMIX Installer: a GTK 4 / libadwaita app that makes an Amiga UNIX disk
# for an Amiga 3000/2500 or FS-UAE from your own AMIX core system.  Same files
# as the OpenIndiana package desktop/amix-installer, under /usr.
NAME      = amix-installer
VERSION   = 0.9.0
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
SUMMARY   = makes Amiga UNIX (AMIX) disks for an Amiga or FS-UAE

SOURCES   = au
AU_COMMIT = 4620783a709bbbda043fb04c6c9a839e6b4a350c
URL_au    = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au   = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au = a428731af61ac74058a172e798c6e5773459fb79219354a8dd8fc55af02174a5
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
