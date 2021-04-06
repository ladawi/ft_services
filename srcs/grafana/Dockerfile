FROM alpine:3.11.3

RUN apk -f upgrade && apk -f update
RUN apk add openrc musl busybox
RUN wget https://dl.grafana.com/oss/release/grafana-6.7.2.linux-amd64.tar.gz \
&& tar -zxvf grafana-6.7.2.linux-amd64.tar.gz

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY ./grafana.sh .
COPY default.ini /etc/default.ini
COPY ./grafana.db /grafana-6.7.2/data/grafana.db

EXPOSE 3000
ENTRYPOINT ["sh", "grafana.sh"]
