OS=$(shell uname)
ifeq ($(OS),Darwin)
	# MacOSの場合
	SHELL=/bin/zsh
	PKG_MGR=brew
else
	# Fedoraの場合
	SHELL=/bin/bash
	PKG_MGR=dnf
endif

# makeのレシピは非ログインシェルで実行されるため、brewでインストールした
# CLI (asdf, cs 等) が新規マシンではPATHにない。ここで通しておく
export PATH := /opt/homebrew/bin:/usr/local/bin:$(PATH)

.PHONY: brew
brew:
	if ! (type brew > /dev/null 2>&1); then brew/install.sh; fi
	brew/setup.sh

.PHONY: ghostty
ghostty:
	${PWD}/ghostty/setup.sh

.PHONY: starship
starship:
	${PWD}/starship/setup.sh

.PHONY: tmux
tmux:
	ln -sf ${PWD}/tmux/.tmux.conf ${HOME}/.tmux.conf

.PHONY: zed
zed:
	${PWD}/zed/setup.sh

.PHONY: java
java:
	${PWD}/java/setup.sh

.PHONY: scala
scala:
	${PWD}/scala/setup.sh

.PHONY: haskell
haskell:
	${PWD}/haskell/setup.sh

.PHONY: rust
rust:
	${PWD}/rust/setup.sh

.PHONY: python
python:
	${PWD}/python/setup.sh

.PHONY: kubernetes
kubernetes:
	${PWD}/kubernetes/setup.sh

.PHONY: k6
k6:
	${PWD}/k6/setup.sh

.PHONY: aws
aws:
	${PWD}/aws/setup.sh

.PHONY: terraform
terraform:
	${PWD}/terraform/setup.sh

.PHONY: zsh
zsh:
	if [ -e ${HOME}/.zshrc ]; then mv ${HOME}/.zshrc ${PWD}/zsh/.zshrc.bkup; fi
	ln -sf ${PWD}/zsh/.zshrc ${HOME}/.zshrc
	. ${HOME}/.zshrc

.PHONY: scripts
scripts:
	mkdir -p ${HOME}/.local/bin
	ln -sf ${PWD}/scripts/* ${HOME}/.local/bin

.PHONY: emacs
emacs:
	mkdir -p ${PWD}/emacs/.emacs.d/themes
	curl -o ${PWD}/emacs/.emacs.d/themes/color-theme-tomorrow.el -L https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/GNU%20Emacs/color-theme-tomorrow.el
	curl -o ${PWD}/emacs/.emacs.d/themes/tomorrow-night-blue-theme.el -L https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/GNU%20Emacs/tomorrow-night-blue-theme.el
	# 既存の実ディレクトリが残っているとln -sfnが失敗するため退避する
	if [ -d ${HOME}/.emacs.d ] && [ ! -L ${HOME}/.emacs.d ]; then mv ${HOME}/.emacs.d ${HOME}/.emacs.d.bkup; fi
	ln -sfn ${PWD}/emacs/.emacs.d ${HOME}/.emacs.d

.PHONY: git
git:
	${PWD}/git/setup.sh

.PHONY: zig
zig:
	${PWD}/zig/setup.sh

.PHONY: herdr
herdr:
	${PWD}/herdr/setup.sh

.PHONY: claude
claude:
	${PWD}/claude/setup.sh

.PHONY: all
all: claude $(PKG_MGR) ghostty starship tmux zed java scala haskell rust scripts kubernetes k6 aws terraform emacs git zig herdr $(notdir $(SHELL))
