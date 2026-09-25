#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TEMPLATE="$SCRIPT_DIR/.gitconfig.template"
WORK_TEMPLATE="$SCRIPT_DIR/.gitconfig-work.template"

# 仕事用組織の決定。グローバルは私用アイデンティティ(テンプレートに直書き)で、
# ~/src/github.com/<org>/ 配下だけ ~/.gitconfig-work の仕事用アイデンティティを includeIf で当てる。
# 初回(~/.gitconfigが無い)は確認し、2回目以降は既存の includeIf 行から組織名を抽出する。
# org が空 = このPCでは仕事用アカウントを使わない
if [ -e ~/.gitconfig ]; then
    org=$(sed -n 's|^\[includeIf "gitdir:~/src/github.com/\(.*\)/"\]$|\1|p' ~/.gitconfig)
else
    read -p "仕事用と私用のgitアカウントを分けますか？ (私用PCなら n) [y/n]: " answer
    case "$answer" in
        [yY]*) read -p "INPUT YOUR WORK GITHUB ORG (~/src/github.com/<ORG>/ 配下が仕事用になる): " org ;;
        *)     org= ;;
    esac
fi

# テンプレートの <FIXORG> を実際の組織名で埋めて出力する。
# 仕事用を使わない場合は [includeIf] セクションごと除く
render_gitconfig() {
    if [ -n "$org" ]; then
        sed -e "s|<FIXORG>|$org|g" "$TEMPLATE"
    else
        awk '/^\[/{skip = ($0 ~ /^\[includeIf /)} !skip' "$TEMPLATE"
    fi
}

if [ -e ~/.gitconfig ]; then
    # テンプレートと差分がある場合は、どちらが正か機械的に判断できないため上書きせずエラーで止める
    # (組織名は既存ファイルから抽出して埋めるので差分に出ない)
    if ! diff -u <(render_gitconfig) ~/.gitconfig; then
        echo "error: git/.gitconfig.template と ~/.gitconfig に差分があります (diff は上記)" >&2
        echo "  テンプレートか ~/.gitconfig を手で揃えてから make git を再実行してください" >&2
        exit 1
    fi
else
    render_gitconfig > ~/.gitconfig
fi

# 仕事用の上書き設定 (~/.gitconfig-work) が無ければ入力させて生成する。
# 中身は user.name / user.email だけなので、以後の変更は直接編集でよい
if [ -n "$org" ] && [ ! -e ~/.gitconfig-work ]; then
    read -p "INPUT YOUR WORK GITHUB USER NAME: " work_name
    read -p "INPUT YOUR WORK GITHUB EMAIL ADDRESS: " work_email
    sed -e "s|<FIXNAME>|$work_name|g" -e "s|<FIXEMAIL>|$work_email|g" "$WORK_TEMPLATE" > ~/.gitconfig-work
fi

email=$(git config --global --get user.email)
if [ ! -e ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$email"
fi

# GitHub CLIが未ログインだと鍵の登録ができない (新PCでは未ログイン)
if ! gh auth status > /dev/null 2>&1; then
    gh auth login
fi

# 公開鍵がGitHubに未登録なら登録する (gh ssh-key list はアクティブなアカウントの鍵のみ返す)
# see https://cli.github.com/manual/gh_ssh-key_add
if ! gh ssh-key list 2>/dev/null | grep -qF "$(awk '{print $2}' ~/.ssh/id_ed25519.pub)"; then
    add_output=$(gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(uname -n) $(uname -o) added at $(date '+%Y-%m-%d %H:%M:%S')" 2>&1) || {
        if echo "$add_output" | grep -qi "already in use"; then
            # ghのアクティブアカウントとは別のアカウントに登録済みの鍵 (複数アカウント運用時)
            echo "公開鍵は別のGitHubアカウントで登録済みのためスキップします"
        else
            echo "$add_output" >&2
            echo "error: 公開鍵の登録に失敗しました。権限不足の場合は" >&2
            echo "  gh auth refresh -h github.com -s admin:public_key" >&2
            echo "を実行してから make git を再実行してください" >&2
            exit 1
        fi
    }
fi

# 毎回の入力を避ける (macOSのみ)
if [ "$(uname)" = "Darwin" ]; then
    ssh-add --apple-load-keychain
fi

echo "git setup completed !"
bat ~/.gitconfig
