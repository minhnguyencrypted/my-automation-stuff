#!/bin/bash

# This script is used to configure a GNU/Linux system to be used as an Ansible
# managed node. It will create `ansible` user and authorise a specified SSH key for it.
# Usage: ./ansible-onboard.sh <ssh_pubkey_file>

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# Check if the script is run with a pubkey file
if [ $# -eq 0 ]; then
	echo "Error: No pubkey file specified" 
	exit 1
fi

# Create ansible user and create sudoers file for it
# Ansible user can run sudo without password
useradd -m -s /bin/bash ansible
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

# Create .ssh directory for ansible user
# Copy the specified pubkey file to authorized_keys
mkdir -p /home/ansible/.ssh
cp $1 /home/ansible/.ssh/authorized_keys

