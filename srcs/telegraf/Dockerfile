FROM alpine:3.11.3

RUN apk -f upgrade && apk -f update
RUN apk -f add wget tar

RUN mkdir -p /etc/telegraf
RUN apk add telegraf --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing
RUN touch /var/run/utmp
COPY telegraf.conf /etc/telegraf/.

EXPOSE 35000

COPY telegraph.sh .
ENTRYPOINT ["sh", "telegraph.sh"]