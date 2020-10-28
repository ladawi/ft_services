FROM alpine:3.11.3

RUN apk update
RUN apk -f add openrc
RUN apk -f add vsftpd

RUN echo "root:1234" | chpasswd

EXPOSE 21 42000 43000

ENTRYPOINT ["vsftpd", "/etc/vsftpd/vsftpd.conf"]