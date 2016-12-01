export LANG=en_us_8859_1 | sudo tee -a ~/.bashrc
printf "\n127.0.0.1   $HOSTNAME\n" | sudo tee -a /etc/hosts
sudo apt-get install zsh
sudo apt-get install git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


cp /mnt/c/Projects/my-boxstarter/files/babun-powerline.zsh-theme ~/.oh-my-zsh/custom
cp /mnt/c/Projects/my-boxstarter/dotfiles/.zshrc ~/.zshrc
cp /mnt/c/Projects/my-boxstarter/dotfiles/.gitconfig ~/.gitconfig
cp /mnt/c/Projects/my-boxstarter/dotfiles/.vimrc ~/.vimrc
cp /mnt/c/Projects/my-boxstarter/dotfiles/tmux.conf ~/tmux.conf

zsh