# QuartoCV
![Status](https://img.shields.io/badge/Status-Interview-Validated-blue)

A clean, professional CV/resume template built with [Quarto](https://quarto.org/) and LaTeX. Uses a modular file structure with separate `.qmd` files for each section, making it easy to add, remove, or reorder entries — and to produce multiple document styles from the same shared content.

![Quarto](https://img.shields.io/badge/Quarto-PDF-blue)
![LaTeX](https://img.shields.io/badge/Engine-XeLaTeX-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Two Styles Included

This repo ships with two distinct visual formats:

| Style | Preamble | Root document(s) | Best for |
|---|---|---|---|
| **Academic** | `preamble.tex` | `QuartoCV.qmd`, `QuartoResume.qmd` | Academic job market, fellowships, research roles |
| **Consulting** | `preamble_consulting.tex` | `ConsultingResume.qmd` | MBA recruiting, consulting, industry applications |

The **academic style** uses a compact two-column layout: bold section labels on the left (EDUCATION, WORK EXPERIENCE, …) and content on the right, with tight 8pt body text and narrow margins — optimized for fitting a lot on one page.

The **consulting style** uses a standard single-column layout: centered name/contact header, full-width bold section headings underlined by a rule, and entry headers that put bold organization + italic role on the left and a right-aligned date — the format used by MBA and consulting recruiting résumés.

Both styles render from the same `make` command and use the same modular `sections/` architecture.

## Preview

Run `make` on a fresh clone to produce example PDFs with fictional data (John Smith, Stanford PhD). The output is a polished PDF ready to use as a starting point.

## Prerequisites

| Requirement | Why |
|---|---|
| [Quarto](https://quarto.org/docs/get-started/) (v1.3+) | Document rendering engine |
| XeLaTeX (via [TeX Live](https://tug.org/texlive/) or [TinyTeX](https://yihui.org/tinytex/)) | PDF compilation with system font support |
| **Times New Roman** font installed on your system | Default body font (easily changeable) |
| `make` | Build system (standard on macOS/Linux) |

> **Tip:** Quarto can install TinyTeX for you: `quarto install tinytex`

## Quick Start

> **Don't have Quarto yet?** See the [Installing Quarto](#appendix-installing-quarto) appendix at the bottom of this document first.
>
> **Windows users:** `make` is not available by default on Windows. The appendix covers your options — WSL (recommended) or a native `make` install. The Quick Start commands above will not work in PowerShell or Command Prompt without one of those in place.

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/QuartoCV.git
cd QuartoCV

# Build all three example documents → FinalProducts/
make

# Build only the consulting resume
make FinalProducts/ConsultingResume.pdf

# Remove all build artifacts for a clean rebuild
make clean
```

`make` renders every root-level `.qmd` file and places the PDFs in `FinalProducts/`.

## How the Makefile Works

The Makefile tracks exactly which source files each document depends on, so `make` only rebuilds what is actually out of date.

```
make          # build all documents; skip anything already up to date
make clean    # delete FinalProducts/ (forces full rebuild on next make)
```

### Dependency tracking

The output PDFs in `FinalProducts/` are the Make targets. Make compares each PDF's timestamp against its prerequisites and rebuilds only if something is newer or missing.

At parse time, the Makefile greps every root `.qmd` for its `{{< include ... >}}` lines (sections) and its `include-in-header: file:` line (preamble). The result is a precise, per-document dependency graph:

| What you edit | What gets rebuilt |
|---|---|
| A root `.qmd` (e.g. `ConsultingResume.qmd`) | Only that document |
| A consulting section (e.g. `sections/consulting/work/...`) | Only `ConsultingResume.pdf` |
| A section shared by multiple documents | Only the documents that include it |
| `preamble.tex` | Only academic-style documents |
| `preamble_consulting.tex` | Only `ConsultingResume.pdf` |
| `FinalProducts/` deleted or a PDF removed | Only the missing PDFs |

You never have to remember which documents use which sections or preambles — Make figures it out automatically on every run.

### Adding new files — no Makefile edits required

**New root document:** just create a new `.qmd` in the project root.

```bash
cp ConsultingResume.qmd MyResume.qmd
# edit MyResume.qmd as needed
make   # picks it up automatically → FinalProducts/MyResume.pdf
```

The Makefile uses `$(wildcard *.qmd)`, so new root documents are discovered automatically.

**New section file:** create the `.qmd` anywhere inside `sections/`, then add an `{{< include sections/... >}}` line in whichever root documents should use it. The next `make` will include it in that document's dependency list and rebuild as needed.

### What would break the dependency tracking

The dependency scanner only understands Quarto's `{{< include path >}}` shortcode and the `include-in-header: file:` YAML field. The following would **not** be tracked automatically:

- **Quarto project-level includes** configured in `_quarto.yml`
- **Custom shortcodes or filters** that pull in external files
- **`\input{}` or `\include{}`** from raw LaTeX blocks inside a `.qmd`

Force a full rebuild at any time with `make clean && make`.

## Building Multiple Documents from the Same Sections

The most practical use of this template is maintaining several document variants — a full CV, an academic resume, a consulting resume — with **all content living in one place**.

This repository ships with three documents as working examples:

| File | Output | What it includes |
|---|---|---|
| `QuartoCV.qmd` | `FinalProducts/QuartoCV.pdf` | Every section — the full academic CV |
| `QuartoResume.qmd` | `FinalProducts/QuartoResume.pdf` | Focused academic resume (subset of sections) |
| `ConsultingResume.qmd` | `FinalProducts/ConsultingResume.pdf` | Consulting-format résumé (different style + sections) |

`QuartoResume.qmd` omits sections less relevant for industry (service, open-source, research interests) and trims publications and awards. Everything it includes is pulled from the same `sections/` files as `QuartoCV.qmd` — no duplication.

`ConsultingResume.qmd` uses `preamble_consulting.tex` and its own `sections/consulting/` files. The data is the same fictional person (John Smith), letting you compare both styles side by side before adapting to your own content.

### How to create your own consulting resume variant

1. Copy the consulting root document:
   ```bash
   cp ConsultingResume.qmd MyConsultingResume.qmd
   ```

2. Open `MyConsultingResume.qmd` and remove any `{{< include >}}` lines for sections you don't need.

3. Edit the section files under `sections/consulting/` to replace the placeholder content with your own. Each file is a small, self-contained LaTeX snippet.

4. Run `make`. The new PDF appears in `FinalProducts/`.

### How to create your own academic CV variant

1. Copy an existing root document:
   ```bash
   cp QuartoCV.qmd MyCV.qmd
   ```

2. Add or remove `{{< include >}}` lines for sections, or reorder them.

3. Run `make`.

No content is ever duplicated. Updating a bullet point in `sections/consulting/work/intern_microsoft.qmd` flows automatically into every document that includes it.

## Project Structure

```
QuartoCV/
├── Makefile                    # Build system — run `make` to produce all PDFs
│
├── QuartoCV.qmd                # Full academic CV (assembles all sections)
├── QuartoResume.qmd            # Focused academic resume (subset of sections)
├── ConsultingResume.qmd        # Consulting-style résumé (different layout)
│
├── preamble.tex                # Academic style: two-column layout, 8pt compact
├── preamble_consulting.tex     # Consulting style: single-column, standard margins
│
├── README.md
├── FinalProducts/              # All rendered PDFs appear here (git-ignored)
│
└── sections/
    │
    │   ── Academic-style sections ──────────────────────────────────────────
    ├── header.qmd                           # Name, title, institution banner
    ├── technical_skills.qmd                 # Categorized skills list
    ├── research_interests.qmd               # Two-column research interests
    ├── opensource.qmd                       # Open-source contributions
    ├── contact/
    │   └── default.qmd                      # Contact info
    ├── education/
    │   ├── stanford.qmd                     # PhD entry
    │   └── uc_berkeley.qmd                  # Undergrad entry
    ├── work/
    │   ├── grad_ra_reliable_ai.qmd          # Graduate Research Assistant
    │   ├── ta_machine_learning.qmd          # Teaching Assistant
    │   └── intern_microsoft.qmd             # Research Intern
    ├── publications/
    │   ├── calibrated_uncertainty_icml.qmd
    │   ├── efficient_finetuning_pami.qmd
    │   └── scaling_laws_neurips.qmd
    ├── service/
    │   ├── cs_council_president.qmd
    │   └── undergrad_mentor.qmd
    ├── awards/
    │   ├── best_paper_icml.qmd
    │   ├── knight_hennessy.qmd
    │   ├── summa_cum_laude.qmd
    │   └── cra_undergrad_researcher.qmd
    │
    └── consulting/              ── Consulting-style sections ────────────────
        ├── header.qmd                       # Centered name + contact block
        ├── skills.qmd                       # Skills and interests line items
        ├── education/
        │   ├── stanford.qmd                 # PhD entry (consulting format)
        │   └── uc_berkeley.qmd              # Undergrad entry (consulting format)
        ├── work/
        │   ├── grad_ra_reliable_ai.qmd      # Graduate RA (consulting format)
        │   └── intern_microsoft.qmd         # Intern (consulting format)
        ├── leadership/
        │   ├── cs_council_president.qmd     # Student org leadership
        │   └── undergrad_mentor.qmd         # Mentoring role
        └── awards/
            ├── best_paper_icml.qmd          # Best paper award
            └── knight_hennessy.qmd          # Fellowship
```

## Customization Guide

### Changing the Font

Both preambles use `\setmainfont`. Find the line and replace the font name:

```latex
\setmainfont{Times New Roman}   %% ← change to any system font
```

Popular alternatives: `EB Garamond`, `Libertinus Serif`, `Palatino`, `Georgia`.

### Adjusting Margins

Modify the `geometry` list in the root `.qmd`:

**Academic style** (very compact):
```yaml
geometry:
  - top=15mm
  - left=14mm
  - right=10mm
  - bottom=15mm
```

**Consulting style** (standard):
```yaml
geometry:
  - top=18mm
  - left=18mm
  - right=18mm
  - bottom=18mm
```

## Custom LaTeX Commands — Academic Style (`preamble.tex`)

### `\cvrow{LABEL}{CONTENT}`

The fundamental two-column row. Bold section label on the left, content on the right.

```latex
\cvrow{EDUCATION}{%
  \textbf{Stanford University} | 2022-2027\\
  Ph.D. in Computer Science
}
```

### `\cventry{TITLE}{ORG}{DATE}{INSTITUTION}{LOCATION}{BULLETS}`

Structured entry for work experience. Two-line header with right-aligned date/location, followed by bullets.

```latex
\cventry{Graduate Research Assistant}{AI Lab}{Aug 2022 - Present}
  {Stanford University}{Stanford, CA}{%
  \item Did interesting research
  \item Published papers
}
```

### `\cventryplain{TITLE}{DATE}{INSTITUTION}{LOCATION}{BULLETS}`

Same as `\cventry` but without the `| Org` separator.

### `\cvaward{TITLE}{DATE}{DESCRIPTION}`

Compact award entry: bold title, right-aligned date, description below.

### `\cvrule`

Full-width horizontal rule to visually separate sections.

## Custom LaTeX Commands — Consulting Style (`preamble_consulting.tex`)

### `\csection{TITLE}`

Full-width bold section heading with a horizontal rule below. Write the title in all caps.

```latex
\csection{PROFESSIONAL EXPERIENCE}
```

### `\centry{Org}{Role}{Location}{Date}`

Standard entry header: bold org, italic role, plain location, right-aligned date. Follow with an `itemize` list for bullets.

```latex
\centry{Microsoft Research}{Research Intern}{Redmond, WA}{May--Aug 2021}
\begin{itemize}
  \item Investigated few-shot learning techniques for code generation
\end{itemize}
```

### `\ceduentry{Org}{Program}{Location}{Date}`

Education entry. Org is bold, Program (degree name) is italic. Location and date appear together on the right.

```latex
\ceduentry{Stanford University}{Ph.D. in Computer Science}{Stanford, CA}{Aug 2022--Present}
\begin{itemize}
  \item GPA: 4.0/4.0 \quad Advisor: Dr. Alice Johnson
\end{itemize}
```

### `\cawardentry{Award}{Context}{Date}`

Award/honor entry: bold award name, italic context (awarding body or descriptor), right-aligned date.

```latex
\cawardentry{Best Paper Award}{ICML Reliable ML Workshop}{July 2024}
\begin{itemize}
  \item Recognized for novel contributions to uncertainty quantification
\end{itemize}
```

### Adding entries in the consulting style

To add a new entry to any section, create a `.qmd` file in `sections/consulting/<category>/` using the appropriate command, then add an `{{< include >}}` line in `ConsultingResume.qmd`:

```latex
{{< include sections/consulting/work/my_new_role.qmd >}}
```

## License

This project is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute.

---

## Appendix: Installing Quarto

> New to Quarto? Follow this guide before running the Quick Start commands. Once Quarto is installed, return to the [Quick Start](#quick-start) section above.

### macOS

**Option A — Homebrew (recommended)**
```bash
brew install --cask quarto
```
Homebrew handles PATH setup automatically.

**Option B — Direct installer**
Download the `.pkg` from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) and run it.

**After installing Quarto, install TinyTeX:**
```bash
quarto install tinytex
```

> **Caveat:** If you installed Quarto via `.pkg` and your shell can't find `quarto`, add `/usr/local/bin` (Intel Mac) or `/opt/homebrew/bin` (Apple Silicon) to your `PATH`. Restart your terminal after installation.

> **`make`:** Ships with macOS Xcode Command Line Tools. If `make` is missing: `xcode-select --install`

---

### Linux

**Debian / Ubuntu (.deb)**
```bash
# Check your architecture first: uname -m
# x86_64 → amd64    aarch64 → arm64
wget https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo dpkg -i quarto-linux-amd64.deb
```

**Fedora / RHEL / openSUSE (.rpm)**
```bash
wget https://quarto.org/download/latest/quarto-linux-amd64.rpm
sudo rpm -U quarto-linux-amd64.rpm
```

**After installing Quarto, install TinyTeX:**
```bash
quarto install tinytex
```

> **Caveat:** The `.deb`/`.rpm` links above point to the amd64 build. If you are on ARM (e.g., a Raspberry Pi or AWS Graviton), download the `-arm64` variant from the [Quarto releases page](https://github.com/quarto-dev/quarto-cli/releases/latest).

> **Caveat:** On some minimal server images, `libglib2.0` or `libcurl` may be missing. If Quarto fails to launch, install them with `sudo apt-get install -y libglib2.0-0 libcurl4`.

> **`make`:** Usually pre-installed. If missing: `sudo apt-get install build-essential` (Debian/Ubuntu) or `sudo dnf install make` (Fedora).

---

### Windows

**Option A — Installer (recommended)**
Download the `.msi` from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) and run it. The installer adds Quarto to your `PATH` automatically.

**Option B — Winget**
```powershell
winget install --id Posit.Quarto
```

**After installing Quarto, install TinyTeX (run in PowerShell or Command Prompt):**
```powershell
quarto install tinytex
```

> **Caveat — `make`:** Windows does not ship with `make`. You have two options:
>
> 1. **Use WSL (recommended):** Install [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install), then install Quarto and `make` inside WSL following the Linux instructions above. Run all build commands from the WSL terminal.
>
> 2. **Install `make` natively:** Install [Git for Windows](https://gitforwindows.org/) (includes Git Bash with `make`) or add `make` via [Chocolatey](https://chocolatey.org/) (`choco install make`) or [Scoop](https://scoop.sh/) (`scoop install make`). Then run `make` from Git Bash or a configured terminal.

> **Caveat — font:** Times New Roman is bundled with Windows, so no extra step is needed. If you switch to a different font, confirm it is installed via **Settings → Fonts**.

> **Caveat — line endings:** If you clone on Windows with `git config core.autocrlf true` (the Git for Windows default), LaTeX source files may get Windows line endings and cause obscure TeX errors. Add a `.gitattributes` file or set `git config core.autocrlf input` before cloning.

---

### Verifying your installation

After installing, confirm everything is in order:

```bash
quarto check
```

The output lists the Quarto version, the detected LaTeX installation, and any missing dependencies. All items should show a green checkmark before you run `make`.
