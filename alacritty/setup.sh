if [ ! -d ${HOME}/.config/alacritty ]; then mkdir -p ${HOME}/.config/alacritty; fi
ln -sf ${PWD}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
ln -sf ${PWD}/alacritty/$(uname).yml ${HOME}/.config/alacritty/os-settings.yml

# 設置ファイルのサンプルをダウンロード
wget -q "https://github.com/alacritty/alacritty/releases/download/v$(alacritty --version | cut -d ' ' -f 2)/alacritty.yml" -O ${PWD}/alacritty/alacritty.yml.example