#!/bin/bash

source .env
sudo -S pacman -Sy <<< $PASSWORD
sudo -S pacman -S python python-pip git --noconfirm --needed <<< $PASSWORD
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
export PATH=$PATH:$EXTRA_PATHS
git clone https://github.com/xspirus/env-setup.git
cd env-setup
git branch arch/arch
git pull origin arch/arch
poetry install
poetry run setup
