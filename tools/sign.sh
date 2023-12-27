#!/bin/bash

# Get the filename from the command-line arguments
FILENAME=$1

# Set the name of your private key file here
PRIVATE_KEY=private.pem

# Check if a filename was provided
if [ -z "$FILENAME" ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Sign the file directly with your private key
echo "Signing $FILENAME with $PRIVATE_KEY..."
openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "$FILENAME.sig" "$FILENAME"

echo "Done."
