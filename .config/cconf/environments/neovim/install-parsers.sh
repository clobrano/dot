#!/bin/bash
  mkdir -p ~/.local/share/nvim/parser

  PARSERS=(bash python go javascript typescript json yaml)

  for parser in "${PARSERS[@]}"; do
    echo "Installing $parser parser..."

    # Get the download URL for tar.gz
    DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/tree-sitter/tree-sitter-$parser/releases/latest" | \
      jq -r ".assets[] | select(.name == \"tree-sitter-$parser.tar.gz\") | .browser_download_url")

    if [ -z "$DOWNLOAD_URL" ]; then
      echo "No tar.gz found for $parser, skipping..."
      continue
    fi

    TEMP_DIR=$(mktemp -d)

    curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/tree-sitter-$parser.tar.gz"
    tar -xzf "$TEMP_DIR/tree-sitter-$parser.tar.gz" -C "$TEMP_DIR"

    find "$TEMP_DIR" -name "*.so" -exec mv {} ~/.local/share/nvim/parser/$parser.so \;

    rm -rf "$TEMP_DIR"
    echo "$parser installed."
  done
