FROM alpine:3.11.3

COPY init.sh .

RUN apk add --update mysql mysql-client

RUN mkdir -p app/mysql
RUN mkdir auth_pam_tool_dir && mkdir auth_pam_tool_dir/auth_pam_tool

COPY my.cnf /etc/mysql/my.cnf
COPY my.cnf /etc/my.cnf

EXPOSE 3306

ENTRYPOINT ["sh", "init.sh"]