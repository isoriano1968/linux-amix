# The MNT VA2000 kernel driver as AMIX Installer kits, for both kernel lines.
KIT       = va2000
VERSION   = 0.3
SUMMARY   = AMIX kernel driver kit: MNT VA2000 graphics (/dev/va2000)
GATE_COMMIT = eca59c195bcf7ee6d2255568d7529f06d0d9acd7
GATE_SHA256 = 49d201b366ebc1a06a5fae9f643a88655d714065f561210ca46493d34b0e59b3
KIT_LINES = 030 040
SOURCES   = va
VA2000_COMMIT = 7f82edcc3db9ddb0f28173ee41abe6c439e98327
URL_va    = https://github.com/asokero/va2000-amix/archive/$(VA2000_COMMIT).tar.gz
FILE_va   = va2000-amix-$(VA2000_COMMIT).tar.gz
SHA256_va = d97683a3f611aa16d9ca29d8c2d359c9f96a028ec0185550d4412c2b1dd9895c
DIR_va    = va2000-amix-$(VA2000_COMMIT)
KIT_ENV   = VA2000_SRC_DIR=$(SRC_va)

include ../../make-rules/kit.mk
