QUARTO ?= quarto
QMD := $(wildcard *.qmd)

STAMPDIR := .rendered
STAMPS := $(QMD:%.qmd=$(STAMPDIR)/%.stamp)
OUTDIR := FinalProducts

# All shared inputs — editing any of these triggers a rebuild of every document
SECTIONS := $(wildcard sections/*.qmd) $(wildcard sections/*/*.qmd) preamble.tex

.PHONY: all clean

all: $(OUTDIR) $(STAMPDIR) $(STAMPS)

# Ensure output directory exists
$(OUTDIR):
	@mkdir -p $(OUTDIR)

# Ensure hidden stamp directory exists
$(STAMPDIR):
	@mkdir -p $(STAMPDIR)

# One stamp per root qmd.
# Depends on the root qmd file AND all section/preamble files so that
# editing any included content triggers the right rebuild.
$(STAMPDIR)/%.stamp: %.qmd $(SECTIONS) | $(OUTDIR)
	@echo "==> Rendering $<"
	@$(QUARTO) render "$<"
	@mv "$*.pdf" "$(OUTDIR)/"
	@touch "$@"

clean:
	@rm -rf $(STAMPDIR)
	@rm -rf $(OUTDIR)
	@rm -f *.pdf *.html *.docx