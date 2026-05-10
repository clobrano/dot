#!/usr/bin/env bash
# Rust installer
version=`rustc --version`
if [[ -n $version ]]; then
    echo [+] Rust installed
    echo $version
else
    set -x
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup toolchain install -y stable
fi

# Rust test code
cd /tmp
RUSTFILE=rusttestfile
cat > $RUSTFILE.rs <<EOF
fn main() {
    println!("Rust is working fine!");
}
EOF

rustc $RUSTFILE.rs
./$RUSTFILE
rm ./$RUSTFILE{,.rs}
cd -

echo "Installing rust-analyzer"
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

