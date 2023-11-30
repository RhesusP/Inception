FROM debian:buster

RUN apt update -y && apt upgrade -y
RUN apt install -y vim wget php7.3 php-mysql php-fpm mariadb-client
RUN mkdir -p /var/www
RUN wget https://fr.wordpress.org/wordpress-6.4.1-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzvf wordpress-6.4.1-fr_FR.tar.gz && rm -rf wordpress-6.4.1-fr_FR.tar.gz
RUN chown -R root:root /var/www/wordpress
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mkdir -p /usr/local/bin/wp && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000