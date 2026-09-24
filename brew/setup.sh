#!/bin/bash
set -e

# make はレシピの各行を新しい非ログインシェルで実行するため、install.sh 直後でも
# brew にパスが通っていない (~/.zprofile も読まれない)。ここで shellenv を当てる
if ! type brew > /dev/null 2>&1; then
    for prefix in /opt/homebrew /usr/local; do
        if [ -x "$prefix/bin/brew" ]; then
            eval "$("$prefix/bin/brew" shellenv)"
            break
        fi
    done
fi

brew bundle --file "brew/Brewfile"

ln -sf /opt/homebrew/opt/emacs-mac/Emacs.app /Applications
