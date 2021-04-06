FROM alpine:3.11.3

RUN apk update
RUN apk -f add openrc
RUN apk -f add vsftpd
RUN apk add bash

COPY ftps.sh .
COPY vsftpd.conf /etc/vsftpd/.

RUN adduser --disabled-password --home etc/vsftpd/home ladawi && \
    echo "ladawi:ladawi" | chpasswd

RUN chown ladawi /
EXPOSE 21 40000

ENTRYPOINT ["sh", "ftps.sh"]