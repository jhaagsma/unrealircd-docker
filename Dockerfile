FROM debian:bookworm

ARG VERSION=6.1.10

# install build tools
RUN apt-get update \
 && apt-get install -y wget ca-certificates gcc make libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Create an unrealircd user and workspace
RUN useradd --system --home-dir /home/unrealircd --shell /bin/bash unrealircd \
 && mkdir -p /home/unrealircd/source \
 && chown -R unrealircd:unrealircd /home/unrealircd

# Switch to that user before downloading & building
USER unrealircd
WORKDIR /home/unrealircd/source

RUN mkdir -p /home/unrealircd/modules \
 && chown -R unrealircd:unrealircd /home/unrealircd


# pull & compile UnrealIRCd
RUN wget https://www.unrealircd.org/downloads/unrealircd-${VERSION}.tar.gz \
 && tar xzf unrealircd-${VERSION}.tar.gz \
 && cd unrealircd-${VERSION} \
 && ./Config --prefix=/home/unrealircd --with-module-dir=/home/unrealircd/modules \
 && make && make install

WORKDIR /home/unrealircd
EXPOSE 6667 6697 7000
VOLUME ["/home/unrealircd/conf","/home/unrealircd/data"]

# Hand off to the non‐root UnrealIRCd entrypoint
USER unrealircd
CMD ["./unrealircd"]
