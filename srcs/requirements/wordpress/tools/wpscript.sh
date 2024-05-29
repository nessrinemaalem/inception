#!/bin/bash

# set -eux

echo "Waiting 10 seconds before starting initialization script..."
sleep 10

# Avoid PHP running problems
if [ ! -d "/run/php" ]; then
	mkdir -p /run/php
	touch /run/php/php7.3-fpm.pid
fi

echo "Checking for wordpress installation..."
# Download wordpress if isn't already done
if [ ! -f "wp-config-sample.php" ]; then
	echo "=> Downloading wordpress..."
	wp core download --allow-root
	echo "=> Done!"
fi
echo "OK!"

echo "Checking for wordpress configuration..."
# Check if the configuration of wordpress is already done, if not, start the configuration and installation
# https://make.wordpress.org/cli/handbook/how-to/how-to-install/
if [ ! -f "wp-config.php" ]; then
	echo "=> Create config file..."
	wp config create --dbname=$SQL_DATABASE \
					 --dbuser=$SQL_USER \
					 --dbpass=$SQL_PASSWORD \
					 --dbhost=mariadb:3306 --path='/var/www/html' \
					 --allow-root
	echo "=> Done!"

	echo "=> Installing wordpress..."
	wp core install --url="imaalem.42.fr" \
					--title="Inception" \
					--admin_user=$ADMIN_USER \
					--admin_password=$ADMIN_PASSWORD \
					--admin_email=$ADMIN_EMAIL \
					--allow-root
	echo "=> Done!"
fi
echo "OK!"

echo "Checking for user configuration..."
# Create another user (admin user already exists thanks to the wp core install)
# https://developer.wordpress.org/cli/commands/user/
if [[ -z $(wp user get $USER1_LOGIN --allow-root) ]]; then
	echo "=> Creating new user ($USER1_LOGIN)"
	wp user create $USER1_LOGIN $USER1_MAIL \
				   --user_pass=$USER1_PASS \
				   --allow-root
	echo "=> Done!"
fi
echo "OK!"

echo "Container now running php-fpm."
/usr/sbin/php-fpm7.3 -F -R
