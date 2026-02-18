# QuartoCV

A clean, professional academic CV template built with [Quarto](https://quarto.org/) and LaTeX. Uses a modular file structure with separate `.qmd` files for each section, making it easy to add, remove, or reorder entries — and to produce both a full CV and a focused resume from the same shared content.

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
| `make` | Build system (standard on macOS/Linux) |

> **Tip:** Quarto can install TinyTeX for you: `quarto install tinytex`

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/QuartoCV.git
cd QuartoCV

# Build everything (CV + Resume → FinalProducts/)
make

# Remove all build artifacts for a clean rebuild
make clean
```

That's it. `make` renders every root-level `.qmd` file and places the PDFs in `FinalProducts/`.

## How the Makefile Works

The Makefile uses **stamp files** to track what has already been rendered, so re-running `make` only rebuilds documents that are actually out of date.

```
make          # build all documents; skip anything already up to date
make clean    # delete FinalProducts/ and all stamps (forces full rebuild on next make)
```

### Dependency tracking

Each document stamp depends on:

1. Its own root `.qmd` file (e.g. `QuartoCV.qmd`)
2. **Every file in `sections/`** and `preamble.tex`

This means editing *any* section file — a single bullet point in a work entry, a new publication — will cause every document that could include it to be re-rendered on the next `make`. You never have to remember which documents use which sections.

### Adding a new document

Just create a new root-level `.qmd` file:

```bash
cp QuartoCV.qmd ResearchStatement.qmd
# edit ResearchStatement.qmd as needed
make   # picks it up automatically, renders to FinalProducts/ResearchStatement.pdf
```

The Makefile uses `$(wildcard *.qmd)` so new files are discovered without any Makefile edits.

## Building a CV and Resume from the Same Sections

The most practical use of this template is maintaining both a full academic CV and a shorter industry resume, with **all content living in one place**.

This repository ships with two documents as a working example:

| File | Output | What it includes |
|---|---|---|
| `QuartoCV.qmd` | `FinalProducts/QuartoCV.pdf` | Every section — the full academic CV |
| `Resume.qmd` | `FinalProducts/Resume.pdf` | A focused subset for industry applications |

`Resume.qmd` omits sections that are less relevant for industry (service, open-source, research interests) and trims the publications and awards lists to the two strongest entries. Everything it does include is pulled from the exact same `sections/` files as the CV — no duplication.

Running `make` produces both PDFs in one command. When you update a section — say, you add a bullet to a work entry — both documents are rebuilt automatically on the next `make`.

### How to create your own resume variant

1. Copy one of the existing root documents as a starting point:
   ```bash
   cp QuartoCV.qmd Resume.qmd
   ```

2. Open `Resume.qmd` and delete the `{{< include >}}` lines for sections you want to omit (service, research interests, older awards, etc.).

3. Trim entries within a section by simply removing individual `{{< include >}}` lines — the remaining entries in `sections/` are untouched and still appear in `QuartoCV.qmd`.

4. Run `make`. Both PDFs appear in `FinalProducts/`.

No content is ever duplicated. Updating a bullet point in `sections/work/intern_microsoft.qmd` flows into every document that includes it.

## Project Structure

```
QuartoCV/
├── Makefile               # Build system — run `make` to produce all PDFs
├── QuartoCV.qmd           # Full academic CV (assembles all sections)
├── Resume.qmd             # Focused resume (subset of sections)
├── preamble.tex           # LaTeX preamble (fonts, spacing, custom commands)
├── README.md
├── FinalProducts/         # All rendered PDFs appear here (git-ignored)
└── sections/
    ├── header.qmd                          # Name, title, and institution banner
    ├── technical_skills.qmd                # Categorized skills list
    ├── research_interests.qmd              # Two-column research interests
    ├── opensource.qmd                      # Open-source contributions
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

Each section lives in its own `.qmd` file. Root documents pull them together using Quarto's `{{< include >}}` directive. This makes it easy to:

- **Add an entry:** Create a new `.qmd` file in the appropriate subdirectory, then add an `{{< include >}}` line in whichever root documents should show it.
- **Remove an entry:** Delete or comment out the `{{< include >}}` line.
- **Reorder sections:** Move the `{{< include >}}` lines around in the root document.
- **Produce a resume:** Create a new root `.qmd` that includes only the sections you want.

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
| `fontsize` | YAML front matter (`QuartoCV.qmd`) | `11pt` | Base size for LaTeX (affects heading scaling) |
| `\fontsize{8pt}{9.6pt}` | `preamble.tex` | 8pt / 9.6pt baseline | Actual body text size (overrides base) |
| Header name/title | `sections/header.qmd` `\fontsize{18.0pt}{...}` | 18pt | Name and title banner |

### Adjusting Margins

Modify the `geometry` list in the root `.qmd`:

```yaml
geometry:
  - top=15mm
  - left=14mm
  - right=10mm
  - bottom=15mm
```

### Adding / Removing Sections

Every section follows the same pattern in the root `.qmd`:

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
2. Add the following to the root `.qmd` after the last work entry:
   ```
   \vspace{10pt}

   \cvrow{}{%
   {{< include sections/work/my_new_role.qmd >}}
   }
   ```
3. Run `make` — the new entry appears in every document that includes the work section.

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
