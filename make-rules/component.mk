# component.mk -- what every linux-amix component shares: fetch a pinned
# upstream archive, check its sha256, unpack it, apply patches/, build,
# stage into a proto tree and make a .deb of it.  oi-userland style: a
# component is a Makefile of variables and a few recipe blocks.
#
# A component sets:
#   NAME VERSION [REVISION] ARCH (all | any) SUMMARY [SECTION]
#   [DEPENDS RECOMMENDS SUGGESTS PROVIDES] [SHLIBDEPS = yes]
#   LICENSE_FILE (default NAME.license), DESCRIPTION_FILE (default NAME.desc)
#   SOURCES = a b ...  and for each: URL_a SHA256_a [FILE_a] DIR_a
#   (DIR_a: the top directory of the unpacked archive; SRC_a is its path)
#   [PATCHES_a = patches/x.patch ...]  applied with -p1 in SRC_a
#   BUILD and INSTALL: recipe lines (define ... endef); INSTALL writes $(PROTO)
#
# Targets: fetch unpack build install deb clean
SHELL      := /bin/bash
TOP        := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
COMP_DIR   := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
DISTDIR    ?= $(TOP)/distfiles
WORK       ?= $(TOP)/build/$(NAME)
OUT        ?= $(TOP)/out/debs
PROTO      := $(WORK)/proto
REVISION   ?= 1
ARCH       ?= all
SECTION    ?= otherosfs
JOBS       ?= $(shell nproc)
PYTHON     ?= python3
LICENSE_FILE     ?= $(COMP_DIR)/$(NAME).license
DESCRIPTION_FILE ?= $(COMP_DIR)/$(NAME).desc
# reproducible: archive dates, gzip headers, the changelog date
SOURCE_DATE_EPOCH ?= 1794873600
export SOURCE_DATE_EPOCH

file_of = $(or $(FILE_$(1)),$(notdir $(URL_$(1))))
$(foreach s,$(SOURCES),$(eval SRC_$(s) := $(WORK)/src/$(DIR_$(s))))

.PHONY: all fetch unpack build install deb clean
all: deb

fetch:
	@mkdir -p $(DISTDIR)
	@set -e; $(foreach s,$(SOURCES), \
	  f=$(DISTDIR)/$(call file_of,$(s)); \
	  if ! [ -f $$f ]; then echo "fetch $(URL_$(s))"; \
	    curl -fsSL --retry 3 -o $$f.part "$(URL_$(s))"; mv $$f.part $$f; fi; \
	  echo "$(SHA256_$(s))  $$f" | sha256sum -c --quiet - || \
	    { echo "$$f: sha256 differs from $(SHA256_$(s))"; exit 1; };)

$(WORK)/.unpacked: | fetch
	rm -rf $(WORK)/src; mkdir -p $(WORK)/src
	@set -e; $(foreach s,$(SOURCES), \
	  tar -xf $(DISTDIR)/$(call file_of,$(s)) -C $(WORK)/src --no-same-owner; \
	  test -d $(SRC_$(s)) || { echo "$(SRC_$(s)): not in the archive"; exit 1; }; \
	  for p in $(PATCHES_$(s)); do echo "patch $$p"; \
	    patch -d $(SRC_$(s)) -p1 -s --no-backup-if-mismatch < $(COMP_DIR)/$$p; done;)
	touch $@
unpack: $(WORK)/.unpacked

$(WORK)/.built: $(WORK)/.unpacked
	$(BUILD)
	touch $@
build: $(WORK)/.built

install: $(WORK)/.built
	rm -rf $(PROTO); mkdir -p $(PROTO)
	$(INSTALL)

deb: install
	$(PYTHON) $(TOP)/tools/mkdeb.py --proto $(PROTO) --out $(OUT) --name $(NAME) \
	  --version $(VERSION) --revision $(REVISION) --arch $(ARCH) --section $(SECTION) \
	  --summary "$(SUMMARY)" --description-file $(DESCRIPTION_FILE) \
	  --license $(LICENSE_FILE) --depends "$(DEPENDS)" --recommends "$(RECOMMENDS)" \
	  --suggests "$(SUGGESTS)" --provides "$(PROVIDES)" \
	  $(if $(filter yes,$(SHLIBDEPS)),--shlibdeps)

clean:
	rm -rf $(WORK)
