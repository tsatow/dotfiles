# 保管の設定
autoload -Uz compinit
compinit

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# SBT
export SBT_OPTS='-Xms8g -Xmx12g -XX:MaxMetaspaceSize=1g -XX:ReservedCodeCacheSize=1000m'

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

# starship
eval "$(starship init zsh)"
