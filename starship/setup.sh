curl -sS https://starship.rs/install.sh | sh

if [ ! -d ${HOME}/.config ]; then mkdir -p ${HOME}/.config; fi
ln -sf ${PWD}/starship/starship.toml ${HOME}/.config/starship.toml