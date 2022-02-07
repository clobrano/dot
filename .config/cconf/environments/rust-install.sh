#!/usr/bin/env bash
# Rust installer
version=`rustc --version`
if [[ -n $version ]]; then
    echo [+] Rust installed
    echo $version
else
    set -x
    curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
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
