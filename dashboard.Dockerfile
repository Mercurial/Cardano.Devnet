# Use the official Microsoft .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build-env
WORKDIR /app

# Copy the .csproj file and restore any dependencies (via NuGet)
COPY ./src ./src/
WORKDIR /app/src/Cardano.Devnet
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# Generate the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

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
ENV SYSTEMROOT=/opt

ENV CARDANO_NODE_SOCKET_PATH=/opt/cardano-node/devnet/main.sock

WORKDIR /app
COPY --from=build-env /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "Cardano.Devnet.dll"]
