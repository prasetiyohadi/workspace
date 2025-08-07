#!/usr/bin/env bash
set -euo pipefail

sudo apt install libx11-dev
sudo apt install libxext-dev
sudo apt install libxres-dev
pip install setuptools
git clone https://github.com/WhiteBlackGoose/ueberzug-latest /tmp/ueberzug-latest || true && cd /tmp/ueberzug-latest && pip install -e .
