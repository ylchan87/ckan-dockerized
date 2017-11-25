FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y sudo \
    wget \
    nginx \
    apache2 \
    libapache2-mod-wsgi \
    libpq5 \
    redis-server \
    git-core \
    postgresql \
    solr-jetty

RUN wget http://packaging.ckan.org.s3-eu-west-1.amazonaws.com/python-ckan_2.7-xenial_amd64.deb

RUN dpkg -i python-ckan_2.7-xenial_amd64.deb

RUN mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
RUN ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml