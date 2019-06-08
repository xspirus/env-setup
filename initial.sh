#!/bin/bash

install_trizen () {
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -d
    sudo -k -S pacman -U *.pkg.tar.gz --noconfirm --needed <<< $PASSWORD
    cd ..
    rm -rf trizen
}

source .env
printf "$PASSWORD\n[archlinuxfr]\nSigLevel = Never\nServer = http://repo.archlinux.fr/\$arch\n" | sudo -k -S tee -a /etc/pacman.conf
sudo -k -S pacman -Sy <<< $PASSWORD
sudo -k -S pacman -S python python-pip git --noconfirm --needed <<< $PASSWORD
install_trizen
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
export PATH=$PATH:$EXTRA_PATHS
git clone https://github.com/xspirus/env-setup.git
cp .env env-setup/.env
cd env-setup
git branch arch/arch
git pull origin arch/arch
poetry install
poetry run setup
