## Setup Guide

1. Install Docker https://docs.docker.com/install/ (Docker CE)

2. Install docker-compose https://docs.docker.com/compose/install/#install-compose

3. Install git (`apt-get install git` on ubuntu)

4. Clone this repository (`git clone git@github.com:yulapshun/ckan-dockerized.git`)

5. cd into directory

6. `cp env-example .env`

7. Edit .env specifically update CKAN_SITE_URL if necessary

8. Edit docker-compose.yml specifically update posrts section if necessary

9. docker-compose up -d

## Commands

1. Stop server: `docker-compose stop`

2. Start shell inside docker container: `docker exec -it ckandockerized_ckan_1 bash`

## Commands inside container

1. Activate virtualenv: `. /usr/lib/ckan/default/bin/activate`

2. Set user as admin: `paster --plugin=ckan sysadmin add [username] -c /etc/ckan/default/production.ini`

## Plugin

1. `ckanext-customschema`, add custom fields in this file (start_date, end_date, last_update_date) currently not used

2. `ckanext-landdbcustomize`, add custom fields and tag vocab

## Develop

1. Write your own ckan extension, or fork 'ylchan87/ckanext-landdbcustomize'

2. Edit Dockerfile to git clone your plugin then install it

3. Edit production.ini to include your plugin in ckan

## Import data
Import data is unfinished, please update import.py

1. Change `http://localhost:5000/api/action/package_create` to the correct public url

2. Change `630de8f5-5c84-463c-9de2-3afefa10ce0d` to API key of an admin user, which can be get from ckan website

3. Data is stored in `sample_data.csv`

4. CSV can be exported in google spreadsheet

## Current issues

1. Tags are not created in import.py (refer to http://docs.ckan.org/en/latest/maintaining/tag-vocabularies.html for HOWTO)

2. Nested categorization (分層) not implemented
