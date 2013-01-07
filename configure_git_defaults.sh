#!/bin/sh
echo Configuring git defaults

read -p 'Enter Full Name: ' FullName
read -p 'Enter Email Address: ' Email

git config --global user.name "$FullName"
git config --global user.email "$Email"
git config --global core.autocrlf false
git config --global core.editor notepad
git config --global core.pager "less -q -x4"
git config --global color.ui auto
git config --global log.date relative
git config --global diff.renames copies
git config --global push.default upstream

git config --global alias.ca "commit --amend -C HEAD"

# Borrowed from: http://www.jukie.net/bart/blog/pimping-out-git-log
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

git config --global guitool."edit file".cmd 'notepad "$FILENAME"'
git config --global guitool."edit file".noconsole yes
git config --global guitool."delete file".cmd 'rm $FILENAME'
git config --global guitool."delete file".noconsole yes
git config --global guitool."delete file".confirm yes
git config --global guitool.difftool.cmd 'git difftool -- "$FILENAME"'
git config --global guitool.difftool.noconsole yes
git config --global guitool."difftool staged".cmd 'git difftool --staged -- "$FILENAME"'
git config --global guitool."difftool staged".noconsole yes

echo Using default credential store.
git config --global credential.helper store

if [ -e /c ]; then
  echo "Using DiffMerge for windows"
  git config --global diff.tool diffmerge
  git config --global difftool.prompt false

  Tool=$DOTFILES/winbin/gitextdiff.sh
  ToolDrive=${Tool:1:1}
  ToolPath=${Tool:2}
  DIFF=$(echo $ToolDrive:$ToolPath \"\$LOCAL\" \"\$REMOTE\")

  git config --global difftool.diffmerge.cmd "$DIFF"
fi
