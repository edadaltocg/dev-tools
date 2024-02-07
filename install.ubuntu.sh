#!/bin/bash
apt update
apt -y upgrade
# Install git
apt install git -y
# Install the python3-pip package
apt install python3-pip -y
# Install ansible
python3 -m pip install --user ansible
export PATH=$PATH:/root/.local/bin

