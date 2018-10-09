#!/bin/bash
ln -s $(pwd)/vimrc ~/.vimrc

mkdir -p ~/.vim/files/backup
mkdir -p ~/.vim/files/swap
mkdir -p ~/.vim/files/undo
mkdir -p ~/.vim/files/info

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# For ubuntu
#sudo apt install vim-youcompleteme
#vim-addon-manager install youcompleteme
