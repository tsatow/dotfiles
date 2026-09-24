#!/bin/bash
set -eu

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# インストール直後の brew の場所 (Apple Silicon: /opt/homebrew, Intel: /usr/local)
BREW_BIN=
for prefix in /opt/homebrew /usr/local; do
    if [ -x "$prefix/bin/brew" ]; then
        BREW_BIN="$prefix/bin/brew"
        break
    fi
done
if [ -z "$BREW_BIN" ]; then
    echo "error: インストール後の brew が見つかりませんでした" >&2
    exit 1
fi

# 本家 install.sh の "Next steps" と同じ手順でログインシェルにパスを通す (二重追記は防ぐ)
if ! grep -qs 'brew shellenv' ~/.zprofile; then
    echo >> ~/.zprofile
    echo "eval \"\$(${BREW_BIN} shellenv zsh)\"" >> ~/.zprofile
fi
