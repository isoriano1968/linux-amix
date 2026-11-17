#!/bin/sh
# build-in-docker.sh [COMPONENT...] -- build components in a Debian 13
# container, as root inside it, and leave the .deb files in out/debs.
#
# The source tree is mounted read-only and copied in; downloads stay in
# distfiles/ between runs.  Packages already in out/debs that are not being
# rebuilt are installed first, so one component can be rebuilt alone.
# Nothing else in the container is kept.
set -eu
top=$(cd "$(dirname "$0")/.." && pwd)
image=linux-amix-build
comps="$*"
mkdir -p "$top/distfiles" "$top/out/debs"
docker build -q -t $image "$top/docker" >/dev/null
docker run --rm -v "$top:/src:ro" -v "$top/distfiles:/distfiles" -v "$top/out:/out" \
	-e JOBS="${JOBS:-$(nproc)}" -e COMPS="$comps" -e OWNER="$(id -u):$(id -g)" \
	$image sh -c '
	set -e
	mkdir /work
	cd /src && tar --exclude=./build --exclude=./out --exclude=./distfiles --exclude=./.git \
		-cf - . | tar -xf - -C /work
	cd /work
	pre=
	for f in /out/debs/*.deb; do
		[ -f "$f" ] || continue
		n=$(dpkg-deb -f "$f" Package)
		case " $COMPS " in *" $n "*) rm -f "$f" ;; *) pre="$pre $f" ;; esac
	done
	[ -z "$pre" ] || apt-get install -y --no-install-recommends $pre >/dev/null
	status=0
	if [ -n "$COMPS" ]; then
		make world COMPONENTS="$COMPS" DISTDIR=/distfiles OUT=/out/debs || status=$?
	else
		make world DISTDIR=/distfiles OUT=/out/debs || status=$?
	fi
	chown -R "$OWNER" /out /distfiles
	exit $status'
ls -l "$top/out/debs"
