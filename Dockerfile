FROM golang:alpine as builder

RUN set -x && \
	cd src && mkdir github.com && cd * && mkdir erroneousboat && cd * && \
	wget https://github.com/kpm/slack-term/archive/master.zip && \
	unzip master.zip  -d . &&  mv slack-term-master slack-term && \
	apk add --update --no-cache ca-certificates make && \
	cd slack-term && make build && \
	mv ./bin/slack-term /usr/bin/slack-term

FROM alpine:latest

ENV USER root

COPY --from=builder /usr/bin/slack-term /usr/bin/slack-term
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs

ENTRYPOINT stty cols 25 && slack-term -config .slack-term
