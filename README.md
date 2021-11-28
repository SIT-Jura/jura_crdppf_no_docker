# jura_crdppf_no_docker
Debugging environment for jura_crdppf

To set up debugging:
* start a database server, for example as follows:

mkdir ~/db

edit ./bash_aliases, add this:

alias localdb='docker run --rm --name=local_db --env=POSTGRES_PASSWORD=password --env=POSTGRES_USER=postgres --env=POSTGRES_DB=postgres --env=PGPASSWORD=www-data --env=PGUSER=www-data --env=PGDATABASE=geomapfish --detach --volume $HOME/db/DB:/var/lib/postgresql/data --publish=5432:5432 camptocamp/postgres:12-postgis-3'

Then run source ~/.bash_aliases

* connect to database server and create a database:

psql --host localhost --port 5432 --user postgres

create database test_jura;

\c test_jura

create extension postgis;

create user "www-data";

alter user "www-data" with password 'www-data';

Then import a database dump from Jura:

pg_restore --host localhost --user postgres -d test_jura <the-dump-file-from-jura>

Then start application server with pserve:
  
make -f oereb-test.mk build
  
source .venv/bin/activate 

pserve production.ini

Then in a separate terminal try a versions request:
curl localhost:6543/oereb/versions/json
