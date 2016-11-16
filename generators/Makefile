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
	@echo "\t1. Generate various RDF serializations in directory $(TGT_DIR)."
	@echo "\t   These will be based on the contents of $(SRC_VOCAB_FILE), but with substitutions made for the base URI $(SRC_BASE_URI)."
	@echo "\t2. Generate SKOS files from the ones in $(SRC_STANDARD_DIR), but with substitutions made for the base URI $(SRC_BASE_URI)."
	@[ -n "$(TGT_BASE_URI)" ] && echo "\tWith tgt_version=$(tgt_version), $(SRC_BASE_URI) will be replaced by $(TGT_BASE_URI)." || true
	@[ -z "$(TGT_BASE_URI)" ] && echo "\tThe substitution will depend on the tgt_version specified on the make command line" || true
	@echo "make $(DEPLOY_target) tgt_version=x server=y"
	@echo "\tDeploy the generated data to the server."

#ifndef base_uri
  #$(info "You must set the variable base_uri on the command line. e.g. 'make target base_uri=http:foo.org/bar'")
#endif

# We create files in different subdirectories, corresponding to the URIs used in the vocabulary.
# For example
# URI                                  SUBDIR
# ---                                  ------
# http://purl.org/essglobal/standard   standard
# http://purl.org/essglobal/vocab      vocab

VOCAB_SUBDIR := vocab-content
STANDARD_SUBDIR := standard-content
HTML_SUBDIR := html-content
TGT_SUBDIRS := $(VOCAB_SUBDIR) $(STANDARD_SUBDIR) $(HTML_SUBDIR)

# The SRC_VOCAB_FILE and SRC_STANDARD_FILES will have $(SRC_BASE_URI) substituted with $(TGT_BASE_URI) when the GENERATE_target is made.
SRC_VOCAB_FILE := ../vocabs/vocab/essglobal-vocab.ttl
SRC_BASE_URI := http://purl.org/essglobal/
SRC_VOCAB_FILE_EXT := $(suffix $(SRC_VOCAB_FILE))

# SRC_TYPE is an argument for the -i flag of rapper
SRC_TYPE := turtle

SRC_STANDARD_DIR := ../vocabs/standard
SRC_STANDARD_FILES := activities.skos legal-form.skos products-services.skos qualifiers.skos themes.skos type-of-labour.skos

SRC_HTML_DIR := ../vocabs/html
SRC_HTML_FILE := 2015.01.11.html
SRC_CSS_FILE := default.css
SRC_HTML_FILES := $(SRC_HTML_FILE) $(SRC_CSS_FILE)

TGT_SUBDIR := $(tgt_version)

# Here we define variables that depend on the tgt_version.
# Note that some of the variables defined above could be (re)defined here, if necessary.
TGT_VERSIONS := ise experimental 1.1
ifeq ($(tgt_version),experimental)
  TGT_BASE_URI := http://purl.org/essglobal/experimental/
else ifeq ($(tgt_version),ise)
  TGT_BASE_URI := http://purl.org/solidarityeconomics/experimental/essglobal/
  # SERVER details are needed for deployment
  SERVER_SSH_CONFIG_NAME := parecco
  # www-vocabs is symboloc link on server:
  SERVER_DIR := www-vocabs/
  SERVER_SUB_DIR := experimental/essglobal
else ifeq ($(tgt_version),1.1)
  TGT_BASE_URI := http://purl.org/essglobal/
else
  $(warning "Unrecognized tgt_version")
endif

# Directory for generated serializations (and maybe other files, like .htaccess?)
TGT_DIR := generated/$(TGT_SUBDIR)
TGT_VOCAB_DIR := $(TGT_DIR)/$(VOCAB_SUBDIR)
$(TGT_VOCAB_DIR):
	mkdir -p $@

TGT_STANDARD_DIR := $(TGT_DIR)/$(STANDARD_SUBDIR)
$(TGT_STANDARD_DIR):
	mkdir -p $@

TGT_HTML_DIR := $(TGT_DIR)/$(HTML_SUBDIR)
$(TGT_HTML_DIR):
	mkdir -p $@

# Target file has the same name as SRC_VOCAB_FILE, but is in a different dir:
TGT_VOCAB_FILE := $(TGT_VOCAB_DIR)/$(notdir $(SRC_VOCAB_FILE))

# Similarly for the SKOS files in STANDARD:
TGT_STANDARD_FILES := $(addprefix $(TGT_STANDARD_DIR)/,$(SRC_STANDARD_FILES))

# And for HTML files too:
TGT_HTML_FILES := $(addprefix $(TGT_HTML_DIR)/,$(SRC_HTML_FILES))

# The TGT_VOCAB_FILE and the TGT_STANDARD_FILES are all generated using string substitution (with sed).
# This is a gnu make canned recipe (see https://www.gnu.org/software/make/manual/html_node/Canned-Recipes.html#Canned-Recipes)
# that works for both:
# Note: contrary to the Gnu Make documentation, we need to miss out the '=' (docs say to use 'define do_uri_subst =').
#       See http://stackoverflow.com/questions/5033181/gnu-make-differences-in-multiline-variable-declarations
#       Currently, bombyx has make V3.81, and gmake 4.1. Omitting the '=' works with both.
define do_uri_subst
@[ -n "$(tgt_version)" ] || { echo "You must specify tgt_version. e.g. make tgt_version=experimental $(MAKECMDGOALS)" && false; }
@[ -n "$(TGT_BASE_URI)" ] || { echo "Make variable TGT_BASE_URI not set. Perhaps you requested an invalid tgt_version, or the tgt_version you specified is not configured properly in the Makefile." && false; }
@grep --quiet '$(SRC_BASE_URI)' $< || { echo "$(SRC_BASE_URI) not found in file $<. Perhaps there's an error the definition of SRC_BASE_URI in the Makefile?" && false; }
sed 's|$(SRC_BASE_URI)|$(TGT_BASE_URI)|g' $< > $@
endef

# TGT_VOCAB_FILE is made from SRC_VOCAB_FILE by substituting SRC_BASE_URI with TGT_BASE_URI:
$(TGT_VOCAB_FILE): $(SRC_VOCAB_FILE) | $(TGT_VOCAB_DIR)
	$(do_uri_subst)

# TGT_RDFXML is made from TGT_VOCAB_FILE using rapper, 
# but only if it will not be made directly from SRC_VOCAB_FILE by substitution
# i.e. only if TGT_RDFXML is not identical to TGT_VOCAB_FILE (hence the ifneq):
# Documentation of the available serializations made by rapper can be found here: 
#    http://librdf.org/raptor/api/raptor-serializers.html
TGT_RDFXML := $(TGT_VOCAB_FILE:$(SRC_VOCAB_FILE_EXT)=.rdf)
ifneq ($(TGT_RDFXML),$(TGT_VOCAB_FILE))
$(GENERATE_target): $(TGT_RDFXML)
$(TGT_RDFXML): $(TGT_VOCAB_FILE)
	rapper -i $(SRC_TYPE) -o rdfxml-abbrev $< > $@
endif

# See comment about TGT_RDFXML, above. Same applies here, but for different serialization.
TGT_TURTLE := $(TGT_VOCAB_FILE:$(SRC_VOCAB_FILE_EXT)=.ttl)
ifneq ($(TGT_TURTLE),$(TGT_VOCAB_FILE))
$(GENERATE_target): $(TGT_TURTLE)
$(TGT_TURTLE): $(TGT_VOCAB_FILE)
	rapper -i $(SRC_TYPE) -o turtle $< > $@
endif

# Might as well generate an HTML file too:
# See comment about TGT_RDFXML, above. Same applies here, but for different serialization.
TGT_HTML := $(TGT_VOCAB_FILE:$(SRC_VOCAB_FILE_EXT)=.html)
$(GENERATE_target): $(TGT_HTML)
$(TGT_HTML): $(TGT_VOCAB_FILE)
	rapper -i $(SRC_TYPE) -o html $< > $@

# The files (SKOS files) in STANDARD are created by substituting the URI:
# Here's a gnu make pattern rule (see https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html#Pattern-Rules)
$(TGT_STANDARD_DIR)/%: $(SRC_STANDARD_DIR)/% | $(TGT_STANDARD_DIR)
	$(do_uri_subst)

# Add the list of STANDARD files to the generate target:
$(GENERATE_target): $(TGT_STANDARD_FILES)

# HTML files are straight copies froj source to target:
$(TGT_HTML_DIR)/%: $(SRC_HTML_DIR)/% | $(TGT_HTML_DIR)
	cp $< $@

# Add the list of HTML files to the generate target:
$(GENERATE_target): $(TGT_HTML_FILES)

TGT_HTACCESS := $(TGT_DIR)/.htaccess
GEN_HTACCESS := generate-htaccess.rb
RewriteBase := /$(SERVER_SUB_DIR)/
VocabUrlSuffix := vocab
VocabRdf := $(VOCAB_SUBDIR)/$(notdir $(TGT_RDFXML))
HtmlFile := $(HTML_SUBDIR)/$(SRC_HTML_FILE)
$(TGT_HTACCESS): $(GEN_HTACCESS) Makefile
	ruby $< $(RewriteBase) $(VocabUrlSuffix) $(VocabRdf) $(HtmlFile) > $@

$(GENERATE_target): $(TGT_HTACCESS)

README := $(TGT_DIR)/DO_NOT_EDIT_HERE.txt 
$(README):
	echo "This directory and subdirectories are generated from a script." > $@
	echo "Any changes you make here will be lost next time that script is run." >> $@
	echo "The script is https://github.com/essglobal-linked-open-data/map-sse/blob/develop/generators/Makefile" >> $@

$(GENERATE_target): $(README)

$(GENERATE_target):
	@echo "Files generated for target version $(tgt_version) can be found in directory $(TGT_DIR)."

###################
# Deployment to server
###################
RSYNC := rsync -avz 
# Define macro for executing commands on the server (here using ssh):
SERVER_CMD = ssh $(SERVER_SSH_CONFIG_NAME) $(1)

# Careful! The --delete option will remove any files on the server that are not also in TGT_DIR
$(DEPLOY_target): $(GENERATE_target)
	$(call SERVER_CMD,'cd $(SERVER_DIR) && mkdir -p $(SERVER_SUB_DIR)')
	$(RSYNC) --delete $(TGT_DIR)/ $(SERVER_SSH_CONFIG_NAME):$(SERVER_DIR)$(SERVER_SUB_DIR)/
