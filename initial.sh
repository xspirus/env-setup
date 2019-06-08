#!/bin/bash

source .env
sudo -k
echo "[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch" | { echo $PASSWORD; cat -; } | sudo -S tee -a /etc/pacman.conf
cat /etc/pacman.conf
sudo -S pacman -Sy <<< $PASSWORD
sudo -k
sudo -S pacman -S python python-pip git --noconfirm --needed <<< $PASSWORD
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
export PATH=$PATH:$EXTRA_PATHS
git clone https://github.com/xspirus/env-setup.git
cp .env env-setup/.env
cd env-setup
git branch arch/arch
git pull origin arch/arch
poetry install
poetry run setup
