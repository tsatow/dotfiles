#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SETTINGS_BASE="$SCRIPT_DIR/settings.json"
# 企業固有の設定 (plugin/marketplace 等)。gitignore されているためコミットされない。
# 会社PCでは手でこのファイルを置く(または退避先から復元する)
SETTINGS_COMPANY="$SCRIPT_DIR/settings.company.json"

# 1. Claude Code のインストール (native installer, ~/.local/bin/claude に入る)
if ! type claude > /dev/null 2>&1 && [ ! -x ~/.local/bin/claude ]; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# 2. settings.json の反映。
# ベース(コミット対象)と企業固有オーバーレイ(gitignore対象)を jq でマージして生成する
render_settings() {
    if [ -e "$SETTINGS_COMPANY" ]; then
        jq -s '.[0] * .[1]' "$SETTINGS_BASE" "$SETTINGS_COMPANY"
    else
        jq . "$SETTINGS_BASE"
    fi
}

# 比較用の正規化。herdr が管理する hook エントリ (herdr integration install claude が
# $HOME 基準の絶対パスで追記する) は dotfiles の管理対象外なので除外し、
# フォーマット差で誤検知しないよう jq -S でキーをソートする
normalize_settings() {
    jq -S '
      if .hooks then
        .hooks |= (with_entries(
          .value |= map(select([.hooks[]?.command // empty] | any(contains("herdr-agent-state.sh")) | not))
        ) | with_entries(select(.value | length > 0)))
      else . end'
}

mkdir -p ~/.claude
if [ -e ~/.claude/settings.json ]; then
    # 既存の設定と差分がある場合は、どちらが正か機械的に判断できないため上書きせずエラーで止める
    if ! diff -u <(render_settings | normalize_settings) <(normalize_settings < ~/.claude/settings.json); then
        echo "error: claude/settings.json(+settings.company.json) と ~/.claude/settings.json に差分があります (diff は上記)" >&2
        echo "  dotfiles側か ~/.claude/settings.json を手で揃えてから再実行してください" >&2
        exit 1
    fi
else
    render_settings > ~/.claude/settings.json
fi

# 3. herdr 連携 (SessionStart hook と skill)。
# これらは herdr が生成・更新を管理するファイルなので dotfiles では持たない
if type herdr > /dev/null 2>&1; then
    herdr integration install claude
fi

echo "claude setup completed !"
echo "初回は claude を起動して /login してください"
