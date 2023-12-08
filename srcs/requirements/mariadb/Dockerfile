FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install vim software-properties-common mariadb-server -y
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/create_db.sh /create_db.sh
RUN chmod +x /create_db.sh

ENTRYPOINT [ "bash", "/create_db.sh" ]

EXPOSE 3306