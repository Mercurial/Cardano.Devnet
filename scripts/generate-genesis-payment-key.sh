#!/bin/bash

# Create a directory to store the keys
mkdir -p ./keys

# Generate a payment key for the genesis wallet
cardano-cli address key-gen \
  --verification-key-file ./keys/payment.vkey \
    --signing-key-file ./keys/payment.skey
  
cardano-cli address build \
    --payment-verification-key-file ./keys/payment.vkey \
    --testnet-magic 42 > ./keys/payment.addr

# Get key hash and print it
PAYMENT_KEY_HASH=$(cardano-cli address key-hash --payment-verification-key-file ./keys/payment.vkey)

# Save Key Hash to file
echo ${PAYMENT_KEY_HASH} > ./keys/payment.keyhash

echo "Payment key hash: ${PAYMENT_KEY_HASH}"