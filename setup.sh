#!/bin/bash

# installs .bashrc_extra and modifies .bashrc
sed -i -e 's/HISTSIZE=.*/HISTSIZE=100000/' $HOME/.bashrc
sed -i -e 's/HISTFILESIZE=.*/HISTFILESIZE=200000/' $HOME/.bashrc
sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/' $HOME/.bashrc
echo "[ -f $HOME/.bashrc_extra ] && source $HOME/.bashrc_extra" >> ${HOME}/.bashrc

# install git
cp git/.gitconfig $HOME

# install fzf
mkdir $HOME/.config/fzf
cp fzf/fzf.conf $HOME/.config/fzf/
