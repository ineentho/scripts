#!/bin/bash

useradd -m henrik
echo "%wheel ALL(ALL) NOPASSWD: ALL" > /etc/sudoers
usermod -aG wheel henrik

pacman --noconfirm -S \
    base \
    base-devel \
    neovim \
    zsh \
    sudo \
    git \
    nodejs \
    ghc \
    cabal-install \
    tmux \
    cmake

cat << EOF | su henrik

# Download & install dotfiles
mkdir -p ~/dev
cd ~/dev
git clone https://github.com/ineentho/dotfiles.git
cd dotfiles
./bootstrap

# Install zsh & nvim plugin managers

git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs/

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c "PlugInstall"
yes | source ~/.zsh/antigen-hs/init.zsh

EOF