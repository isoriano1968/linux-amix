# The MNT VA2000 kernel driver as AMIX Installer kits, for both kernel lines.
KIT       = va2000
VERSION   = 0.1
SUMMARY   = AMIX kernel driver kit: MNT VA2000 graphics (/dev/va2000)
GATE_COMMIT = b0a9fd5b569f22e34e4381b9418ffc00fc171239
GATE_SHA256 = 08715c050f176a318957ab5cb1493002f90b16047ed1643869fc267fa6873b53
KIT_LINES = 030 040
SOURCES   = va
VA2000_COMMIT = 7f82edcc3db9ddb0f28173ee41abe6c439e98327
URL_va    = https://github.com/asokero/va2000-amix/archive/$(VA2000_COMMIT).tar.gz
FILE_va   = va2000-amix-$(VA2000_COMMIT).tar.gz
SHA256_va = d97683a3f611aa16d9ca29d8c2d359c9f96a028ec0185550d4412c2b1dd9895c
DIR_va    = va2000-amix-$(VA2000_COMMIT)
KIT_ENV   = VA2000_SRC_DIR=$(SRC_va)

include ../../make-rules/kit.mk
