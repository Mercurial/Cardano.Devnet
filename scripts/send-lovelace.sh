#!/bin/bash

# Usage is ./scripts/send-lovelace.sh <WALLET_ADDRESS> <LOVELACE_AMOUNT> 

# ACCEPT ARGUMENT FOR WALLET ADDRESS (print usage message if not provided)

if [ -z "$1" ]; then
  echo "Usage: ./scripts/send-lovelace.sh <WALLET_ADDRESS> <LOVELACE_AMOUNT>"
  exit 1
fi

WALLET_ADDRESS=$1

# ACCEPT ARGUMENT FOR LOVELACE AMOUNT (print usage message if not provided)

if [ -z "$2" ]; then
  echo "Usage: ./scripts/send-lovelace.sh <WALLET_ADDRESS> <LOVELACE_AMOUNT>"
  exit 1
fi

# Save the amount to a variable
LOVELACE_AMOUNT=$2


SOURCE_WALLET_ADDRESS=$(cat ./keys/payment.addr)
# Query the balance
cardano-cli query utxo --address $SOURCE_WALLET_ADDRESS --testnet-magic 42 --out-file ./keys/payment.utxo.json

# Json looks like this
# "cedcae8b4af2432b739b73e5a6731ab784c762f79fa87dc5121808debc58f5d0#0" is the utxo reference (identifier)
# identifier.value.lovelace is the amount of lovelace in the utxo
# {
#   "cedcae8b4af2432b739b73e5a6731ab784c762f79fa87dc5121808debc58f5d0#0": {
#     "address": "addr_test1vz6hvf0tnl2eyxgxh2uyvtnusjxhttzw9g6mk98zkj2exqcy3zue7",
#     "datum": null,
#     "datumhash": null,
#     "inlineDatum": null,
#     "referenceScript": null,
#     "value": {
#       "lovelace": 600000000000
#     }
#   }
# }

# Use jq to read the json gile and collect all the utxo references
UTXO=$(jq -r 'keys[]' ./keys/payment.utxo.json)

# add all utxo references to the transaction
TX_IN=""
for utxo in $UTXO; do
  TX_IN="${TX_IN} --tx-in ${utxo}"
done

# build the transaction
cardano-cli conway transaction build ${TX_IN} \
--tx-out ${WALLET_ADDRESS}+${LOVELACE_AMOUNT} \
--change-address ${SOURCE_WALLET_ADDRESS} \
--out-file /tmp/tx.raw \
--testnet-magic 42

# sign the transaction
cardano-cli transaction sign \
--tx-body-file /tmp/tx.raw \
--signing-key-file ./keys/payment.skey \
--out-file /tmp/tx.signed \
--testnet-magic 42

# submit the transaction
cardano-cli transaction submit --tx-file /tmp/tx.signed --testnet-magic 42
