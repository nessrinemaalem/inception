FROM debian:buster

# install MariaDB and other dependencies
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y mariadb-server
RUN apt install -y mariadb-client
RUN apt install -y procps

# copy the provided config file to the container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN chown mysql:mysql /var/run/mysqld/
RUN chmod -R 755 /var/run/mysqld/
RUN chown mysql:mysql /var/lib/mysql/
RUN chmod -R 755 /var/lib/mysql/

RUN chmod 755 /etc/mysql/my.cnf

EXPOSE 3306

COPY ./tools/dbscript.sh ./
RUN chmod +x ./dbscript.sh

ENTRYPOINT ["bash", "./dbscript.sh"]
