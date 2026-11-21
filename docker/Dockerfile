# The build machine for linux-amix: Debian 13 (trixie) with what every
# component needs.  tools/build-in-docker.sh runs the build as root in a
# container of it, so packages can be installed into /opt as later
# components need them; only the finished .deb files leave the container.
# git: the AMIX Installer's tests clone and pull amix-userland checkouts.
FROM debian:trixie
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential make m4 bison flex patch file curl ca-certificates \
	xz-utils bzip2 gzip tar autotools-dev dpkg-dev lintian \
	libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev libzstd-dev \
	python3 python3-cairo python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 \
	git pkg-config \
	&& rm -rf /var/lib/apt/lists/*
