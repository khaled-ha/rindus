#!/bin/sh

# Before PostgreSQL can function correctly, the database cluster must be initialized:
initdb -D /var/lib/postgres/data

# internal start of server in order to allow set-up using psql-client
# does not listen on external TCP/IP and waits until start finishes
pg_ctl -D "/var/lib/postgres/data" -o "-c listen_addresses='*'" -w start

# create a user or role
psql -d postgres -c "CREATE USER martial_user WITH PASSWORD 'martial_password';"

# create database
psql -v ON_ERROR_STOP=1 -d postgres -c "CREATE DATABASE martial_db OWNER 'martial_user';"

# stop internal postgres server
pg_ctl -v ON_ERROR_STOP=1 -D "/var/lib/postgres/data" -m fast -w stop

if [ "$DATABASE" = "martial_db" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

#python manage.py flush --no-input
python manage.py migrate
python manage.py collectstatic --no-input --clear

exec "$@"
