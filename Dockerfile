FROM golang:1.10.2-alpine

RUN apk add --no-cache --update alpine-sdk

COPY . /go/src/github.com/giantswarm/oauth2_proxy
RUN cd /go/src/github.com/giantswarm/oauth2_proxy && go build .

FROM alpine:3.7
ENV DOCKERIZE_VERSION v0.6.1
EXPOSE 8080 4180

COPY --from=0 /go/src/github.com/giantswarm/oauth2_proxy/oauth2_proxy /usr/local/bin/oauth2_proxy
ENTRYPOINT [ "/usr/local/bin/oauth2_proxy" ]
