#!/bin/bash
cardano-cli query utxo --address $(cat ./keys/payment.addr) --testnet-magic 42 --out-file /dev/stdout | jq