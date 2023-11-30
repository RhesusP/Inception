FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install vim mariadb-server -y
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/create_db.sh /create_db.sh

ENTRYPOINT [ "bash", "create_db.sh" ]

EXPOSE 3306