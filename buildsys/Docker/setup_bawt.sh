#!/usr/bin/env bash
set -e

BAWT_DIR="/opt/bawt"

echo "--> Creating persistent build directories in $BAWT_DIR..."
sudo mkdir -p "$BAWT_DIR/Setup"
sudo mkdir -p "$BAWT_DIR/InputLibs"
sudo chown -R "$USER":"$USER" "$BAWT_DIR"

echo "--> Fetching BAWT framework toolchain scripts..."
cd "$BAWT_DIR"
curl -L -s -O https://tcl3d.org
unzip -q -j Bawt-3.3.0.zip -d "$BAWT_DIR"
rm Bawt-3.3.0.zip