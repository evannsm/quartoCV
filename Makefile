QUARTO   ?= quarto
PREAMBLE := preamble.tex
DOCXREF  := resume-reference.docx
DOCXSCRIPT := scripts/postprocess_docx.py
OUTDIR   := FinalProducts

UID := $(shell id -u)
GID := $(shell id -g)

qmd_includes = $(shell grep -oP '(?<=\{\{< include )[^ >]+' $(1) 2>/dev/null)

CV_PDF     := $(OUTDIR)/QuartoCV.pdf
RESUME_PDF := $(OUTDIR)/QuartoResume.pdf
DOCX       := $(OUTDIR)/WordResume.docx

.PHONY: all clean docker-render

all: $(OUTDIR) $(CV_PDF) $(RESUME_PDF) $(DOCX)

docker-render:
	docker run --rm -v "$(PWD):/workspace" --user $(UID):$(GID) -e HOME=/tmp quartocv make

$(OUTDIR):
	@mkdir -p $@

$(CV_PDF): QuartoCV.qmd $(PREAMBLE) $(call qmd_includes,QuartoCV.qmd) | $(OUTDIR)
	@echo "==> Rendering QuartoCV.qmd"
	@$(QUARTO) render QuartoCV.qmd
	@mv QuartoCV.pdf $(CV_PDF)
	@echo "==> Output: $(CV_PDF)"

$(RESUME_PDF): QuartoResume.qmd $(PREAMBLE) $(call qmd_includes,QuartoResume.qmd) | $(OUTDIR)
	@echo "==> Rendering QuartoResume.qmd"
	@$(QUARTO) render QuartoResume.qmd
	@mv QuartoResume.pdf $(RESUME_PDF)
	@echo "==> Output: $(RESUME_PDF)"

$(DOCX): WordResume.qmd $(DOCXREF) $(DOCXSCRIPT) | $(OUTDIR)
	@echo "==> Rendering WordResume.qmd"
	@$(QUARTO) render WordResume.qmd
	@mv WordResume.docx $(DOCX)
	@python3 $(DOCXSCRIPT)
	@echo "==> Output: $(DOCX)"

clean:
	@rm -rf $(OUTDIR)
	@rm -f *.pdf *.html *.docx
