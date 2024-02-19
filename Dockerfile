FROM alpine:latest

RUN apk update && apk add --no-cache \
    bash \
    git \
    wget \
    tar \
    libc6-compat \
    coreutils \
    jq

WORKDIR /opt
RUN git clone --branch 8.8.0-pre https://github.com/IntersectMBO/cardano-node.git

RUN wget https://github.com/IntersectMBO/cardano-node/releases/download/8.8.0-pre/cardano-node-8.8.0-linux.tar.gz \
    && mkdir -p /usr/local/cardano-node \
    && tar -xzf cardano-node-8.8.0-linux.tar.gz -C /usr/local/cardano-node --strip-components=1 \
    && rm cardano-node-8.8.0-linux.tar.gz

ENV PATH="/usr/local/cardano-node:${PATH}"

COPY scripts /opt/scripts

COPY .env /opt/
RUN set -a && . /opt/.env && set +a

COPY ./scripts/mkfiles.sh /opt/cardano-node/scripts/babbage/mkfiles.sh

RUN chmod +x /opt/cardano-node/scripts/babbage/mkfiles.sh

# Defaults
ENV SLOT_LENGTH=1 \
    SLOT_COEFF=1 \
    EPOCH_LENGTH=500 \
    MAX_LOVELACE_SUPPLY=45000000000000000 \
    MAX_BLOCK_BODY_SIZE=65536 \
    MAX_BLOCK_HEADER_SIZE=1100 \
    MAX_TX_SIZE=16384 \
    GENESIS_KEY_HASH=cc7699bcad846a48850a92cfe0c4024b3d9b879e1ce32d3dd75a481b \
    GENESIS_INITIAL_FUNDS=1000000000000

ENTRYPOINT ["sh", "-c", "cd /opt/scripts && ./start.sh"]

