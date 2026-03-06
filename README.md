# quartoCV

A modular resume/CV system built with [Quarto](https://quarto.org/). Write your content once in small, reusable `.qmd` section files and compile to a polished PDF and Word document with a single command.

This repo ships with a fictional example resume (Jordan Steele-Watson) so you can see exactly what the output looks like before swapping in your own content.

---

## What this repo produces

| Command | Output |
| --- | --- |
| `make` | `FinalProducts/StandardResume.pdf` — single-column consulting-style PDF |
| `make` | `FinalProducts/WordResume.docx` — formatted Word document |

---

## How the content is organized

```
sections/
  header.qmd               # Name and contact line at the top
  education/               # One .qmd file per school
  academia/                # One .qmd file per job
  leadership/              # One .qmd file per role
StandardResume.qmd         # Assembles the PDF — just a list of {{< include >}} calls
WordResume.qmd             # Same content written in Markdown tables for Word output
preamble_consulting.tex    # LaTeX macros that define the visual style
```

To add, remove, or reorder entries, edit `StandardResume.qmd` and `WordResume.qmd`. To change the content of an entry, edit the corresponding file in `sections/`.

---

## Option 1 — Docker (recommended, works on Mac / Linux / Windows)

Docker runs the entire build inside a container so you do not need to install Quarto, LaTeX, or any fonts on your machine.

### Install Docker

- **Mac:** [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Windows:** [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) (requires WSL 2)
- **Linux:** [Docker Engine](https://docs.docker.com/engine/install/) for your distro

### Build the image (one time)

```bash
docker build -t quartocv .
```

This takes a few minutes the first time (it installs LaTeX, fonts, and Quarto). You only need to do it once.

### Build your resume

```bash
make docker-render
```

Outputs land in `FinalProducts/`.

> **Windows note:** `make` is not available by default on Windows. Run the command inside WSL 2, or install [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm) and run it in PowerShell.

---

## Option 2 — Native Quarto install (no Docker)

If you prefer to run Quarto directly on your machine:

### 1. Install Quarto

Download the installer for your OS from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/).

- **Mac:** `.pkg` installer or `brew install quarto`
- **Windows:** `.msi` installer
- **Linux:** `.deb` or `.rpm` package

### 2. Install a LaTeX engine

Quarto uses XeLaTeX to render PDFs. The easiest way is to install TinyTeX via Quarto:

```bash
quarto install tinytex
```

Or install a full TeX distribution:

- **Mac:** [MacTeX](https://www.tug.org/mactex/)
- **Windows:** [MiKTeX](https://miktex.org/download) or [TeX Live](https://www.tug.org/texlive/)
- **Linux:** `sudo apt install texlive-xetex texlive-fonts-recommended texlive-fonts-extra`

### 3. Install Times New Roman

The PDF uses Times New Roman. It is pre-installed on Mac and Windows. On Linux:

```bash
sudo apt install ttf-mscorefonts-installer
sudo fc-cache -f
```

### 4. Install Python

The Word post-processor is a small Python script that requires only the standard library. Any Python 3.8+ install works.

- **Mac:** `brew install python` or [python.org](https://www.python.org/downloads/)
- **Windows:** [python.org](https://www.python.org/downloads/)
- **Linux:** `sudo apt install python3`

### 5. Build

```bash
make
```

---

## Make commands

| Command | Description |
| --- | --- |
| `make` | Build both PDF and Word outputs |
| `make docker-render` | Build both outputs inside Docker |
| `make FinalProducts/StandardResume.pdf` | Build only the PDF |
| `make FinalProducts/WordResume.docx` | Build only the Word file |
| `make clean` | Delete all generated output files |

---

## Customizing the style

- **Margins, font size, page size:** top of `StandardResume.qmd` in the YAML front matter
- **Section heading style, entry spacing:** `preamble_consulting.tex`
- **Word document styles** (fonts, heading formats): `resume-reference.docx` — open it in Word, modify the named styles (Heading 1, Heading 2, etc.), and save
