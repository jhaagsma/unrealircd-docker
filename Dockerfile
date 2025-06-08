FROM debian:bookworm

# install build tools
RUN apt-get update \
 && apt-get install -y wget gcc make libssl-dev

# pull & compile UnrealIRCd
ARG VERSION=6.1.10
RUN wget https://www.unrealircd.org/downloads/unrealircd-${VERSION}.tar.gz \
 && tar xzf unrealircd-${VERSION}.tar.gz \
 && cd unrealircd-${VERSION} \
 && ./Config --with-module-dir=/usr/lib/unrealircd/modules \
 && make && make install

WORKDIR /home/unrealircd
EXPOSE 6667 6697 7000
VOLUME ["/home/unrealircd/conf","/home/unrealircd/data"]
CMD ["./unrealircd"]
