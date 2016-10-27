# Hint: type 'make' to get the usage message.

GENERATE_target := generate-vocab
DEPLOY_target := deploy
HELP_target := help
.PHONY: $(HELP_target) $(GENERATE_target) $(DEPLOY_target)
.DEFAULT_GOAL: $(HELP_target)

$(HELP_target):
	@echo USAGE
	@echo -----
	@echo "make $(HELP_target)"
	@echo "\tPrint help."
	@echo "make $(HELP_target) tgt_version=x"
	@echo "\tPrint help about a specific target version."
	@echo "\tValid target version are: $(TGT_VERSIONS)"
	@echo "make $(GENERATE_target) tgt_version=x"
	@echo "\tGenerate various RDF serializations in directory $(TGT_DIR)."
	@echo "\tThese will be based on the contents of $(SRC_FILE), but with substitutions made for the base URI $(SRC_BASE_URI)."
	@[ -n "$(TGT_BASE_URI)" ] && echo "\tWith tgt_version=$(tgt_version), $(SRC_BASE_URI) will be replaced by $(TGT_BASE_URI)." || true
	@[ -z "$(TGT_BASE_URI)" ] && echo "\tThe substitution will depend on the tgt_version specified on the make command line" || true
	@echo "make $(DEPLOY_target) tgt_version=x"
	@echo "\tDeploy the generated data to the server."

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

# Here we define variables that depend on the tgt_version.
TGT_VERSIONS := experimental 1.1
ifeq ($(tgt_version),experimental)
  TGT_BASE_URI := http://purl.org/essglobal/experimental/
else ifeq ($(tgt_version),1.1)
  TGT_BASE_URI := http://purl.org/essglobal/
else
  $(warning "Unrecognized tgt_version")
endif

# Output directory:
TGT_DIR := generated/$(TGT_SUBDIR)
$(TGT_DIR):
	mkdir -p $@

# Target file has the same name as SRC_FILE, but is in a different dir:
TGT_FILE := $(TGT_DIR)/$(notdir $(SRC_FILE))

# TGT_FILE is made from SRC_FILE by substituting SRC_BASE_URI with TGT_BASE_URI:
$(TGT_FILE): $(SRC_FILE) | $(TGT_DIR)
	@[ -n "$(tgt_version)" ] || { echo "You must specify tgt_version. e.g. make tgt_version=experimental $(MAKECMDGOALS)" && false; }
	@[ -n "$(TGT_BASE_URI)" ] || { echo "Make variable TGT_BASE_URI not set. Perhaps you requested an invalid tgt_version, or the tgt_version you specified is not configured properly in the Makefile." && false; }
	@grep --quiet '$(SRC_BASE_URI)' $< || { echo "$(SRC_BASE_URI) not found in file $<. Perhaps there's an error the definition of SRC_BASE_URI in the Makefile?" && false; }
	sed 's|$(SRC_BASE_URI)|$(TGT_BASE_URI)|g' $< > $@


# TGT_RDFXML is made from TGT_FILE using rapper, 
# but only if it will not be made directly from SRC_FILE by substitution
# i.e. only if TGT_RDFXML is not identical to TGT_FILE:
TGT_RDFXML := $(TGT_FILE:$(SRC_FILE_EXT)=.rdf)
ifneq ($(TGT_RDFXML),$(TGT_FILE))
$(GENERATE_target): $(TGT_RDFXML)
$(TGT_RDFXML): $(TGT_FILE)
	rapper -i $(SRC_TYPE) -o rdfxml-abbrev $< > $@
endif

# See comment about TGT_RDFXML, above. Same applies here, but for different serialization.
TGT_TURTLE := $(TGT_FILE:$(SRC_FILE_EXT)=.ttl)
ifneq ($(TGT_TURTLE),$(TGT_FILE))
$(GENERATE_target): $(TGT_TURTLE)
$(TGT_TURTLE): $(TGT_FILE)
	rapper -i $(SRC_TYPE) -o turtle $< > $@
endif

$(GENERATE_target):
	@echo "Files generated for target version $(tgt_version) can be found in directory $(TGT_DIR)."
