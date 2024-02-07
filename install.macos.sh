#!/bin/bash
set -e
# apple command line tools
xcode-select --install
sudo xcodebuild -license
/usr/sbin/softwareupdate --install-rosetta
sudo pip3 install --upgrade pip
# install homebrew "https://brew.sh"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install ansible "https://formulae.brew.sh/formula/ansible"
pip3 install ansible
pip3 install -r ./requirements.txt
export PATH="$PATH:~/.local/bin"
ansible-galaxy install -r ./ansible.requirements.yml

