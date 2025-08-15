#!/bin/bash

##################
# Ubuntu Generic #
##################

if [ ! -e /etc/os-release ]; then
    echo "Error: Only Ubuntu/Debian Linux supported"
    exit 1
fi

GROUP=$(id -gn)
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER && sudo chmod 0400 /etc/sudoers.d/$USER

sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
if [ $? -ne 0 ]; then
    echo "Error: Package repositories could be temporarily unavailable. Pleast try again later."
    exit 1
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git locate net-tools ssh tmux vim


##########
# Docker #
##########

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
