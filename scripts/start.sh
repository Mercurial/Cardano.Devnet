#!/bin/bash
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
            
            # now that the files are in ./devnet make a symlink ./devnet-temp -> ./devnet
            ln -s ./devnet ./devnet-temp
        fi
    else
        echo "The devnet directory is not empty."
    fi
else
    echo "The devnet directory does not exist. Running mkfiles.sh..."
    ./scripts/babbage/mkfiles.sh
fi

./devnet/run/all.sh
