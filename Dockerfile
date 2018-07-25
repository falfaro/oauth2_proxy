FROM golang:1.10.2-alpine

RUN apk add --no-cache --update alpine-sdk

COPY . /go/src/github.com/giantswarm/oauth2_proxy
RUN cd /go/src/github.com/giantswarm/oauth2_proxy && go build .

FROM alpine:3.7
ENV DOCKERIZE_VERSION v0.6.1
EXPOSE 8080 4180

RUN apk add --no-cache ca-certificates busybox-extras openssl
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY --from=0 /go/src/github.com/giantswarm/oauth2_proxy/oauth2_proxy /usr/local/bin/oauth2_proxy
ENTRYPOINT [ "/usr/local/bin/dockerize" ]
