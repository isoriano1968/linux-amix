# The shared pieces every AMIX Installer kernel relink uses: patch_io_init.py
# (the io_init boot hook), check_relink_relocs.py and the amixdrv_init stub
# template.  Same as the OpenIndiana package developer/amix/kernel-kit-tools.
KIT       = kit-tools
VERSION   = 0.1
SUMMARY   = AMIX Installer kernel kit tools (io_init chain, relocation check)
GATE_COMMIT = a320dfb743bd145d9d934f578dbac2e46b596e9f
GATE_SHA256 = 707953375cd1f1b778aaa96414702fdad1dce4b9a822c7f1c4304e4386a6f23d
KIT_PORT  = usr/src/uts/amiga/port
KIT_DIR_NAME = kernel-kit-tools
KIT_SCRIPT = make-kit-tools.sh

include ../../make-rules/kit.mk
