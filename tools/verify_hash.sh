#!/bin/bash

# Get the filename from the command-line arguments
FILENAME=$1

# Set the name of your public key file here
PUBLIC_KEY=public.pem

# Check if a filename was provided
if [ -z "$FILENAME" ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Create a SHA-256 hash of the received file
echo "Creating SHA-256 hash of $FILENAME..."
openssl dgst -sha256 -binary -out "$FILENAME.sha256" "$FILENAME"

# Verify the signature
echo "Verifying signature with $PUBLIC_KEY..."
openssl dgst -sha256 -verify "$PUBLIC_KEY" -signature "$FILENAME.sig" "$FILENAME.sha256"
