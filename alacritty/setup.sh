if [ ! -d ${HOME}/.config/alacritty ]; then mkdir -p ${HOME}/.config/alacritty; fi
ln -sf ${PWD}/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml
ln -sf ${PWD}/alacritty/$(uname).toml ${HOME}/.config/alacritty/os-settings.toml

# 設定ファイルはhttps://alacritty.org/config-alacritty.htmlを参照
