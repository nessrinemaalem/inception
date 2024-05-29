#!/bin/sh
echo "Check for \`mysql\` database..."
# Create mysql database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "=> mysql database doesn't exists, creating one!"

	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
	chown -R mysql:mysql /var/lib/mysql

	echo "=> Done!"
fi
echo "OK!"

echo "Check for \`wordpress\` database..."
# Check if the wordpress database is already created
if [ ! -d "/var/lib/mysql/wordpress" ]; then
	echo "=> Creating wordpress database and basic user configuration..."

	cat << EOF > /tmp/querys_database.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE user='';
DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	chmod 777 /tmp/querys_database.sql
	mysqld --user=mysql --verbose --bootstrap < /tmp/querys_database.sql
	rm -f /tmp/querys_database.sql

	echo "=> Done!"
fi
echo "OK!"

echo "Container now runnig mysqld."
exec mysqld