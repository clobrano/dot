#!/usr/bin/env bash
# -*- coding: UTF-8 -*-

: "${TASKWARRIOR_VERSION:=3.3.0}"
: "${TASKWARRIOR_TUI_VERSION:=v0.26.3}"

install_dependencies() {
    echo "[+] installing tasklib..."
    pip3 install --user tasklib
    pip3 install --user pynvim
}

install_taskwarrior_tui()
{
    local archive="taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz"
    if ! wget "https://github.com/kdheepak/taskwarrior-tui/releases/download/$TASKWARRIOR_TUI_VERSION/$archive"; then
        echo "[!] could not get taskwarrior-tui release $TASKWARRIOR_TUI_VERSION"
        exit 1
    fi
    tar xvf "$archive"
    mv taskwarrior-tui ~/.local/bin
    rm -f "$archive"
}

build_from_source() {
    local package="task-$TASKWARRIOR_VERSION"
    local archive="$package.tar.gz"

    if [ ! -f "$archive" ]; then
        if ! wget "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v$TASKWARRIOR_VERSION/$archive"; then
            echo "[!] could not get taskwarrior release v$TASKWARRIOR_VERSION"
            exit 1
        fi
    fi

    sudo dnf install -y cmake libuuid-devel
    ../rust-install-and-setup.sh

    mkdir -p ~/Apps
    mv "$archive" ~/Apps

    pushd ~/Apps || exit 1
    tar xvf "$archive"
    pushd "$package" || exit 1
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build
    sudo cmake --install build
    popd || exit 1
    rm "$archive"
    popd || exit 1

    echo "[+] done."
}
