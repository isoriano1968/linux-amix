# The C compiler AMIX itself is built with: gcc 2.7.2.3 and binutils 2.8.1
# for m68k-cbm-sysv4, with the AMIX fixes from amix-userland.  For the
# kernel, drivers and modules (the AMIX Installer links its kernels with this
# ld and as).  Same build as the OpenIndiana package developer/amix/gcc-27.
NAME      = amix-gcc-27
VERSION   = 2.7.2.3
ARCH      = any
SECTION   = devel
SHLIBDEPS = yes
DEPENDS   = amix-sysroot (>= 2.1.2)
SUMMARY   = AMIX cross compiler: gcc 2.7.2.3 and binutils 2.8.1 (m68k-cbm-sysv4)

SOURCES   = gcc binutils au
URL_gcc       = https://ftp.gnu.org/gnu/gcc/gcc-$(VERSION).tar.gz
SHA256_gcc    = 16166e0f0f2064bb3114716650569065ef3855ae2331d7a29b85d4b9aa73773c
DIR_gcc       = gcc-$(VERSION)
URL_binutils  = https://ftp.gnu.org/gnu/binutils/binutils-2.8.1.tar.gz
SHA256_binutils = c7ad94c18f098f0580d0a7cd68638e98aa98571078536934fdc85f5e9047bf5a
DIR_binutils  = binutils-2.8.1
AU_COMMIT     = f32d64de975b8fc8c0e2360f4df13ae9198324c2
URL_au        = https://github.com/isoriano1968/amix-userland/archive/$(AU_COMMIT).tar.gz
FILE_au       = amix-userland-$(AU_COMMIT).tar.gz
SHA256_au     = c229a660d30622ec9325a904333dc349c2ec2d62b9aa5ab1f87902b91f62580b
DIR_au        = amix-userland-$(AU_COMMIT)
# the wrapper: private temporaries, ld as a child (for upstream amix-userland)
PATCHES_au    = patches/0001-wrapper-portable-mktemp.patch

TARGET    = m68k-cbm-sysv4
PREFIX    = /opt/amix-cross
P         = $(PROTO)$(PREFIX)
G27       = $(SRC_au)/components/developer/gcc-27
GCC_LIBDIR = lib/gcc-lib/$(TARGET)/$(VERSION)
HOST_CC   = gcc
# gcc 2.7's configure knows no x86_64 Linux: it is configured as i686, as in
# amix-userland, and built by the 64-bit host compiler
GCC_HOST  = i686-pc-linux-gnu
HOST_CFLAGS = -O2 -g -std=gnu89 -fcommon -no-pie
HOST_ARGS = CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" MAKEINFO=true
STAGE     = $(WORK)/stage$(PREFIX)
LIBGCC2_FUNCS = _muldi3 _divdi3 _moddi3 _udivdi3 _umoddi3 _negdi2 \
	_lshrdi3 _ashldi3 _ashrdi3 _udiv_w_sdiv _udivmoddi4 _cmpdi2 _ucmpdi2 \
	_floatdidf _floatdisf _floatdixf _fixunsdfdi _fixdfdi _fixunssfdi \
	__gcc_bcmp _clear_cache _shtab _trampoline

# amix-userland's own patches to binutils and gcc, then fresh config.guess/sub
# (the 1997 ones know no x86_64 Linux)
define BUILD
chmod -R u+w $(SRC_gcc) $(SRC_binutils)
set -e; for p in $(G27)/patches/binutils-*.patch $(G27)/patches/gcc-*.patch; do \
	echo "amix-userland patch $$p"; patch -d $(WORK)/src -p1 -s --no-backup-if-mismatch < $$p; done
find $(SRC_gcc) $(SRC_binutils) -name config.guess -exec cp /usr/share/misc/config.guess {} \;
find $(SRC_gcc) $(SRC_binutils) -name config.sub -exec cp /usr/share/misc/config.sub {} \;
touch $(SRC_gcc)/c-parse.c $(SRC_gcc)/c-gperf.h
rm -rf $(WORK)/binutils $(WORK)/gcc $(WORK)/stage; mkdir -p $(WORK)/binutils $(WORK)/gcc
cd $(WORK)/binutils && $(HOST_ARGS) $(SRC_binutils)/configure --target=$(TARGET) \
	--prefix=$(PREFIX) --disable-nls
$(MAKE) -C $(WORK)/binutils -j$(JOBS) $(HOST_ARGS)
mkdir -p $(STAGE)
$(MAKE) -C $(WORK)/binutils install $(HOST_ARGS) prefix=$(STAGE) exec_prefix=$(STAGE) \
	tooldir=$(STAGE)/$(TARGET)
cd $(WORK)/gcc && PATH=$(STAGE)/bin:$$PATH $(HOST_ARGS) $(SRC_gcc)/configure \
	--build=$(GCC_HOST) --host=$(GCC_HOST) --target=$(TARGET) --prefix=$(PREFIX) \
	--with-gnu-as --with-gnu-ld
cd $(WORK)/gcc && $(STAGE)/bin/$(TARGET)-ar rc libgcc1.a && $(STAGE)/bin/$(TARGET)-ranlib libgcc1.a
PATH=$(STAGE)/bin:$$PATH $(MAKE) -C $(WORK)/gcc -j$(JOBS) LANGUAGES=c $(HOST_ARGS) xgcc cc1 cccp
endef

define INSTALL
mkdir -p $(P)
cp -a $(STAGE)/. $(P)/
mkdir -p $(P)/bin $(P)/$(GCC_LIBDIR) $(P)/$(TARGET)
cp $(WORK)/gcc/xgcc $(P)/bin/$(TARGET)-gcc.real
cp $(WORK)/gcc/cc1 $(P)/$(GCC_LIBDIR)/cc1
cp $(WORK)/gcc/cccp $(P)/$(GCC_LIBDIR)/cpp
$(WORK)/gcc/xgcc -B$(WORK)/gcc/ -dumpspecs > $(P)/$(GCC_LIBDIR)/specs
sed 's/@TARGET@/$(TARGET)/g' $(G27)/amix-gcc-wrapper.sh > $(P)/bin/$(TARGET)-gcc
chmod 755 $(P)/bin/$(TARGET)-gcc $(P)/bin/$(TARGET)-gcc.real $(P)/$(GCC_LIBDIR)/cc1 $(P)/$(GCC_LIBDIR)/cpp
rm -f $(P)/$(TARGET)/sysroot
ln -s ../../m68k-amix-sysroot $(P)/$(TARGET)/sysroot
rm -rf $(WORK)/libgcc; mkdir -p $(WORK)/libgcc
set -e; for name in $(LIBGCC2_FUNCS); do \
	GCC_EXEC_PREFIX=$(P)/lib/gcc-lib/ $(P)/bin/$(TARGET)-gcc -O2 \
		-I$(WORK)/gcc -I$(SRC_gcc) -I$(SRC_gcc)/config -I$(SRC_gcc)/ginclude \
		-DL$$name -c $(SRC_gcc)/libgcc2.c -o $(WORK)/libgcc/$$name.o; done
cd $(WORK)/libgcc && $(P)/bin/$(TARGET)-ar rc libgcc.a $(LIBGCC2_FUNCS:%=%.o) && \
	$(P)/bin/$(TARGET)-ranlib libgcc.a
cp $(WORK)/libgcc/libgcc.a $(P)/$(GCC_LIBDIR)/libgcc.a
rm -rf $(P)/info $(P)/man
endef

include ../../make-rules/component.mk
