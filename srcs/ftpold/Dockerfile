FROM alpine:3.11.3

RUN apk update
RUN apk -f add openrc
RUN apk -f add vsftpd
RUN apk add bash

COPY ftps.sh .


RUN apk add openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1
 
RUN adduser --disabled-password --home etc/vsftpd/home ladawi && \
    echo "ladawi:ladawi" | chpasswd

RUN chown ladawi /
COPY vsftpd.conf /etc/vsftpd/.

EXPOSE 21 20 40000
ENTRYPOINT ["sh", "ftps.sh"]