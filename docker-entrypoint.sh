#!/bin/bash
set -e


if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing database"
  if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_PASSWORD=changeme
  fi
  /usr/sbin/mysqld --initialize-insecure=on --user=mysql
  /usr/bin/mysqld_safe --skip-networking > /dev/null 2>&1 &
  pid="$!"

  RET=1
  while [[ RET -ne 0 ]]; do
      echo "=> Waiting for confirmation of MySQL service startup"
      sleep 1
      mysql -uroot -e "status" > /dev/null 2>&1
      RET=$?
  done

  # Change root password
  echo "Start change root password"
  mysql -uroot -e "FLUSH PRIVILEGES"
  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
  mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"
  echo "Shutdown process"
  /usr/bin/mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown
  echo "=> Done!"
fi
# start all the services
exec supervisord -n
