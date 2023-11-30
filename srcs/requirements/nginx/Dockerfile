FROM debian:bullseye

RUN apt update -y && apt upgrade -y
# Intall utilities
RUN apt install nginx vim openssl -y
# Create directory to store TSL key and certificate
RUN mkdir -p /etc/nginx/ssl
# Create a self-signed SSL/TLS certificate
# -x509 : certificate type
# -nodes : allow to avoid password
# -out : certificate path
# -keyout : key path
# -subj : allow to avoid prompt
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Rhone-Alpes/L=Lyon/O=42/OU=42Lyon/CN=cbernot.42lyon.fr/UID=cbernot"
# Create directory to store nginx configuration files 
RUN mkdir -p /var/run/nginx

# Copy nginx configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Change permissions on /var/www/html directory to allow nginx to access it
RUN chmod 755 /var/www/html
# Change owner of /var/www/html directory to allow nginx to access it
RUN chown -R www-data:www-data /var/www/html

# Launch nginx service when container is started
CMD ["nginx", "-g", "daemon off;"]