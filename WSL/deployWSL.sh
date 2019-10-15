#!/bin/bash
if [ "$(whoami)" != "root" ]; then
	echo "need to be root to run this"
	exit 1
fi
cp etc/wsl.conf /etc/wsl.conf
