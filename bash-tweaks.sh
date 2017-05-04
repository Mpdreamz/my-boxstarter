#!/usr/bin/env bash

cp /mnt/c/Projects/my-boxstarter/files/babun-powerline.zsh-theme ~/.oh-my-zsh/custom
cp /mnt/c/Projects/my-boxstarter/dotfiles/.zshrc ~/.zshrc
cp /mnt/c/Projects/my-boxstarter/dotfiles/.gitconfig ~/.gitconfig
cp /mnt/c/Projects/my-boxstarter/dotfiles/.vimrc ~/.vimrc
cp /mnt/c/Projects/my-boxstarter/dotfiles/.tmux.conf ~/.tmux.conf

#install pathogen for vim and tpm for tmux
mkdir -p ~/.vim/autoload ~/.vim/bundle && \ curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
git clone git://github.com/tpope/vim-fugitive.git  ~/.vim/bundle/vim-fugitive
git clone https://github.com/kien/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
git clone https://github.com/vim-ctrlspace/vim-ctrlspace.git ~/.vim/bundle/vim-ctrlspace.git

#make sure we have an up to date tmux (windows ships with 1.8)
sudo apt-get -y update 
sudo apt-get install -y python-software-properties software-properties-common 
sudo add-apt-repository -y ppa:pi-rho/dev 
sudo apt-get update 
sudo apt-get install -y tmux=2.0-1~ppa1~t

# install node 6 (LTS at the time of writing)
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs

# node based tools 
sudo npm install -g diff-so-fancy
sudo npm install -g azure
sudo npm install -g azure-cli
sudo npm install -g eclint

# ssh-keygen
ssh-keygen -t rsa -b 4096 -C "mpdreamz@gmail.com"

zsh
