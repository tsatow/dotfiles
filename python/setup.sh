TARGET=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -n 1 | xargs echo)
pyenv install -s $TARGET
pyenv global $TARGET