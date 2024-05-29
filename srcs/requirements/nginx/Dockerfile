FROM debian:buster

RUN apt update -y
RUN apt install -y nginx
RUN apt install -y vim
RUN apt install -y curl
RUN mkdir -p /etc/nginx/ssl/
RUN apt install -y openssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=imaalem/CN=imaalem.42.f/UID=imaalem"

RUN mkdir -p /var/run/nginx
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off ;"]

