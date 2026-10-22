#!/bin/bash

AUTOLOAD_DIR=$HOME/.vim/autoload

mkdir -p $AUTOLOAD_DIR
curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o $AUTOLOAD_DIR/plug.vim

cp .vimrc $HOME

