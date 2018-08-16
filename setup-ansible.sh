#!/usr/bin/env bash

# Usage Example:
# ./setup-ansible.sh [version]
# Look up https://github.com/ansible/ansible for version tags to use

versionTag=$1

# Install pip
echo "[Install Ansible] Install pip"
apt update
apt install -y python-pip sshpass git
pip install -U pip

# Install Ansible
echo '[Install Ansible] Install Ansible'
pip install ansible

echo '[Install Ansible] Done!'

route del default
route add default gw 192.168.0.2 eth0
rm /etc/apt/sources.list.d/elasticsearch-2.x.list