QUARTO   ?= quarto
QMD      := $(wildcard *.qmd)
PREAMBLE := preamble.tex

OUTDIR := FinalProducts
PDFS   := $(QMD:%.qmd=$(OUTDIR)/%.pdf)

# Extract the paths from every  {{< include ... >}}  line in a QMD file.
# Usage: $(call qmd_includes, foo.qmd)
qmd_includes = $(shell grep -oP '(?<=\{\{< include )[^ >]+' $(1) 2>/dev/null)

.PHONY: all clean

all: $(OUTDIR) $(PDFS)

# Ensure output directory exists
$(OUTDIR):
	@mkdir -p $(OUTDIR)

# Generate one explicit rule per top-level QMD.
# The target IS the output PDF, so a missing FinalProducts/ (or missing PDF)
# is enough to trigger a rebuild — no separate stamp files needed.
# Each rule depends only on the sections that specific document includes,
# so editing one section file only rebuilds the documents that use it.
# preamble.tex is a universal dependency and rebuilds everything when changed.
define PDF_RULE
$(OUTDIR)/$(patsubst %.qmd,%,$(1)).pdf: $(1) $(PREAMBLE) $(call qmd_includes,$(1)) | $(OUTDIR)
	@echo "==> Rendering $(1)"
	@$(QUARTO) render "$(1)"
	@mv "$(patsubst %.qmd,%,$(1)).pdf" "$(OUTDIR)/"
endef

$(foreach qmd,$(QMD),$(eval $(call PDF_RULE,$(qmd))))

clean:
	@rm -rf $(OUTDIR)
	@rm -rf .rendered
	@rm -f *.pdf *.html *.docx
