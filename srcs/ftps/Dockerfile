FROM alpine:3.13.2

RUN apk update
RUN apk add telegraf
RUN apk add openrc
RUN apk add openssl
RUN apk add vsftpd

RUN mkdir -p /run/openrc
RUN touch /run/openrc/softlevel
RUN openrc >/dev/null 2>&1

RUN apk add openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1


RUN adduser --disabled-password --home etc/vsftpd/home ladawi && \
    echo "ladawi:ladawi" | chpasswd && \
    echo 'I m a test file waiting to be transfered in the ft_service directory' >> etc/vsftpd/home/testfile2.txt
RUN chown ladawi /
RUN chmod 766 /etc/vsftpd/home/testfile2.txt

COPY vsftpd.conf /etc/vsftpd/
COPY start.sh /tmp/

EXPOSE 21 4000
ENTRYPOINT sh tmp/start.sh