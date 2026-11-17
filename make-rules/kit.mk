# kit.mk -- an AMIX Installer kernel kit from amix-gate: a driver's object
# files and relink scripts, built with gcc 2.7.2.3 against the AMIX sysroot
# by the driver's own port/make-kit-<line>.sh, checked against its
# KIT.sha256, in /usr/share/amix-installer/<id> (030 line) and
# /usr/share/amix-installer/<id>-040 (040 line).
#
# A kit component sets:  KIT (the driver id), VERSION, GATE_COMMIT,
# GATE_SHA256, [KIT_LINES = 030 040], [KIT_PORT: io/<id>/port by default],
# [KIT_ENV: extra environment for make-kit], [KIT_DIR_NAME = <id>]
# and may add SOURCES of its own (SOURCES += ...).
NAME      = amix-$(KIT_DIR_NAME)
ARCH      = all
SECTION   = devel
KIT_LINES ?= 030
KIT_DIR_NAME ?= $(KIT)-kit
KIT_PORT  ?= usr/src/uts/amiga/io/$(KIT)/port
KIT_SHARE ?= $(KIT)
# make-kit-<line>.sh, or one script for every line (kit-tools)
KIT_SCRIPT ?=
SYSROOT   = /opt/m68k-amix-sysroot
SUGGESTS  = amix-installer

SOURCES  += gate
URL_gate    = https://github.com/isoriano1968/amix-gate/archive/$(GATE_COMMIT).tar.gz
FILE_gate   = amix-gate-$(GATE_COMMIT).tar.gz
SHA256_gate = $(GATE_SHA256)
DIR_gate    = amix-gate-$(GATE_COMMIT)

# the kits are compiled with the two AMIX cross compilers
KIT_PATH = PATH=/opt/amix-cross/bin:/opt/m68k-amix/bin:$$PATH

define BUILD
true
endef

define INSTALL
set -e; for line in $(KIT_LINES); do \
	if [ $$line = 030 ]; then d=$(KIT_SHARE); else d=$(KIT_SHARE)-$$line; fi; \
	dest=$(PROTO)/usr/share/amix-installer/$$d; \
	$(KIT_PATH) $(KIT_ENV) AMIX_ROOT=$(SYSROOT) sh $(SRC_gate)/$(KIT_PORT)/$(or $(KIT_SCRIPT),make-kit-$$line.sh) $$dest; \
	(cd $$dest && sha256sum -c --quiet KIT.sha256); \
	echo "kit $$d: $$(grep -c . $$dest/KIT.sha256) files"; \
done
endef

include ../../make-rules/component.mk
