QUARTO   ?= quarto
QMD      := $(wildcard *.qmd)

OUTDIR := FinalProducts
PDFS   := $(QMD:%.qmd=$(OUTDIR)/%.pdf)

# Extract the paths from every  {{< include ... >}}  line in a QMD file.
# Usage: $(call qmd_includes, foo.qmd)
qmd_includes = $(shell grep -oP '(?<=\{\{< include )[^ >]+' $(1) 2>/dev/null)

# Extract the preamble .tex file declared in a QMD's YAML front matter.
# Handles the  include-in-header: { file: preamble.tex }  form used here.
# Usage: $(call qmd_preamble, foo.qmd)
qmd_preamble = $(shell grep -oP '(?<=file: )\S+\.tex' $(1) 2>/dev/null)

.PHONY: all clean

all: $(OUTDIR) $(PDFS)

# Ensure output directory exists
$(OUTDIR):
	@mkdir -p $(OUTDIR)

# Generate one explicit rule per top-level QMD.
# Each PDF depends on:
#   • its root .qmd
#   • its own preamble .tex (detected from YAML — different documents may
#     use different preambles, e.g. preamble.tex vs preamble_consulting.tex)
#   • every section file it includes via {{< include >}}
# This means editing preamble_consulting.tex only rebuilds ConsultingResume.pdf,
# and editing sections/consulting/... only rebuilds documents that use them.
define PDF_RULE
$(OUTDIR)/$(patsubst %.qmd,%,$(1)).pdf: $(1) $(call qmd_preamble,$(1)) $(call qmd_includes,$(1)) | $(OUTDIR)
	@echo "==> Rendering $(1)"
	@$(QUARTO) render "$(1)"
	@mv "$(patsubst %.qmd,%,$(1)).pdf" "$(OUTDIR)/"
endef

$(foreach qmd,$(QMD),$(eval $(call PDF_RULE,$(qmd))))

clean:
	@rm -rf $(OUTDIR)
	@rm -rf .rendered
	@rm -f *.pdf *.html *.docx
