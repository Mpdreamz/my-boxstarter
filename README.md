This is my personal development boxstarter setup script. 


#[CLICK TO INSTALL](http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/Mpdreamz/my-boxstarter/master/boxstarter.txt)


# Manual steps post intall
- Install VMWare Tools
- `git config --global user.name "Martijn Laarman"`
- `git config --global user.email "mpdreamz+removeme gmail.com"`
- `git config --global push.default simple`
- `git config --global merge.tool tortoisemerge`
- `git config --global mergetool.tortoisemerge.cmd '"C:/Program Files/TortoiseGit/bin/TortoiseGitMerge.exe" -base:"$BASE" -theirs:"$REMOTE" -mine:"$LOCAL" -merged:"$MERGED"'`
- `git config --global mergetool.keepBackup false`
- `git config --global mergetool.prompt false`
- create SSH keys on the machine:
https://help.github.com/articles/generating-ssh-keys/#platform-windows
