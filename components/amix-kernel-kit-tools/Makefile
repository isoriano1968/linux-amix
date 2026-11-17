# The shared pieces every AMIX Installer kernel relink uses: patch_io_init.py
# (the io_init boot hook), check_relink_relocs.py and the amixdrv_init stub
# template.  Same as the OpenIndiana package developer/amix/kernel-kit-tools.
KIT       = kit-tools
VERSION   = 0.2
SUMMARY   = AMIX Installer kernel kit tools (io_init chain, relocation check)
GATE_COMMIT = 400b2263b4b0272850b2403e098ebc7a585411e8
GATE_SHA256 = cd3c754742fd6168ce0d70326764c5d7a2de8030c20d2193ab92de6c9b8bd588
KIT_PORT  = usr/src/uts/amiga/port
KIT_DIR_NAME = kernel-kit-tools
KIT_SCRIPT = make-kit-tools.sh

include ../../make-rules/kit.mk
