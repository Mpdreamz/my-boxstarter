set TERM=xterm

alias a='git add -A'
alias c='git commit -m'
alias p='git push'
alias pp='git pull'
alias s='git status -s'

eval `ssh-agent -s` 
ssh-add
clear

source ~/.windows-bash-powerline.sh
