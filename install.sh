#!/bin/sh

# THIS WILL OVERWRITE ALL YOUR DOTFILES
# USE AT YOUR OWN RISK

echo 'alias dots="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.zshrc
source ~/.zshrc

dots="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

echo ".dotfiles.git" >> .gitignore
git clone --bare git@github.com:jzlotek/dots.git $HOME/.dotfiles.git

# overwriting all dotfiles
$dots checkout -f
$dots config --local status.showUntrackedFiles no
