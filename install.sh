#!/bin/sh
DEIN_DIR=$(cd $(dirname $0); pwd)

RET=$(ln -svb $DEIN_DIR/.vimrc $HOME/.vimrc)
echo "[Created SymLink]" $RET

RET=$(ln -svb $DEIN_DIR $HOME/.vim)
echo "[Created SymLink]" $RET

RET=$(ln -svb $DEIN_DIR/.bashrc $HOME/.bashrc)
echo "[Created SymLink]" $RET

RET=$(ln -svb $DEIN_DIR/.inputrc $HOME/.inputrc)
echo "[Created SymLink]" $RET

mkdir -p $HOME/.vim/.undo
echo "[Created Directory]" $HOME/.vim/.undo

mkdir -p $HOME/.config/powerline-shell
echo "[Created Directory]" $HOME/.config/powerline-shell

RET=$(ln -svb $DEIN_DIR/config/powerline-shell/config $HOME/.config/powerline-shell)
echo "[Created SymLink]" $RET
