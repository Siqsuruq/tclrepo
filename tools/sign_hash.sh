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

# Create a SHA-256 hash of the file
echo "Creating SHA-256 hash of $FILENAME..."
openssl dgst -sha256 -binary -out "$FILENAME.sha256" "$FILENAME"

# Sign the hash with your private key
echo "Signing hash with $PRIVATE_KEY..."
openssl dgst -sha256 -sign "$PRIVATE_KEY" -out "$FILENAME.sig" "$FILENAME.sha256"

echo "Done."
