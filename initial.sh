#!/bin/bash

PYENV_STRING="\nexport PATH=\"$HOME/.pyenv/bin:\$PATH\"\n"
PYENV_STRING="${PYENV_STRING}eval \"\$(pyenv init -)\"\n"
PYENV_STRING="${PYENV_STRING}eval \"\$(pyenv virtualenv-init -)\""

source .env

install_pyenv () {
    sudo -k -S apt-get --yes install make build-essential gcc g++ llvm \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
liblzma-dev python-openssl git <<< $PASSWORD
    curl https://pyenv.run | bash
    echo -e $PYENV_STRING | tee -a $HOME/.bashrc
    export PATH=$HOME/.pyenv/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv install 2.7.16
    pyenv install 3.7.3
    pyenv global 3.7.3 2.7.16
}

install_poetry () {
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
    echo -e "\nexport PATH=\$HOME/.poetry/bin:\$PATH" | tee -a $HOME/.bashrc
    export PATH=$HOME/.poetry/bin:$PATH
    poetry config settings.virtualenvs.in-project true
}

install_setup () {
    git clone https://github.com/xspirus/env-setup.git
    cp .env env-setup/.env
    cd env-setup
    git branch arch/debian
    git pull origin arch/debian
    poetry install
    poetry run debian
}

sudo -k -S apt-get update <<< $PASSWORD
sudo -k -S apt-get --yes upgrade <<< $PASSWORD
install_pyenv
install_poetry
install_setup
