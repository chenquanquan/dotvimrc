#!/bin/bash
ln -s $(pwd)/.vimrc ~/.vimrc

mkdir -p ~/.vim/files/backup
mkdir -p ~/.vim/files/swap
mkdir -p ~/.vim/files/undo
mkdir -p ~/.vim/files/info
mkdir -p ~/.vim/bundle/

cd ~/.vim/bundle; git clone https://github.com/VundleVim/Vundle.vim.git
