#!/bin/bash

# TODO check directory the script is executed in.

# TODO check installed debian or Ubuntu version and add apt sources for newer version and fetch from there.
tmp_dir=$(mktemp -d -t deb-XXXXXXXXXX) \
&& curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*fd_.*amd64.deb").string' | wget -P $tmp_dir -qi - \
&& curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*bat_.*amd64.deb").string' | wget -P $tmp_dir -qi - \
&& dpkg -i $tmp_dir/*.deb \
&& rm -rf $tmp_dir

# Install fzf. maybe also get release?
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf \
&& $HOME/.fzf/install

# installs .bashrc_extra and modifies .bashrc
sed -i -e 's/HISTSIZE=.*/HISTSIZE=100000/' $HOME/.bashrc
sed -i -e 's/HISTFILESIZE=.*/HISTFILESIZE=200000/' $HOME/.bashrc
sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/' $HOME/.bashrc
echo "[ -f $HOME/.bashrc_extra ] && source $HOME/.bashrc_extra" >> ${HOME}/.bashrc
cp .bashrc_extra $HOME

# install .inputrc
cp .inputrc $HOME

# install git
cp git/.gitconfig $HOME

# install fzf
mkdir $HOME/.config/fzf
cp fzf/fzf.conf $HOME/.config/fzf/
