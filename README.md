# quartoCV

[![Job Market](https://img.shields.io/badge/Job-Market%20Validated-brightgreen)]()
[![Built with Quarto](https://img.shields.io/badge/Built%20with-Quarto-blue)](https://quarto.org)
![Output](https://img.shields.io/badge/Output-PDF_%26_Word-blue)
![Docker Ready](https://img.shields.io/badge/Docker-Ready-blue)
[![LaTeX Quality](https://img.shields.io/badge/Typesetting-LaTeX%20Quality-orange)]()
[![evannsmc.com](https://img.shields.io/badge/evannsmc.com-Portfolio-blue)](https://www.evannsmc.com)

A modular resume and CV system built with [Quarto](https://quarto.org/). Write your content once in small, focused section files and compile to a polished PDF and Word document with a single command. Reordering, adding, or removing entries is as simple as editing a list.

This repo ships with a fictional example resume so you can see exactly what the output looks like before swapping in your own content.

---

## What this produces

| File | Description |
| --- | --- |
| `FinalProducts/StandardResume.pdf` | Single-column, consulting-style PDF |
| `FinalProducts/WordResume.docx` | Formatted Word document |

---

## Quick start

**Already have Quarto and LaTeX?**
```bash
make
```

**Want to use Docker instead (no installs needed)?**
```bash
docker build -t quartocv .
make docker-render
```

Need to set up first? Jump to:
- [Set up with Docker](#set-up-with-docker-recommended) — Mac, Linux, or Windows
- [Install Quarto on Mac](#install-quarto-on-mac)
- [Install Quarto on Linux](#install-quarto-on-linux)
- [Install Quarto on Windows](#install-quarto-on-windows)

---

## How content is organized

```
sections/
  header.qmd          # Name and contact line
  education/          # One .qmd file per school
  work/               # One .qmd file per job
  leadership/         # One .qmd file per role
StandardResume.qmd    # PDF layout — assembles sections with {{< include >}}
WordResume.qmd        # Word layout — same content as Markdown tables
preamble_consulting.tex   # LaTeX macros that control the visual style
```

To reorder entries, edit the `{{< include >}}` list in `StandardResume.qmd` and `WordResume.qmd`. To edit an entry's content, open the corresponding file in `sections/`.

---

## Make commands

| Command | What it does |
| --- | --- |
| `make` | Build both PDF and Word outputs |
| `make docker-render` | Build both outputs inside Docker |
| `make FinalProducts/StandardResume.pdf` | Build only the PDF |
| `make FinalProducts/WordResume.docx` | Build only the Word file |
| `make clean` | Delete all generated outputs |

---

## Customizing the style

- **Margins, font size, page size** — YAML front matter at the top of `StandardResume.qmd`
- **Section heading and entry spacing** — `preamble_consulting.tex`
- **Word document fonts and heading styles** — open `resume-reference.docx` in Word, modify the named styles (Heading 1, Heading 2, etc.), and save

---

## Set up with Docker (recommended)

Docker handles everything — Quarto, LaTeX, and fonts — inside a container. Nothing gets installed on your machine.

### Install Docker

- **Mac:** [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Windows:** [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) — requires WSL 2 (Docker Desktop will prompt you to enable it)
- **Linux:** [Docker Engine](https://docs.docker.com/engine/install/) for your distro

### Build the image (one time only)

```bash
docker build -t quartocv .
```

This takes a few minutes the first time. You won't need to do it again unless the Dockerfile changes.

### Build your resume

```bash
make docker-render
```

> **Windows:** `make` is not available by default. Either run this inside WSL 2 (recommended), or install [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm) and run it from PowerShell.

---

## Install Quarto on Mac

### 1. Install Quarto

```bash
brew install quarto
```

Or download the `.pkg` installer from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/).

### 2. Install a LaTeX engine

```bash
quarto install tinytex
```

Or install the full [MacTeX](https://www.tug.org/mactex/) distribution if you prefer.

### 3. Install Python

```bash
brew install python
```

Or download from [python.org](https://www.python.org/downloads/). Python 3.8+ is required.

### 4. Build

```bash
make
```

---

## Install Quarto on Linux

### 1. Install Quarto

Download the `.deb` or `.rpm` package for your distro from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/), then install it:

```bash
# Debian/Ubuntu
sudo dpkg -i quarto-*.deb

# Fedora/RHEL
sudo rpm -i quarto-*.rpm
```

### 2. Install LaTeX and fonts

```bash
sudo apt install texlive-xetex texlive-fonts-recommended texlive-fonts-extra

# Times New Roman
sudo apt install ttf-mscorefonts-installer
sudo fc-cache -f
```

### 3. Install Python

```bash
sudo apt install python3
```

### 4. Build

```bash
make
```

---

## Install Quarto on Windows

### 1. Install Quarto

Download the `.msi` installer from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/) and run it.

### 2. Install a LaTeX engine

Open a terminal and run:

```bash
quarto install tinytex
```

Or install [MiKTeX](https://miktex.org/download), which handles package downloads automatically on first use.

### 3. Install Python

Download and install Python 3.8+ from [python.org](https://www.python.org/downloads/). Check "Add Python to PATH" during installation.

### 4. Install Make

`make` is not included with Windows. The easiest option is to use WSL 2 (Windows Subsystem for Linux) and follow the Linux instructions above. Alternatively, install [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm) and run commands from PowerShell.

### 5. Build

```bash
make
```
