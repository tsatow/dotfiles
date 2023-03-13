if [ ! -d ${HOME}/.config/zed ]; then mkdir -p ${HOME}/.config/zed; fi
ln -sf ${PWD}/zed/settings.json ${HOME}/.config/zed/settings.json
