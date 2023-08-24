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

.PHONY: brew
brew:
	if ! (type brew > /dev/null 2>&1); then brew/install.sh; fi
	brew/setup.sh

.PHONY: alacritty
alacritty:
	${PWD}/alacritty/setup.sh

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
	if [ -e ${HOME}/.local/bin ]; then mkdir -p ${HOME}/.local/bin; fi
	ln -sf ${PWD}/scripts/* ${HOME}/.local/bin

.PHONY: emacs
emacs:
	mkdir -p ${PWD}/emacs/.emacs.d/themes
	curl -o ${PWD}/emacs/.emacs.d/themes/color-theme-tomorrow.el -L https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/GNU%20Emacs/color-theme-tomorrow.el
	curl -o ${PWD}/emacs/.emacs.d/themes/tomorrow-night-blue-theme.el -L https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/GNU%20Emacs/tomorrow-night-blue-theme.el
	# シンボリックリンクだと読み込まれない
	cp -rf ${PWD}/emacs/.emacs.d ${HOME}

.PHONY: all
all: $(PKG_MGR) alacritty starship tmux zed java scala haskell rust scripts kubernetes k6 aws terraform emacs $(notdir $(SHELL))
