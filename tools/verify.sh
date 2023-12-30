#!/bin/bash

# Get the filename and signature file from the command-line arguments
FILENAME=$1
SIGNATURE_FILE=$2

# Set the name of your public key file here
PUBLIC_KEY=public.pem

# Check if both filename and signature file were provided
if [ -z "$FILENAME" ] || [ -z "$SIGNATURE_FILE" ]; then
    echo "Usage: $0 filename signature_file"
    exit 1
fi

# Verify the signature
echo "Verifying signature with $PUBLIC_KEY..."
openssl dgst -sha256 -verify "$PUBLIC_KEY" -signature "$SIGNATURE_FILE" "$FILENAME"
