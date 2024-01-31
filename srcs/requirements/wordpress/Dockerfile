FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y ca-certificates apt-transport-https software-properties-common wget curl lsb-release
RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x 
RUN apt-get update -y
RUN apt-get install -y vim php8.3 php-mysql php-fpm mariadb-client

WORKDIR /var/www
RUN wget https://fr.wordpress.org/wordpress-6.4.1-fr_FR.tar.gz
RUN tar -xzf wordpress-6.4.1-fr_FR.tar.gz && rm -rf wordpress-6.4.1-fr_FR.tar.gz
RUN chown -R root:root /var/www/wordpress
COPY conf/www.conf /etc/php/8.3/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN php wp-cli.phar --info
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/wp_config.sh /var/www/wp_config.sh
RUN chmod +x /var/www/wp_config.sh
RUN mkdir -p /var/run/php

RUN chown -R www-data:www-data /var/www/wordpress
RUN chmod -R 755 /var/www/wordpress

ENTRYPOINT ["bash", "/var/www/wp_config.sh"]

EXPOSE 9000
