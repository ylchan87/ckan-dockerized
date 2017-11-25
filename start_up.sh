#!/bin/bash

service postgresql start
service jetty8 start

echo "start"
sleep 20
echo "end"

if [[ $(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='USR_NAME'") ]]
then
    echo "Shell script is hard"
else
    echo "true"
    sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD '12345678';"

    sudo -u postgres psql -c "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';"
    sudo -u postgres psql -c "DROP DATABASE template1;"
    sudo -u postgres psql -c "CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';"
    sudo -u postgres psql -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';"
    sudo -u postgres psql -c "\c template1"
    sudo -u postgres psql -c "VACUUM FREEZE;"

    sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

    ckan db init
fi

echo "hihi"

ckan serve
