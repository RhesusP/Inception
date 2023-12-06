FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install vim software-properties-common mariadb-server mariadb-client -y
# COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# RUN service mariadb start
COPY tools/create_db.sh /create_db.sh
RUN chmod +x /create_db.sh

CMD ["service", "mariadb", "start", "--daemonize"]

# ENTRYPOINT [ "bash", "/create_db.sh" ]

EXPOSE 3306