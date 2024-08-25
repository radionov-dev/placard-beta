## syntax=docker/dockerfile:3

FROM alpine:latest

#SHELL ["/bin/ash", "-ex", "-c"]

ENV ELECTRUM_USER=electrum_api
ENV ELECTRUM_PASSWORD=electrum_password

ENV HOME=/home/electrum
#ENV TESTNET=false

EXPOSE 7000

RUN addgroup electrum ;\
	adduser -D -h $HOME -G electrum electrum

RUN apk --no-cache add electrum

USER electrum
WORKDIR $HOME

CMD test "$ELECTRUM_TESTNET" = 1 -o "$ELECTRUM_TESTNET" = true && FLAGS='--testnet' ;\
                electrum --offline $FLAGS setconfig rpcuser ${ELECTRUM_USER} ;\
                electrum --offline $FLAGS setconfig rpcpassword ${ELECTRUM_PASSWORD} ;\
                electrum --offline $FLAGS setconfig rpchost 0.0.0.0 ;\
                electrum --offline $FLAGS setconfig rpcport 7000 ;\
                #electrum --offline $FLAGS create ;\
                exec electrum $FLAGS daemon

