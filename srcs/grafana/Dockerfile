FROM alpine:3.11.3

RUN apk -f upgrade && apk -f update
RUN apk add openrc musl busybox
RUN apk add grafana --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY ./grafana.sh .
EXPOSE 3000
ENTRYPOINT ["sh", "grafana.sh"]
