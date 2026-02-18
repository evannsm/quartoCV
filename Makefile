QUARTO ?= quarto
QMD := $(wildcard *.qmd)

STAMPDIR := .rendered
STAMPS := $(QMD:%.qmd=$(STAMPDIR)/%.stamp)
OUTDIR := FinalProducts

.PHONY: all clean

all: $(OUTDIR) $(STAMPDIR) $(STAMPS)

# Ensure output directory exists
$(OUTDIR):
	@mkdir -p $(OUTDIR)

# Ensure hidden stamp directory exists
$(STAMPDIR):
	@mkdir -p $(STAMPDIR)

# One stamp per qmd, stored in .rendered/
$(STAMPDIR)/%.stamp: %.qmd | $(OUTDIR)
	@echo "==> Rendering $<"
	@$(QUARTO) render "$<"
	@mv "$*.pdf" "$(OUTDIR)/"
	@touch "$@"

clean:
	@rm -rf $(STAMPDIR)
	@rm -rf $(OUTDIR)
	@rm -f *.pdf *.html *.docx