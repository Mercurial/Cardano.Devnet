#!/bin/bash

# Check if ../keys directory exists for genesis / faucet wallet
if [ -d "../keys" ]; then
    # Check if ../keys/payment.addr exists
    if [ -f "../keys/payment.addr" ]; then
        echo "The payment.addr file already exists. Skipping the generation of the genesis wallet."
    else
        echo "The payment.addr file does not exist. Running generate-genesis-payment-key.sh..."
        cd .. && ./scripts/generate-genesis-payment-key.sh && cd ./scripts
    fi
else
    echo "The keys directory does not exist. Running generate-genesis-payment-key.sh..."
    cd .. && ./scripts/generate-genesis-payment-key.sh && cd ./scripts
fi

cd ../cardano-node

if [ -d "devnet" ]; then
    if ! find ./devnet -mindepth 1 -maxdepth 1 | read; then
        echo "The devnet directory is empty. Running mkfiles.sh..."
        ./scripts/babbage/mkfiles.sh
        # Check if devnet-temp directory exists
        if [ -d "devnet-temp" ]; then
            # Remove the contents of devnet directory without deleting the directory itself
            # This is important because devnet is a mounted volume
            find ./devnet -mindepth 1 -delete
            
            # Move the contents of devnet-temp to devnet
            mv ./devnet-temp/* ./devnet/
            
            # Remove the now empty devnet-temp directory
            rmdir ./devnet-temp
        fi
    else
        echo "The devnet directory is not empty."
    fi
else
    echo "The devnet directory does not exist. Running mkfiles.sh..."
    ./scripts/babbage/mkfiles.sh
fi

# if symlink not exists then create it
if [ ! -L "./devnet-temp" ]; then
    ln -s ./devnet ./devnet-temp
fi

./devnet/run/all.sh
