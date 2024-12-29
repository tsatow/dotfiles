#!/bin/bash
email=$(git config --global --get user.email)
if [ -z "$email" ]; then
    read -p "INPUT YOUR GITHUB EMAIL ADDRESS: " email
    git config --global user.email "$email"
fi

(cat $(pwd)/git/.gitconfig | sed "s/<FIXEMAIL>/$email/g") > ~/.gitconfig

if [ ! -e ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$email"
    # see https://cli.github.com/manual/gh_ssh-key_add
    gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(uname -n) $(uname -o) added at $(date '+%Y-%m-%d %H:%M:%S')"
    # 毎回の入力を避ける
    ssh-add -K
fi

echo "git setup completed !"
bat ~/.gitconfig
