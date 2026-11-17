# linux-amix: the AMIX host packages for Debian and Ubuntu, from the same
# pinned sources as the OpenIndiana packages in oi-userland.
#
#   make world        every component in order, each installed before the
#                     next one builds (run as root: in the container)
#   make docker       the same in a Debian 13 container (tools/build-in-docker.sh)
#   make repo         an apt repository of out/debs (Packages, Release)
#   make test-install apt install amix-installer and amix-cross-dev from that
#                     repository in a clean container
#   make -C components/<name> deb     one package
#
# Packages land in out/debs.
COMPONENTS = amix-sysroot amix-gcc-27 amix-gcc-14 amix-amixc99 \
	amix-kernel-kit-tools amix-rtgfb-kit amix-zz9000-kit amix-hydra-kit amix-va2000-kit \
	amix-xsurf100-kit amix-zz9000eth-kit amix-z3660eth-kit amix-z3660scsi-kit \
	amix-pvmk amix-installer amix-cross-dev
OUT ?= $(CURDIR)/out/debs

.PHONY: world docker repo test-install clean $(COMPONENTS)
world: $(COMPONENTS)

# each one is built, then installed with apt (its dependencies checked too)
$(COMPONENTS):
	$(MAKE) -C components/$@ deb OUT=$(OUT)
	apt-get install -y --no-install-recommends $(OUT)/$@_*.deb

docker:
	sh tools/build-in-docker.sh $(COMPONENTS)

repo:
	sh tools/mkrepo.sh $(OUT) $(CURDIR)/out/repo

test-install:
	sh tools/test-install.sh $(CURDIR)/out/repo

clean:
	rm -rf build out
