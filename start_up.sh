#!/bin/bash

source /usr/lib/ckan/default/bin/activate
paster --plugin=ckanext-issues issues init_db -c ckan.ini

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

python -c 'import sys; print(sys.prefix)'

a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod xml2enc
a2enmod ssl
service apache2 restart

ckan serve
