#!/bin/bash

AUTOLOAD_DIR=$HOME/.vim/autoload

mkdir -p $AUTOLOAD_DIR
if [ ! -e "$AUTOLOAD_DIR/plug.vim" ]; then
    curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o $AUTOLOAD_DIR/plug.vim
fi

cp .vimrc $HOME

