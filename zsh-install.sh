#!/usr/bin/env bash

export LANG=en_US.UTF-8 | sudo tee -a ~/.bashrc
printf "\n127.0.0.1   $HOSTNAME\n" | sudo tee -a /etc/hosts
sudo apt-get install zsh
sudo apt-get install git
sudo apt-get install curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

