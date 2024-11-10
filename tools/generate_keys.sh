#!/bin/bash

# Script to generate RSA private and public keys without a password

# Generate a 2048-bit RSA private key
openssl genrsa -out private.pem 2048

# Extract the public key from the private key
openssl rsa -in private.pem -pubout -out public.pem

echo "Private key (private.pem) and public key (public.pem) have been generated successfully."
