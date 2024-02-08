#!/bin/bash
export USERNAME="$USER"
export PATH="$PATH:/root/.local/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/env"
export PATH="$PATH:root/.cargo/env"
sudo apt update
sudo apt -y upgrade
# Install git
sudo apt install git -y
# Install the python3-pip package
sudo apt install python3-pip -y
# Install ansible
python3 -m pip install -r requirements.txt
python3 -m pip install --user ansible
ansible-playbook ./ansible.ubuntu.yml

