INSTANCE_ID ?= oereb
PACKAGE ?= jura_crdppf

# Database configuration properties - OVERRIDE IN CONCRETE MAKEFILE
DB_CONNECTION ?= 

# Webserver configuration properties
APACHE_CONF_DIR ?= /etc/apache2/conf-enabled
MODWSGI_USER ?= www-data
APACHE_GRACEFUL ?= sudo /usr/sbin/apachectl graceful

include Makefile
