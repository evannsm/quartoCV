QUARTO   ?= quarto
PREAMBLE := preamble_consulting.tex
QMD      := StandardResume.qmd
DOCXQMD  := WordResume.qmd
DOCXREF  := resume-reference.docx
OUTDIR   := FinalProducts

UID := $(shell id -u)
GID := $(shell id -g)

qmd_includes = $(shell grep -oP '(?<=\{\{< include )[^ >]+' $(1) 2>/dev/null)

SECTIONS := $(call qmd_includes,$(QMD))

PDF  := $(OUTDIR)/StandardResume.pdf
DOCX := $(OUTDIR)/WordResume.docx

.PHONY: all clean docker-render

all: $(OUTDIR) $(PDF) $(DOCX)

docker-render:
	docker run --rm -v "$(PWD):/workspace" --user $(UID):$(GID) -e HOME=/tmp quartocv make

$(OUTDIR):
	@mkdir -p $@

$(PDF): $(QMD) $(PREAMBLE) $(SECTIONS) | $(OUTDIR)
	@echo "==> Rendering $(QMD)"
	@$(QUARTO) render "$(QMD)"
	@mv "$(basename $(QMD)).pdf" "$(PDF)"
	@echo "==> Output: $(PDF)"

$(DOCX): $(DOCXQMD) $(DOCXREF) scripts/postprocess_docx.py | $(OUTDIR)
	@echo "==> Rendering $(DOCXQMD)"
	@$(QUARTO) render "$(DOCXQMD)"
	@mv "$(basename $(DOCXQMD)).docx" "$(DOCX)"
	@python3 scripts/postprocess_docx.py
	@echo "==> Output: $(DOCX)"

clean:
	@rm -rf $(OUTDIR)
	@rm -f *.pdf *.html *.docx
