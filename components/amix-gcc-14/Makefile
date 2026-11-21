# The modern AMIX cross compiler: gcc 14.2.0 (C, C++ with libstdc++,
# exceptions and RTTI) and binutils 2.43.1 for m68k-elf, the ABI of AMIX 2.1
# userland, with amix-userland's AMIX specs, fixed headers and libamixc99.
# Same build as the OpenIndiana package developer/amix/gcc-14.
NAME      = amix-gcc-14
VERSION   = 14.2.0
ARCH      = any
SECTION   = devel
SHLIBDEPS = yes
# 2: the 68020 ISA tuned for the 68060 by default, and libamixc99 as the
# shared libamixc99.so.1 (no 68060 libamixc99.a), as amix-userland builds it
REVISION  = 2
DEPENDS   = amix-sysroot (>= 2.1.2)
SUMMARY   = AMIX cross compiler: gcc 14.2.0 (C, C++) and binutils 2.43.1 (m68k-elf)

SOURCES   = gcc binutils au
URL_gcc       = https://ftp.gnu.org/gnu/gcc/gcc-$(VERSION)/gcc-$(VERSION).tar.xz
SHA256_gcc    = a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9
DIR_gcc       = gcc-$(VERSION)
URL_binutils  = https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.xz
SHA256_binutils = 13f74202a3c4c51118b797a39ea4200d3f6cfbe224da6d1d95bb938480132dfd
DIR_binutils  = binutils-2.43.1
AU_COMMIT     = 5bae14a830d0c7f866c84fd5cab8808eec6ac9d9
URL_au        = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au       = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au     = f25b862c59ee1665811dc1e7b068dff175985ce3bdf50c0764b43a2480b387d3
DIR_au        = amix-userland-$(AU_COMMIT)

TARGET    = m68k-elf
PREFIX    = /opt/m68k-amix
SYSROOT   = /opt/m68k-amix-sysroot
STAGE     = $(WORK)/stage
SP        = $(STAGE)$(PREFIX)
A14       = $(SRC_au)/components/developer/gcc-14
GCC_LIBDIR = lib/gcc/$(TARGET)/$(VERSION)
CPU       = -mcpu=68020 -mtune=68060 -fexcess-precision=fast
BPATH     = PATH=$(SP)/bin:$$PATH
MARGS     = MAKEINFO=true
GCC_CONFIGURE = --target=$(TARGET) --prefix=$(PREFIX) --with-sysroot=$(SYSROOT) \
	--enable-languages=c,c++ --disable-nls --disable-shared --disable-threads \
	--disable-libssp --disable-libgomp --disable-libatomic --disable-libquadmath \
	--disable-libvtv --disable-libsanitizer --disable-libstdcxx-filesystem-ts \
	--disable-libstdcxx-pch --disable-libstdcxx-backtrace --disable-multilib \
	--disable-gcov --with-cpu=68020

# the AMIX changes to the pristine gcc, then the config.sh the toolchain
# scripts read (they install into the stage, which becomes the package)
define BUILD
$(PYTHON) $(A14)/toolchain/patch-libstdcxx-configure.py $(SRC_gcc)/libstdc++-v3/configure $(SYSROOT)
$(PYTHON) $(A14)/toolchain/patch-gcc-svr4-return.py $(SRC_gcc)/gcc/config/m68k/m68kemb.h
$(PYTHON) $(A14)/toolchain/patch-gcc-060-fpu.py $(SRC_gcc)/gcc/config/m68k/m68k.md
printf '%s\n' '# written by the linux-amix amix-gcc-14 component' 'AMIX_SYSROOT="$(SYSROOT)"' \
	'TC_PREFIX="$(SP)"' 'TC_TARGET="$(TARGET)"' 'AMIX_CPU="$(CPU)"' > $(A14)/config.sh
rm -rf $(WORK)/binutils $(WORK)/gcc $(WORK)/stage
mkdir -p $(WORK)/binutils $(WORK)/gcc
cd $(WORK)/binutils && $(SRC_binutils)/configure --target=$(TARGET) --prefix=$(PREFIX) \
	--with-sysroot=$(SYSROOT) --disable-nls --disable-werror --disable-gdb --disable-sim \
	--disable-libdecnumber --disable-readline --disable-gprofng
$(MAKE) -C $(WORK)/binutils -j$(JOBS) $(MARGS)
$(MAKE) -C $(WORK)/binutils install DESTDIR=$(STAGE) $(MARGS)
cd $(WORK)/gcc && $(BPATH) $(SRC_gcc)/configure $(GCC_CONFIGURE)
$(BPATH) $(MAKE) -C $(WORK)/gcc -j$(JOBS) $(MARGS) all-gcc
$(BPATH) $(MAKE) -C $(WORK)/gcc $(MARGS) install-gcc DESTDIR=$(STAGE)
$(BPATH) bash $(A14)/toolchain/install-specs.sh
cp $(SP)/$(GCC_LIBDIR)/specs $(WORK)/gcc/gcc/specs
$(BPATH) $(MAKE) -C $(WORK)/gcc -j$(JOBS) $(MARGS) all-gcc
$(BPATH) bash $(A14)/toolchain/install-fixed-headers.sh
cp $(A14)/compat/include/stdint.h $(SP)/$(GCC_LIBDIR)/include-fixed/stdint.h
bash $(COMP_DIR)/files/check-include-fixed.sh $(SP)/$(GCC_LIBDIR)/include-fixed
mkdir -p $(WORK)/gcc/gcc/include-fixed
cp -R $(SP)/$(GCC_LIBDIR)/include-fixed/. $(WORK)/gcc/gcc/include-fixed/
$(BPATH) $(MAKE) -C $(WORK)/gcc -j$(JOBS) $(MARGS) all-target-libgcc
$(BPATH) $(MAKE) -C $(WORK)/gcc $(MARGS) install-target-libgcc DESTDIR=$(STAGE)
$(BPATH) bash $(A14)/tools/build-compat.sh
cp -P $(SP)/$(TARGET)/lib/amix_init.o $(SP)/$(TARGET)/lib/libamixc99.so.1 $(SP)/$(TARGET)/lib/libamixc99.so $(WORK)/gcc/gcc/
$(BPATH) $(MAKE) -C $(WORK)/gcc -j$(JOBS) $(MARGS) all-target-libstdc++-v3
$(BPATH) $(MAKE) -C $(WORK)/gcc $(MARGS) install-target-libstdc++-v3 DESTDIR=$(STAGE)
endef

# no C library symbols mangled as C++ in libstdc++, no host headers fixed in
define INSTALL
bad=$$($(SP)/bin/$(TARGET)-nm $(SP)/$(TARGET)/lib/libstdc++.a 2>/dev/null | \
	grep -c -e _Z4freePv -e _Z6mallocm -e _Z5abortv -e _Z8strerrori || true); \
	test "$$bad" = 0 || { echo "libstdc++.a has $$bad mangled C library symbols"; exit 1; }
bash $(COMP_DIR)/files/check-include-fixed.sh $(SP)/$(GCC_LIBDIR)/include-fixed
# libamixc99 only as the shared library: an archive would be linked instead
test ! -e $(SP)/$(TARGET)/lib/libamixc99.a
test -f $(SP)/$(TARGET)/lib/libamixc99.so.1
cp -a $(STAGE)/. $(PROTO)/
rm -rf $(PROTO)$(PREFIX)/share/info $(PROTO)$(PREFIX)/share/man
endef

include ../../make-rules/component.mk
