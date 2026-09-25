curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# To configure current shel
source "$HOME/.cargo/env"

# --locked: クレート同梱のCargo.lockで依存を固定する。
# lockなしだと最新の依存が解決され、ビルドが壊れることがある
# (例: unicode-ident/unicode-propertiesのUnicodeバージョン不一致)
cargo install --force --locked cargo-make
cargo install --locked cargo-modules
