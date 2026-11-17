# The shared pieces of the AMIX Installer's kernels: kit-tools/ (the io_init
# and level-2 chains, the loader's relocation check, the root stamp and the
# swap size tools) and kernel-040/ (amix-kernel-040 and the port's relink
# chain: our 68040/060 kernel made from the user's own stock kernel).  Same as
# the OpenIndiana package developer/amix/kernel-kit-tools.
NAME      = amix-kernel-kit-tools
VERSION   = 0.3
ARCH      = all
SECTION   = devel
SUMMARY   = AMIX Installer kernel tools: driver chains, root stamp, amix-kernel-040
DEPENDS   = python3, amix-gcc-27 (>= 2.7.2.3), amix-gcc-14 (>= 14.2.0), amix-sysroot (>= 2.1.2)
# amix-kernel-040's pinned byte checks are made with m68k-linux-gnu binutils;
# with them it needs nothing else (m68k-elf from amix-gcc-14 otherwise)
RECOMMENDS = binutils-m68k-linux-gnu, gcc-m68k-linux-gnu
SUGGESTS  = amix-installer

SOURCES   = gate
GATE_COMMIT = eca59c195bcf7ee6d2255568d7529f06d0d9acd7
URL_gate    = https://github.com/isoriano1968/amix-gate/archive/$(GATE_COMMIT).tar.gz
FILE_gate   = amix-gate-$(GATE_COMMIT).tar.gz
SHA256_gate = 49d201b366ebc1a06a5fae9f643a88655d714065f561210ca46493d34b0e59b3
DIR_gate    = amix-gate-$(GATE_COMMIT)

SYSROOT   = /opt/m68k-amix-sysroot
PORT      = $(SRC_gate)/usr/src/uts/amiga/port
KIT_PATH  = PATH=/opt/amix-cross/bin:/opt/m68k-amix/bin:$$PATH
SHARE     = $(PROTO)/usr/share/amix-installer

define BUILD
true
endef

define INSTALL
$(KIT_PATH) AMIX_ROOT=$(SYSROOT) sh $(PORT)/make-kit-tools.sh $(SHARE)/kit-tools
cd $(SHARE)/kit-tools && sha256sum -c --quiet KIT.sha256
cp $(PORT)/tools/stamp-rootcard.py $(PORT)/tools/kernel-nswap.py $(SHARE)/kit-tools/
$(KIT_PATH) sh $(PORT)/make-kernel-040-kit.sh $(SHARE)/kernel-040
cd $(SHARE)/kernel-040 && sha256sum -c --quiet KIT.sha256
endef

include ../../make-rules/component.mk
