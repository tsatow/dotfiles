#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

mkdir -p ${HOME}/.config/zed/themes
mkdir -p ${HOME}/.local/bin
ln -sf "$SCRIPT_DIR/settings.json" ${HOME}/.config/zed/settings.json
# Tomorrow Night Blue テーマ。元は拡張機能(tomorrow-theme)だったが、レジストリの
# 検索から消えて自動インストールできなくなったため、テーマJSONを直接持つ
ln -sf "$SCRIPT_DIR/themes/tomorrow.json" ${HOME}/.config/zed/themes/tomorrow.json
ln -sf "$SCRIPT_DIR/keymap.json" ${HOME}/.config/zed/keymap.json
ln -sf "$SCRIPT_DIR/tasks.json" ${HOME}/.config/zed/tasks.json
ln -sf "$SCRIPT_DIR/org-todo" ${HOME}/.local/bin/org-todo
