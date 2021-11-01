FROM        docker

ENV         GOPATH /go
ENV         SRCPATH ${GOPATH}/src/github.com/adnanh
ENV         WEBHOOK_VERSION 2.6.8

RUN         apk add --update -t build-deps curl go git libc-dev gcc libgcc && \
RUN         curl -L -o /tmp/webhook-${WEBHOOK_VERSION}.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
RUN         mkdir -p ${SRCPATH} && tar -xvzf /tmp/webhook-${WEBHOOK_VERSION}.tar.gz -C ${SRCPATH} && \
RUN         mv -f ${SRCPATH}/webhook-* ${SRCPATH}/webhook && \
RUN         cd ${SRCPATH}/webhook && go get -d && go build -o /usr/local/bin/webhook && \
RUN         apk del --purge build-deps && \
RUN         apk add --update openssh git py-pip && \
            pip install docker-compose && \
            rm -rf /var/cache/apk/* && \
            rm -rf ${GOPATH}

EXPOSE      9000

ENTRYPOINT  ["/usr/local/bin/webhook"]