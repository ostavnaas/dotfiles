#!/usr/bin/env bash

set -eux


sudo apt-get install keepassx vim git tmux zsh curl



# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Vundle
# https://github.com/VundleVim/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mkdir ~/github/ostavnaas
git clone git@github.com:ostavnaas/dotfiles.git
ln -fs ~/github/ostavnaas/dotfiles/.zshrc ~/.zshrc
ln -fs ~/github/ostavnaas/dotfiles/.vimrc ~/.vimrc
ln -fs ~/github/ostavnaas/dotfiles/.tmux.conf ~/.tmux.conf


# Gnome terminal
dconf load /org/gnome/terminal/legacy/profiles:/ < $(dirname "$0")/files/gnome-terminal
