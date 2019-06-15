#!/bin/bash

PYENV_STRING="\nexport PYENV_ROOT=/usr/local/pyenv\n"
PYENV_STRING="${PYENV_STRING}export PATH=${PYENV_ROOT}/bin:$PATH\n"
PYENV_STRING="${PYENV_STRING}eval \"\$(pyenv init -)\"\n"
PYENV_STRING="${PYENV_STRING}eval \"\$(pyenv virtualenv-init -)\""

source .env

install_general () {
    apt-get --yes install git zsh fontconfig
    # change shell for all users of bash
    sed 's/\(.*\):\/bin\/bash/\1:\/bin\/zsh/' -i /etc/passwd
    # install nerd font
    wget -O /usr/local/share/fonts/dejavunerd.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf
    fc-cache
}

install_oh-my-zsh () {
    git clone https://github.com/xspirus/dotfiles.git
    git clone https://github.com/robbyrussell/oh-my-zsh.git
    ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    ln -sf dotfiles/.zshrc .zshrc
}

install_pyenv () {
    apt-get --yes install make build-essential gcc g++ llvm \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
liblzma-dev python-openssl git
    export PYENV_ROOT="/usr/local/pyenv"
    curl https://pyenv.run | bash
    export PATH=${PYENV_ROOT}/bin:$PATH
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
    source .venv/bin/activate
    debian
}

apt-get update
apt-get --yes upgrade
install_general
install_oh-my-zsh
install_pyenv
su - $USERNAME
install_oh-my-zsh
install_poetry
install_setup
