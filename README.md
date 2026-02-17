# QuartoCV

A clean, professional academic CV template built with [Quarto](https://quarto.org/) and LaTeX. Uses a modular file structure with separate `.qmd` files for each section, making it easy to add, remove, or reorder entries.

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

## Project Structure

```
QuartoCV/
├── cv.qmd                 # Main document — assembles sections via include directives
├── preamble.tex           # LaTeX preamble (fonts, spacing, custom commands)
├── README.md
└── sections/
    ├── header.qmd                          # Name, title, and institution banner
    ├── technical_skills.qmd                # Categorized skills list
    ├── research_interests.qmd              # Two-column research interests
    ├── opensource.qmd                       # Open-source contributions
    ├── contact/
    │   └── default.qmd                     # Contact info (email, GitHub, LinkedIn, etc.)
    ├── education/
    │   ├── stanford.qmd                    # PhD entry
    │   └── uc_berkeley.qmd                 # Undergrad entry
    ├── work/
    │   ├── grad_ra_reliable_ai.qmd         # Graduate Research Assistant
    │   ├── ta_machine_learning.qmd         # Teaching Assistant
    │   └── intern_microsoft.qmd            # Research Intern
    ├── publications/
    │   ├── calibrated_uncertainty_icml.qmd  # ICML paper
    │   ├── efficient_finetuning_pami.qmd   # PAMI submission
    │   └── scaling_laws_neurips.qmd        # NeurIPS paper
    ├── service/
    │   ├── cs_council_president.qmd        # Student org leadership
    │   └── undergrad_mentor.qmd            # Mentoring role
    └── awards/
        ├── best_paper_icml.qmd             # Best paper award
        ├── knight_hennessy.qmd             # Fellowship
        ├── summa_cum_laude.qmd             # Latin honors
        └── cra_undergrad_researcher.qmd    # Research award
```

Each section lives in its own `.qmd` file. The main `cv.qmd` pulls them together using Quarto's `{{< include >}}` directive. This makes it easy to:

- **Add an entry:** Create a new `.qmd` file in the appropriate subdirectory, then add an `{{< include >}}` line in `cv.qmd`.
- **Remove an entry:** Delete or comment out the `{{< include >}}` line.
- **Reorder sections:** Move the `{{< include >}}` lines around in `cv.qmd`.
- **Maintain multiple CV versions:** Create alternate main `.qmd` files (e.g., `resume.qmd`) that include different subsets of sections.

## Customization Guide

### Changing the Font

In `preamble.tex`, find the `\setmainfont` line and replace the font name:

```latex
\setmainfont{Times New Roman}   %% ← change to any system font
```

Popular alternatives: `EB Garamond`, `Libertinus Serif`, `Palatino`, `Georgia`.

### Adjusting Font Sizes

Two font sizes matter:

| Setting | Location | Default | Effect |
|---|---|---|---|
| `fontsize` | YAML front matter (`cv.qmd`) | `11pt` | Base size for LaTeX (affects heading scaling) |
| `\fontsize{8pt}{9.6pt}` | `preamble.tex` | 8pt / 9.6pt baseline | Actual body text size (overrides base) |
| Header name/title | `sections/header.qmd` `\fontsize{18.0pt}{...}` | 18pt | Name and title banner |

### Adjusting Margins

Modify the `geometry` list in `cv.qmd`:

```yaml
geometry:
  - top=15mm
  - left=14mm
  - right=10mm
  - bottom=15mm
```

### Adding / Removing Sections

Every section follows the same pattern in `cv.qmd`:

```
\cvrow{SECTION\\LABEL}{
  {{< include sections/category/entry.qmd >}}
}

\cvrule
```

Copy an existing section block, change the label, point to your new section file, and fill in your content. Delete any section you don't need.

### Adding Entries Within a Section

The **first** entry in a section uses `\cvrow{LABEL}{...}`. All **subsequent** entries use `\cvrow{}{...}` (empty left column) so the label appears only once. Add `\vspace{10pt}` between entries for spacing.

To add a new work experience entry, for example:

1. Create `sections/work/my_new_role.qmd` with a `\cventry{...}` block.
2. Add the following to `cv.qmd` after the last work entry:
   ```
   \vspace{10pt}

   \cvrow{}{%
   {{< include sections/work/my_new_role.qmd >}}
   }
   ```

## Custom LaTeX Commands

The template defines four commands in `preamble.tex`. You never need to write raw LaTeX layout code — just use these:

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

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute.
