```sh
docker build -t cardano-devnet .
docker run -v ./devnet-data:/opt/cardano-node/devnet --name cardano-devnet cardano-devnet

docker exec cardano-devnet /opt/scripts/genesis-balance.sh
docker exec cardano-devnet /opt/scripts/send-lovelace.sh addr_test1vp4u5pp7k6wedt75zua8el6d5ahyfaa4ct5red647pnu83g2ulmja 1000000
```