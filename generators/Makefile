
#ifndef base_uri
  #$(info "You must set the variable base_uri on the command line. e.g. 'make target base_uri=http:foo.org/bar'")
#endif

# The SRC_FILE will have $(SRC_BASE_URI) substituted with $(TGT_BASE_URI) to create $(TGT_FILE)
SRC_FILE := ../vocabs/vocab/essglobal-vocab.ttl
SRC_BASE_URI := http://purl.org/essglobal/
SRC_FILE_EXT := $(suffix $(SRC_FILE))

# SRC_TYPE is an argument for the -i flag of rapper
SRC_TYPE := turtle

TGT_SUBDIR := $(tgt_version)

ifeq ($(tgt_version),experimental)
  TGT_BASE_URI := http://purl.org/essglobal/experimental/
else ifeq ($(tgt_version),1.1)
  TGT_BASE_URI := http://purl.org/essglobal/
else
  $(error "Unrecognized tgt_version")
endif

# Output directory:
TGT_DIR := generated/$(TGT_SUBDIR)/
$(TGT_DIR):
	mkdir -p $@

# Target file has the same name as SRC_FILE, but is in a different dir:
TGT_FILE := $(TGT_DIR)$(notdir $(SRC_FILE))

# TGT_FILE is made from SRC_FILE by substituting SRC_BASE_URI with TGT_BASE_URI:
$(TGT_FILE): $(SRC_FILE) | $(TGT_DIR)
	sed 's|$(SRC_BASE_URI)|$(TGT_BASE_URI)|g' $< > $@


# TGT_RDFXML is made from TGT_FILE using rapper, 
# but only if it will not be made directly from SRC_FILE by substitution
# i.e. only if TGT_RDFXML is not identical to TGT_FILE:
TGT_RDFXML := $(TGT_FILE:$(SRC_FILE_EXT)=.rdf)
ifneq ($(TGT_RDFXML),$(TGT_FILE))
generate-vocab: $(TGT_RDFXML)
$(TGT_RDFXML): $(TGT_FILE)
	rapper -i $(SRC_TYPE) -o rdfxml-abbrev $< > $@
endif

# See comment about TGT_RDFXML, above. Same applies here, but for different serialization.
TGT_TURTLE := $(TGT_FILE:$(SRC_FILE_EXT)=.ttl)
ifneq ($(TGT_TURTLE),$(TGT_FILE))
generate-vocab: $(TGT_TURTLE)
$(TGT_TURTLE): $(TGT_FILE)
	rapper -i $(SRC_TYPE) -o turtle $< > $@
endif


