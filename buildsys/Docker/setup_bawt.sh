#!/usr/bin/env bash
set -e

BAWT_DIR="/opt/bawt"

echo "--> Creating persistent build directories in $BAWT_DIR..."
sudo mkdir -p "$BAWT_DIR/Setup"
sudo mkdir -p "$BAWT_DIR/InputLibs"
sudo chown -R "$USER":"$USER" "$BAWT_DIR"
