FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# System deps + Python
RUN apt-get update && apt-get install -y \
    curl wget make python3 python3-pip fontconfig \
    && rm -rf /var/lib/apt/lists/*

# Times New Roman and other MS core fonts
RUN apt-get update \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
       | debconf-set-selections \
    && apt-get install -y ttf-mscorefonts-installer \
    && fc-cache -f \
    && rm -rf /var/lib/apt/lists/*

# XeLaTeX + required packages
RUN apt-get update && apt-get install -y \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    && rm -rf /var/lib/apt/lists/*

# Quarto (latest stable)
RUN QUARTO_VERSION=$(curl -s https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest \
      | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/') \
    && curl -fsSL \
       "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" \
       -o /tmp/quarto.deb \
    && dpkg -i /tmp/quarto.deb \
    && rm /tmp/quarto.deb

WORKDIR /workspace
