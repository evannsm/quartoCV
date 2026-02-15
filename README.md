# QuartoCV

A clean, professional academic CV template built with [Quarto](https://quarto.org/) and LaTeX. Renders to a dense, single-file PDF with a two-column layout, custom commands for consistent formatting, and thorough inline comments explaining every design decision.

![Quarto](https://img.shields.io/badge/Quarto-PDF-blue)
![LaTeX](https://img.shields.io/badge/Engine-XeLaTeX-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Preview

Render the template to see a complete example CV with fictional data. The output is a polished, single-page (or multi-page) PDF ready for academic job applications, fellowship submissions, or conference bios.

## Prerequisites

| Requirement | Why |
|---|---|
| [Quarto](https://quarto.org/docs/get-started/) (v1.3+) | Document rendering engine |
| XeLaTeX (via [TeX Live](https://tug.org/texlive/) or [TinyTeX](https://yihui.org/tinytex/)) | PDF compilation with system font support |
| **Times New Roman** font installed on your system | Default body font (easily changeable) |

> **Tip:** Quarto can install TinyTeX for you: `quarto install tinytex`

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/QuartoCV.git
cd QuartoCV

# Render the CV to PDF
quarto render cv.qmd

# The output PDF will appear in the same directory
```

## Customization Guide

### Changing the Font

In the YAML header, find the `\setmainfont` line inside `include-in-header` and replace the font name:

```latex
\setmainfont{Times New Roman}   %% ← change to any system font
```

Popular alternatives: `EB Garamond`, `Libertinus Serif`, `Palatino`, `Georgia`.

### Adjusting Font Sizes

Two font sizes matter:

| Setting | Location | Default | Effect |
|---|---|---|---|
| `fontsize` | YAML front matter | `11pt` | Base size for LaTeX (affects heading scaling) |
| `\fontsize{8pt}{9.6pt}` | Preamble | 8pt / 9.6pt baseline | Actual body text size (overrides base) |
| Header name/title | Body `\fontsize{18.0pt}{...}` | 18pt | Name and title banner |

### Adjusting Margins

Modify the `geometry` list in the YAML header:

```yaml
geometry:
  - top=15mm
  - left=14mm
  - right=10mm
  - bottom=15mm
```

### Adding / Removing Sections

Every section follows the same pattern:

```
\cvrow{SECTION\\LABEL}{
  ... content ...
}

\cvrule
```

Copy an existing section block, change the label, and fill in your content. Delete any section you don't need.

### Adding Entries Within a Section

The **first** entry in a section uses `\cvrow{LABEL}{...}`. All **subsequent** entries use `\cvrow{}{...}` (empty left column) so the label appears only once. Add `\vspace{10pt}` between entries for spacing.

## Custom LaTeX Commands

The template defines four commands in the preamble. You never need to write raw LaTeX layout code — just use these:

### `\cvrow{LABEL}{CONTENT}`

The fundamental two-column row. Places a bold, centered label in the left column and arbitrary content in the right column.

```latex
\cvrow{EDUCATION}{%
  \textbf{Stanford University} | 2022-2027\\
  Ph.D. in Computer Science
}
```

### `\cventry{TITLE}{ORG}{DATE}{INSTITUTION}{LOCATION}{BULLETS}`

A structured entry for work experience, teaching, etc. Produces a two-line header (title|org + institution) with right-aligned date/location, followed by bullet points.

```latex
\cventry{Graduate Research Assistant}{AI Lab}{Aug 2022 - Present}
  {Stanford University}{Stanford, CA}{%
  \item Did interesting research
  \item Published papers
}
```

### `\cventryplain{TITLE}{DATE}{INSTITUTION}{LOCATION}{BULLETS}`

Same as `\cventry` but **without** the `| Org` separator. Use when the title already includes the organization name.

```latex
\cventryplain{President of CS Graduate Council}{Aug 2023 - Present}
  {Stanford University}{Stanford, CA}{%
  \item Led student advocacy efforts
}
```

### `\cvaward{TITLE}{DATE}{DESCRIPTION}`

A compact entry for honors and awards. Bold title with right-aligned date, followed by a description line.

```latex
\cvaward{Best Paper Award}{July 2024}
  {Recognized for novel contributions to the field}
```

### `\cvrule`

A full-width horizontal rule to visually separate sections. Just write `\cvrule` between sections.

## Project Structure

```
QuartoCV/
├── cv.qmd          # The entire CV (YAML config + LaTeX preamble + body content)
└── README.md       # This file
```

Everything lives in a single `.qmd` file — no external `.cls`, `.sty`, or `.tex` files to manage.

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute.
