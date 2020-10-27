FROM alpine:3.11.3

RUN apk -f upgrade && apk -f update
RUN apk add openrc musl busybox
RUN apk add grafana --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY ./grafana.sh .
COPY default.ini /etc/default.ini
RUN mkdir -p /usr/share/grafana/data
COPY ./grafana.db /usr/share/grafana/data/grafana.db

EXPOSE 3000
ENTRYPOINT ["sh", "grafana.sh"]
