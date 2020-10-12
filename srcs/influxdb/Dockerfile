FROM alpine:3.11.3
RUN apk -f upgrade && apk -f update
RUN apk -f add wget
RUN apk add influxdb --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY ./influx.sh .
COPY influxdb.conf /etc/influxdb/.
RUN mkdir -p app/influxdb

ENTRYPOINT ["sh", "influx.sh"]