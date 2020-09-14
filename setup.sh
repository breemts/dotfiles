#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check if user is root (ID 0) or user is sudoer (sudo -l -U $(id -un))
if  [ "$UID" -eq 0 ] || sudo -v; then
    if ! dpkg -l curl jq wget ; then
        echo "INFO: wget, jq or curl not installed. Installing..."
        sudo apt update && sudo apt install -yqq curl jq wget && sudo rm -rf /var/lib/apt/lists/*
    fi
    tmp_dir=$(mktemp -d -t deb-XXXXXXXXXX)
    curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*fd_.*amd64.deb").string' | wget -P $tmp_dir -qi -
    curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*bat_.*amd64.deb").string' | wget -P $tmp_dir -qi -
    # if [ "$UID" -eq 0 ];then
    #     dpkg -i $tmp_dir/*.deb
    # else
    sudo dpkg -i $tmp_dir/*.deb
    rm -rf $tmp_dir
else
    echo "ERROR: can't install fd and bat. Not root user rights" >&2
fi


# Install fzf. maybe also get release?
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf \
&& $HOME/.fzf/install --all

# installs .bashrc_extra and modifies .bashrc
sed -i -e 's/HISTSIZE=.*/HISTSIZE=100000/' $HOME/.bashrc
sed -i -e 's/HISTFILESIZE=.*/HISTFILESIZE=200000/' $HOME/.bashrc
sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/' $HOME/.bashrc
echo "[ -f $HOME/.bashrc_extra ] && source $HOME/.bashrc_extra" >> ${HOME}/.bashrc
cp -v ${SCRIPT_DIR}/.bashrc_extra $HOME

# install .inputrc
cp -v ${SCRIPT_DIR}/.inputrc $HOME

# install git
cp -v ${SCRIPT_DIR}/git/.gitconfig $HOME

# install fzf
mkdir -p $HOME/.config/fzf
cp -v ${SCRIPT_DIR}/fzf/fzf.conf $HOME/.config/fzf/
