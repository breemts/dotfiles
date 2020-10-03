#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$(whoami)" != "root" ]; then
	echo "need to be root to run this"
	exit 1
fi
cp ${SCRIPT_DIR}/etc/wsl.conf /etc/wsl.conf

apt install $(cat "${SCRIPT_DIR}/apt.packages")
