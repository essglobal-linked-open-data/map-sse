# Hint: type 'make' to get the usage message.

GENERATE_target := generate
DEPLOY_target := deploy
HELP_target := help
TEST_target := test
.PHONY: $(HELP_target) $(GENERATE_target) $(DEPLOY_target) $(TEST_target)
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
	@echo "\t3. Generate HTML files from the ones in $(SRC_HTML_DIR), but with substitutions made for the base URI $(SRC_BASE_URI)."
	@[ -n "$(TGT_BASE_URI)" ] && echo "\tWith tgt_version=$(tgt_version), $(SRC_BASE_URI) will be replaced by $(TGT_BASE_URI)." || true
	@[ -z "$(TGT_BASE_URI)" ] && echo "\tThe substitution will depend on the tgt_version specified on the make command line" || true
	@echo "make $(DEPLOY_target) tgt_version=x"
	@echo "\tDeploy the generated data to a server."
	@echo "\tCAUTION! The target directory on the server will be synchronized with your local directory, made by 'make $(DEPLOY_target),"
	@echo "\t         and any files in the target directory on the server, but not in the local directory will be deleted!"
	@echo "make $(TEST_target) tgt_version=x"
	@echo "\tRun post-deployment tests."

#ifndef base_uri
  #$(info "You must set the variable base_uri on the command line. e.g. 'make target base_uri=http:foo.org/bar'")
#endif

# The directories where files end up (locally, through GENERATE_target, and on a server, through DEPLOY_target)
# may not be the same as the corresponding parts of the URI. 
# The differences (and other things) are sorted out by content negotiation via a .htaccess file.
# Target directories:
VOCAB_SUBDIR := vocab-content
STANDARD_SUBDIR := standard-content
HTML_SUBDIR := html-content
TGT_SUBDIRS := $(VOCAB_SUBDIR) $(STANDARD_SUBDIR) $(HTML_SUBDIR)

# Various file will have $(SRC_BASE_URI) substituted with $(TGT_BASE_URI) when the GENERATE_target is made.
SRC_BASE_URI := http://purl.org/essglobal/

SRC_VOCAB_FILE := ../vocabs/vocab/essglobal-vocab.ttl
SRC_TYPE := turtle
SRC_VOCAB_FILE_EXT := $(suffix $(SRC_VOCAB_FILE))

SRC_STANDARD_DIR := ../vocabs/standard
SRC_STANDARD_FILES := activities.skos activities-modified.skos legal-form.skos organisational-structure.skos products-services.skos qualifiers.skos themes.skos type-of-labour.skos

SRC_HTML_DIR := ../vocabs/html
# The original HTML file from essglobal.org was 2015.01.11.html:
#SRC_HTML_FILE := 2015.01.11.html
# We are now doing ongoing development on the HTML file essglobal.html, which started as a copy of 2015.01.11.html:
SRC_HTML_FILE := essglobal.html
SRC_CSS_FILE := default.css
SRC_HTML_FILES := $(SRC_HTML_FILE) $(SRC_CSS_FILE)

TGT_SUBDIR := $(tgt_version)

# Here we define variables that depend on the tgt_version.
# Note that some of the variables defined above could be (re)defined here, if necessary.
TGT_VERSIONS := ise experimental 1.1 sea
ifeq ($(tgt_version),experimental)
  TGT_BASE_URI := http://purl.org/essglobal/experimental/
else ifeq ($(tgt_version),ise)
  TGT_BASE_URI := http://purl.org/solidarityeconomics/experimental/essglobal/
  # SERVER details are needed for deployment
  SERVER_SSH_CONFIG_NAME := parecco
  # www-vocabs is symboloc link on server:
  SERVER_DIR := www-vocabs/
  SERVER_SUB_DIR := experimental/essglobal
else ifeq ($(tgt_version),sea)
  TGT_BASE_URI := https://w3id.solidarityeconomy.coop/essglobal/V2a/
  # SERVER details are needed for deployment
  SERVER_SSH_CONFIG_NAME := sea-0
  # www-vocabs is symboloc link on server:
  SERVER_DIR := /var/www/html/vocabs/
  SERVER_SUB_DIR := essglobal/V2a
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

TEST_DIR := tmp_test_results
$(TEST_DIR):
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

# CSS files are just copies from source to target:
$(TGT_HTML_DIR)/%.css: $(SRC_HTML_DIR)/%.css | $(TGT_HTML_DIR)
	cp $< $@

# HTML files must have URIs substituted:
$(TGT_HTML_DIR)/%.html: $(SRC_HTML_DIR)/%.html | $(TGT_HTML_DIR)
	$(do_uri_subst)

# Add the list of HTML files to the generate target:
$(GENERATE_target): $(TGT_HTML_FILES)

TGT_HTACCESS := $(TGT_DIR)/.htaccess
GEN_HTACCESS := generate-htaccess.rb
RewriteBase := /$(SERVER_SUB_DIR)/
VocabUrlSuffix := vocab
StandardUrlSuffix := standard
StandardSubDir := $(STANDARD_SUBDIR)
VocabRdf := $(VOCAB_SUBDIR)/$(notdir $(TGT_RDFXML))
VocabTtl := $(VOCAB_SUBDIR)/$(notdir $(TGT_TURTLE))
HtmlFile := $(HTML_SUBDIR)/$(SRC_HTML_FILE)
$(TGT_HTACCESS): $(GEN_HTACCESS) Makefile
	ruby $< $(RewriteBase) $(VocabUrlSuffix) $(StandardUrlSuffix) $(VocabRdf) $(VocabTtl) $(StandardSubDir) $(HtmlFile) > $@

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

RSYNC := rsync -avz --rsync-path="sudo rsync" --owner --group
# Define macro for executing commands on the server (here using ssh):
SERVER_CMD = ssh $(SERVER_SSH_CONFIG_NAME) $(1)

# Careful! The --delete option will remove any files on the server that are not also in TGT_DIR
$(DEPLOY_target): $(GENERATE_target)
	$(call SERVER_CMD,'cd $(SERVER_DIR) && mkdir -p $(SERVER_SUB_DIR)')
	$(RSYNC) --delete $(TGT_DIR)/ $(SERVER_SSH_CONFIG_NAME):$(SERVER_DIR)$(SERVER_SUB_DIR)/
	@echo "If the server is set up properly, the vocab should be available at URIs"
	@echo "\t$(TGT_BASE_URI)$(VocabUrlSuffix)"
	@echo "\t$(TGT_BASE_URI)$(StandardUrlSuffix)"
	@echo "Consider running test using "
	@echo "\tmake tgt_version=$(tgt_version) $(TEST_target)"

###################
# TESTING
###################

# The pattern of these tests is as follows:
# 1. Use curl to fetch something that we have deployed.
# 2. Use diff to compare the response to the fetch with what we expect.

CURL = echo "Fetching $(1) from $(2)" && curl --silent -H "Accept: $(1)" -L $2 > $3
DO_DIFF_TEST = diff $(1) $(2) && echo "PASS - fetched response matches $(1)" || echo "FAIL! ************** \nFAIL! Expected $(1) and $(2) to be identical."

# Note the use of $$f - this is in order to end up with $f, used by the shell for variable substitution in for loops.
define do_test_skos
for f in $(SRC_STANDARD_FILES:.skos=); do  \
$(call CURL,application/rdf+xml,$(TGT_BASE_URI)$(StandardUrlSuffix)/$$f,$(TEST_DIR)/$$f.out) ; \
$(call DO_DIFF_TEST,$(TGT_STANDARD_DIR)/$$f.skos,$(TEST_DIR)/$$f.out) ;\
done
endef

TMP_RES_RDFXML_VOCAB := $(TEST_DIR)/vocab_rdfxml.out
TMP_RES_TURTLE_VOCAB := $(TEST_DIR)/vocab_turtle.out
define do_test_vocab
$(call CURL,application/rdf+xml,$(TGT_BASE_URI)$(VocabUrlSuffix)/,$(TMP_RES_RDFXML_VOCAB)) ; \
$(call DO_DIFF_TEST,$(TGT_RDFXML),$(TMP_RES_RDFXML_VOCAB)) ;
$(call CURL,text/turtle,$(TGT_BASE_URI)$(VocabUrlSuffix)/,$(TMP_RES_TURTLE_VOCAB)) ; \
$(call DO_DIFF_TEST,$(TGT_TURTLE),$(TMP_RES_TURTLE_VOCAB)) ;
endef

TMP_RES_TEXT_HTML := $(TEST_DIR)/texthtml.out
define do_test_html
$(call CURL,text/html,$(TGT_BASE_URI)$(VocabUrlSuffix)/,$(TMP_RES_TEXT_HTML)) ; \
$(call DO_DIFF_TEST,$(TGT_DIR)/$(HtmlFile),$(TMP_RES_TEXT_HTML)) ;
endef

$(TEST_target): | $(TEST_DIR)
	@echo "Test $(TGT_BASE_URI)"
	@$(do_test_skos)
	@$(do_test_vocab)
	@$(do_test_html)

