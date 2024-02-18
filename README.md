```sh
docker built -t cardano-devnet .
docker run -v ./devnet-data:/opt/cardano-node/devnet --name cardano-devnet cardano-devnet
```