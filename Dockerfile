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

# Use custom solr schema for Chinese search support
RUN mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
COPY schema.xml /etc/solr/conf/schema.xml

# Setup plugin
WORKDIR /usr/lib/ckan/default/src/
RUN /bin/bash -c "git clone https://github.com/ylchan87/ckanext-landdbcustomize.git"
WORKDIR /usr/lib/ckan/default/src/ckanext-landdbcustomize/
RUN /bin/bash -c "git checkout tags/0.0.2"
RUN /bin/bash -c "source /usr/lib/ckan/default/bin/activate;python setup.py develop"

# Set back workdir so taht start_up.sh can run
WORKDIR /
