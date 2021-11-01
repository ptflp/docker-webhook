FROM        golang:alpine3.11
MAINTAINER  Almir Dzinovic <almir@dzinovic.net>
WORKDIR     /go/src/github.com/adnanh/webhook
ENV         WEBHOOK_VERSION 2.8.0
RUN         apk add --update -t build-deps curl libc-dev gcc libgcc
RUN         curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
            tar -xzf webhook.tar.gz --strip 1 &&  \
            go get -d && \
            go build -o /usr/local/bin/webhook && \
            apk del --purge build-deps && \
            apk add --update openssh git py-pip && \
            pip install docker-compose && \
            rm -rf /var/cache/apk/* && \
            rm -rf /go

WORKDIR     /etc/webhook
VOLUME      ["/etc/webhook"]
EXPOSE      9000

ENTRYPOINT  ["/usr/local/bin/webhook"]