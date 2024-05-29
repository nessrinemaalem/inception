FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y php7.3 php7.3-fpm php7.3-mysql php7.3-common\
					   mariadb-client wget sendmail

# The installation of wordpress is done with WP-CLI (https://wp-cli.org/fr/)
# https://make.wordpress.org/cli/handbook/guides/installing/
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Create the folder of the website and give www-data access to it
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Modifying php config files
# Modify the listen port to 9000 and uncomment the 'clear_env' line to avoid problem with our environment
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Move the config script in the docker
COPY tools/wpscript.sh /var/www/wpscript.sh
RUN chmod +x /var/www/wpscript.sh

WORKDIR /var/www/html
EXPOSE 9000

CMD ["/var/www/wpscript.sh"]