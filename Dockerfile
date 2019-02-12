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

RUN apt-get install -y vim

RUN wget http://packaging.ckan.org.s3-eu-west-1.amazonaws.com/python-ckan_2.7-xenial_amd64.deb
RUN dpkg -i python-ckan_2.7-xenial_amd64.deb

#RUN wget http://packaging.ckan.org/python-ckan_2.8-xenial_amd64.deb
#RUN dpkg -i ./python-ckan_2.8-xenial_amd64.deb

# Use custom solr schema for Chinese search support
RUN mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
COPY schema.xml /etc/solr/conf/schema.xml

COPY ckan_default.conf /etc/apache2/sites-available/ckan_default.conf
COPY ports.conf /etc/apache2/ports.conf

#patch multilingual plugin
WORKDIR /usr/lib/ckan/default/src/ckan/ckanext/multilingual
RUN mv plugin.py plugin.py.bak
COPY multilingual_plugin_patched.py plugin.py

#patch datapusher plugin
WORKDIR /usr/lib/ckan/datapusher/lib/python2.7/site-packages/ckanserviceprovider/
COPY datapusher.patch ./datapusher.patch
RUN patch < datapusher.patch

# Setup plugin
# ---------------------------------------------------------
# use fixed tag plugin from github
WORKDIR /usr/lib/ckan/default/src/
RUN /bin/bash -c "git clone https://github.com/ylchan87/ckanext-landdbcustomize.git " 
WORKDIR /usr/lib/ckan/default/src/ckanext-landdbcustomize/
RUN /bin/bash -c "git checkout tags/0.0.7"
RUN /bin/bash -c "source /usr/lib/ckan/default/bin/activate;python setup.py develop"

# to use local mapped vol for dev instead, edit startup.sh plus docker_compose.yml
# ---------------------------------------------------------

RUN /bin/bash -c "source /usr/lib/ckan/default/bin/activate;pip install -e git+http://github.com/ckan/ckanext-issues#egg=ckanext-issues"
RUN /bin/bash -c "source /usr/lib/ckan/default/bin/activate;pip install ckanext-deadoralive"

# Set back workdir so taht start_up.sh can run
WORKDIR /
