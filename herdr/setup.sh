if ! (type herdr > /dev/null 2>&1); then
  curl -fsSL https://herdr.dev/install.sh | sh
fi
mkdir -p ${HOME}/.config/herdr
ln -sf $(cd $(dirname $0) && pwd)/config.toml ${HOME}/.config/herdr/config.toml
