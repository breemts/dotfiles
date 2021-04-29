#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

OS_TYPE="$(uname -m)"
case "$OS_TYPE" in
  x86_64|amd64)
    OS_TYPE='amd64'
    ;;
  i?86|x86)
    OS_TYPE='386'
    ;;
  aarch64|arm64)
    OS_TYPE='arm64'
    ;;
  arm*)
    OS_TYPE='arm'
    ;;
  *)
    echo 'OS type not supported'
    exit 2
    ;;
esac

function check_and_install() {
    if  [ "$UID" -eq 0 ] || sudo -v; then
        if ! dpkg -s $1 > /dev/null ; then
            echo "INFO: $1 not installed. Installing..."
            sudo apt-get update && sudo apt-get install -yqq $1 && sudo rm -rf /var/lib/apt/lists/*
        fi
    else
        echo "ERROR: can't install $1. Not root user rights" >&2
    fi
}

# check if user is root (ID 0) or user is sudoer (sudo -l -U $(id -un))
if  [ "$UID" -eq 0 ] || sudo -v; then
    check_and_install bsdmainutils
    check_and_install wget
    check_and_install jq
    check_and_install curl
    
    tmp_dir=$(mktemp -d -t deb-XXXXXXXXXX)
    case "$OS_TYPE" in
        'amd64')
            curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*fd_.*amd64.deb").string' | wget -P $tmp_dir -qi -
            curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*bat_.*amd64.deb").string' | wget -P $tmp_dir -qi -
            ;;
        'arm')
            curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*fd_.*armhf.deb").string' | wget -P $tmp_dir -qi -
            curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq --raw-output '.assets[].browser_download_url | match(".*bat_.*armhf.deb").string' | wget -P $tmp_dir -qi -
            ;;
        *)
            echo "OS Type ${OS_TYPE} not supported yet."
    esac
    sudo dpkg -i $tmp_dir/*.deb
    rm -rf $tmp_dir
else
    echo "ERROR: can't install fd and bat. Not root user rights" >&2
fi


# Install fzf. maybe also get release?
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf \
&& $HOME/.fzf/install --all

# installs .bashrc_extra and modifies .bashrc
echo "##### Modify .bashrc history and color settings #####"
sed -i -e 's/HISTSIZE=.*/HISTSIZE=100000/' $HOME/.bashrc
sed -i -e 's/HISTFILESIZE=.*/HISTFILESIZE=200000/' $HOME/.bashrc
sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/' $HOME/.bashrc
echo "[ -f $HOME/.bashrc_extra ] && source $HOME/.bashrc_extra" >> ${HOME}/.bashrc

echo "##### Copy some dot files ######"
cp -v ${SCRIPT_DIR}/.bashrc_extra $HOME
cp -v ${SCRIPT_DIR}/.bash_aliases $HOME

# install .inputrc
cp -v ${SCRIPT_DIR}/.inputrc $HOME

# install git
cp -v ${SCRIPT_DIR}/git/.gitconfig $HOME

# install fzf
mkdir -p $HOME/.config/fzf
cp -v ${SCRIPT_DIR}/fzf/fzf.conf $HOME/.config/fzf/
