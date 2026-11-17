#!/bin/sh
# mkrepo.sh DEBS REPO -- a flat apt repository of the .deb files in DEBS:
#   deb [trusted=yes] file:/path/to/REPO ./     (or the same over http)
# Packages, Packages.gz and a Release file with their checksums.  It is not
# signed: apt needs [trusted=yes] for it.
set -eu
debs=${1:?usage: mkrepo.sh DEBS REPO}
repo=${2:?usage: mkrepo.sh DEBS REPO}
mkdir -p "$repo"
find "$repo" -maxdepth 1 -name '*.deb' -delete
cp "$debs"/*.deb "$repo"/
cd "$repo"
dpkg-scanpackages --multiversion . /dev/null > Packages 2>/dev/null
gzip -9nc Packages > Packages.gz
{
	echo "Origin: linux-amix"
	echo "Label: linux-amix"
	echo "Suite: stable"
	echo "Codename: amix"
	echo "Architectures: amd64 all"
	echo "Description: AMIX host packages: installer, cross compilers, sysroot, kernel kits"
	echo "Date: $(LC_ALL=C date -u -R)"
	echo "SHA256:"
	for f in Packages Packages.gz; do
		printf ' %s %s %s\n' "$(sha256sum $f | cut -d' ' -f1)" "$(wc -c < $f)" "$f"
	done
} > Release
echo "$repo: $(ls *.deb | wc -l) packages"
