#!/bin/bash

echo 'alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.zshrc
source ~/.zshrc

alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

echo ".dotfiles.git" >> .gitignore
git clone --bare git@github.com:jzlotek/dots.git $HOME/.dotfiles.git
dots checkout
dots config --local status.showUntrackedFiles no
