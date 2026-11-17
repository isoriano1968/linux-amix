#!/bin/sh
# test-install.sh REPO -- install amix-installer and amix-cross-dev from the
# apt repository REPO into a clean Debian 13 container, as a user would, and
# check that they work: the installer starts and finds its kits, pvmk and the
# cross tools; both compilers build an AMIX program.
# AMIX_TEST_KERNEL=/path/to/a/stock/unix also relinks it with every kit;
# AMIX_TEST_K040=1 also makes the 68040/060 kernel from it (fetches NetBSD's
# syssrc.tgz, 76 MB; amix-gcc-14's m68k-elf tools only) and links every
# 040 kit into it.
set -eu
repo=$(cd "${1:?usage: test-install.sh REPO}" && pwd)
here=$(cd "$(dirname "$0")" && pwd)
kmount=
if [ -n "${AMIX_TEST_KERNEL:-}" ]; then
	kmount="-v $(cd "$(dirname "$AMIX_TEST_KERNEL")" && pwd)/$(basename "$AMIX_TEST_KERNEL"):/kernel/unix:ro"
fi
docker run --rm -e AMIX_TEST_K040="${AMIX_TEST_K040:-}" \
	-v "$repo:/repo:ro" -v "$here/smoke-test.sh:/smoke-test.sh:ro" $kmount \
	debian:trixie sh -c '
	set -e
	echo "deb [trusted=yes] file:/repo ./" > /etc/apt/sources.list.d/linux-amix.list
	apt-get update -qq
	DEBIAN_FRONTEND=noninteractive apt-get install -y -qq amix-installer amix-cross-dev >/dev/null
	dpkg-query -W -f "\${Package} \${Version}\n" "amix-*"
	sh /smoke-test.sh'
