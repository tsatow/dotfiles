if [ ! -d ${HOME}/.config/alacritty ]; then mkdir -p ${HOME}/.config/alacritty; fi
ln -sf ${PWD}/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml
ln -sf ${PWD}/alacritty/$(uname).toml ${HOME}/.config/alacritty/os-settings.toml

# 設置ファイルのサンプルをダウンロード
wget -q "https://github.com/alacritty/alacritty/releases/download/v$(alacritty --version | cut -d ' ' -f 2)/alacritty.yml" -O ${PWD}/alacritty/alacritty.yml.example
