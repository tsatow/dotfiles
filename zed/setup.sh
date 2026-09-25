#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

mkdir -p ${HOME}/.config/zed
mkdir -p ${HOME}/.local/bin
ln -sf "$SCRIPT_DIR/settings.json" ${HOME}/.config/zed/settings.json
ln -sf "$SCRIPT_DIR/keymap.json" ${HOME}/.config/zed/keymap.json
ln -sf "$SCRIPT_DIR/tasks.json" ${HOME}/.config/zed/tasks.json
ln -sf "$SCRIPT_DIR/org-todo" ${HOME}/.local/bin/org-todo
