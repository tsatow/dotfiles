# 保管の設定
autoload -Uz compinit
compinit

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# SBT
export SBT_OPTS='-Xms8g -Xmx12g -Xss8m -XX:MaxMetaspaceSize=1g -XX:ReservedCodeCacheSize=1000m -XX:MaxMetaspaceSize=512m'
export UPDATE_LATEST=1

# ghq
# see https://github.com/Songmu/ghq-handbook
git config --global ghq.root '~/src'

# peco
function peco-checkout-pull-request () {
    local selected_pr_id=$(gh pr list | peco | awk '{ print $1 }')
    if [ -n "$selected_pr_id" ]; then
        BUFFER="gh pr checkout ${selected_pr_id}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-checkout-pull-request
bindkey "^g^p" peco-checkout-pull-request

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# gh
eval "$(gh completion -s zsh)"

# kubernetes
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

# starship
eval "$(starship init zsh)"

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH=$HOME/.local/bin:$PATH

# zle utilities
# /tmp/ZSH_BUFFERを経由してシェルスクリプトから任意のコマンドを実行させる
# 例えばシェルスクリプト内で環境変数を設定したいときに`tmux send-keys C-[`を実行して呼び出す
function accept-buffer {
  zle kill-whole-line
  BUFFER=$(cat /tmp/ZSH_BUFFER)
  CURSOR=$#BUFFER
  zle accept-line
}
zle -N accept-buffer
bindkey '^[' accept-buffer