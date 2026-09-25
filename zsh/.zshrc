# 保管の設定
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# JAVA_HOME/JDK_HOMEをasdfのjavaに追随させる (asdf-javaプラグイン提供のフック。make java後に存在する)
[ -f ~/.asdf/plugins/java/set-java-home.zsh ] && . ~/.asdf/plugins/java/set-java-home.zsh

# SBT
export SBT_OPTS='-Xms8g -Xmx12g -Xss8m -XX:MaxMetaspaceSize=1g -XX:ReservedCodeCacheSize=1000m -XX:MaxMetaspaceSize=512m'
export UPDATE_LATEST=1

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

# path
export PATH=$HOME/.local/bin:$PATH
# coursier apps (metals など)。Zed が Metals を見つけるにはログインシェルの PATH に必要
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"

# awsssologin (scripts/awsssologin) のラッパー。
# スクリプトが /tmp/ZSH_BUFFER に書き出した export 文を呼び出し元シェルに取り込む
function awsssologin {
  command awsssologin "$@" && eval "$(cat /tmp/ZSH_BUFFER)"
}
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"

export KUBECONFIG=~/.kube/eks131-cwtest.yaml

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/tsatow/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
