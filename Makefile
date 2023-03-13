OS=$(shell uname)
ifeq ($(OS),Darwin)
	SHELL=/bin/zsh
	PKG_MGR=brew
else
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

.PHONY: rust
rust:
	${PWD}/rust/setup.sh

.PHONY: kubernetes
kubernetes:
	${PWD}/kubernetes/setup.sh

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

.PHONY: all
all: $(PKG_MGR) alacritty starship tmux zed java scala kubernetes aws terraform $(notdir $(SHELL))