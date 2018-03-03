#!/bin/bash

source /usr/lib/ckan/default/bin/activate

# service postgresql start
service jetty8 start

sleep 10

if [[ $(sudo -u postgres psql -h postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='USR_NAME'") ]]
then
    echo ""
else
    # echo "true"
    # sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'example';"

    # sudo -u postgres psql -c "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';"
    # sudo -u postgres psql -c "DROP DATABASE template1;"
    # sudo -u postgres psql -c "CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';"
    # sudo -u postgres psql -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';"
    # sudo -u postgres psql -c "\c template1"
    # sudo -u postgres psql -c "VACUUM FREEZE;"

    # sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

    ckan db init
fi

# Need this so that dataset will appear after container removal
paster --plugin=ckan search-index rebuild -c /etc/ckan/default/production.ini

ckan serve
