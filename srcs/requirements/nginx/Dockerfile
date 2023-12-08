FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install nginx vim openssl -y
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -newkey rsa:4096 -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Rhone-Alpes/L=Lyon/O=42/OU=42Lyon/CN=cbernot.42.fr/UID=cbernot"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chown -R root:root /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]