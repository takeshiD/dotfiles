#!/bin/sh
DEIN_DIR=$(cd $(dirname $0); pwd)

RET=$(ln -svf $DEIN_DIR/.vimrc $HOME/.vimrc)
echo "[Created SymLink]" $RET

RET=$(ln -svfn $DEIN_DIR $HOME/.vim)
echo "[Created SymLink]" $RET

mkdir -p $HOME/.vim/.undo
echo "[Created Directory]" $HOME/.vim/.undo
