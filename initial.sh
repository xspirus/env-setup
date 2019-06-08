#!/bin/bash

install_setup () {
    git clone https://github.com/xspirus/env-setup.git
    cp .env env-setup/.env
    cd env-setup
    git branch arch/debian
    git pull origin arch/debian
    poetry install
    poetry run setup
}

source .env
sudo -k apt-get update <<< $PASSWORD
sudo -k apt-get install python python-pip python3 python3-pip git -y <<< $PASSWORD
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
export PATH=$PATH:/home/$USER/.poetry/bin
install_setup
