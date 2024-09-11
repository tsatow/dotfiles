curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# To configure current shel
source "$HOME/.cargo/env"

cargo install --force cargo-make
cargo install cargo-modules
