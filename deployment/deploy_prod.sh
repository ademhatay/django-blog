#!/bin/sh

cd django-blog
git pull
source env/bin/activate
pip install -r requirements.txt
./manage.py makemigrations
./manage.py migrate --run-syncdb
sudo service gunicorn restart
sudo service nginx restart
