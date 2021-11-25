VENV_BIN ?= .venv/bin/
DIRECTORY ?= $(shell pwd)
VENV_LIB ?= $(DIRECTORY)/.venv/lib
# PYTHON_PATH = /usr/lib/python3.6
PYTHON_VERSION ?=
PYTHON_LIB_PATH ?=
PIP_OPTIONS ?= --trusted-host pypi.org --trusted-host files.pythonhosted.org 
PIP_UPDATE = $(VENV_BIN)pip install --upgrade pip setuptools wheel ${PIP_OPTIONS}
PIP_CMD ?= $(VENV_BIN)pip install $(PIP_OPTIONS) -e .

INSTANCE_ID ?=
APACHE_ENTRY_POINT ?= /$(INSTANCE_ID)/
MODWSGI_USER ?= 
PACKAGE ?=

DB_CONNECTION ?=
PNG_ROOT_DIR ?= ./

APACHE_VHOST ?=
APACHE_CONF_DIR ?= /etc/apache2/oereb
APACHE_GRACEFUL ?= sudo /usr/sbin/apachectl graceful

PRERULE_MAKO ?= @echo "Build due to modification on $?"; ls -lt $? || true

.PHONY: help
help:
	@echo  "Usage: make <target>"
	@echo
	@echo  "Main targets:"
	@echo
	@echo  "- build			Build and configure the project"
	@echo  "- templates		Generate the mako templates"
	@echo  "- clean 		Remove generated files"
	@echo  "- cleanall		Remove all the build artefacts"

.PHONY: build
build: .venv/install-timestamp apache

.venv/timestamp:
	virtualenv --python=python3 .venv #   --no-site-packages
	touch $@

.venv/install-timestamp: .venv/timestamp setup.py
	$(PIP_UPDATE)
	$(PIP_CMD)
	touch $@

apache: .venv/apache.timestamp

$(APACHE_CONF_DIR)/$(INSTANCE_ID).conf:
#	echo "NOTE: assuming the apache configuration is already in place! If not, you should manually do something like:"
#	echo "(to be manually run with su rights) Include $(DIRECTORY)/apache/*.conf > $@"
	echo "Include $(DIRECTORY)/apache/*.conf" > $@

.venv/apache.timestamp: \
		$(APACHE_CONF_DIR)/$(INSTANCE_ID).conf \
		apache/application.wsgi \
		apache/wsgi.conf \
		pyramid_oereb.yml
	$(PRERULE_CMD)
	$(APACHE_GRACEFUL)
	touch $@

.PHONY: templates
templates: apache/application.wsgi apache/wsgi.conf pyramid_oereb.yml \
           .venv/apache.timestamp
	.venv/apache.timestamp
	
apache/application.wsgi: apache/application.wsgi.mako
	$(PRERULE_MAKO)
	$(VENV_BIN)mako-render apache/application.wsgi.mako \
            --var "python_version=$(PYTHON_VERSION)" \
            --var "python_lib_path=$(PYTHON_LIB_PATH)" \
	    --var "venv_lib=$(VENV_LIB)" \
	    --var "directory=$(DIRECTORY)" \
	    > $@

apache/wsgi.conf: apache/wsgi.conf.mako
	$(PRERULE_MAKO)
	$(VENV_BIN)mako-render apache/wsgi.conf.mako \
	    --var "apache_entry_point=$(APACHE_ENTRY_POINT)" \
	    --var "directory=$(DIRECTORY)" \
	    --var "instanceid=$(INSTANCE_ID)" \
	    --var "modwsgi_user=$(MODWSGI_USER)" \
	    > $@

pyramid_oereb.yml: pyramid_oereb.yml.mako
	$(PRERULE_MAKO)
	$(VENV_BIN)python scripts/mako-render.py pyramid_oereb.yml \
	    db_connection=$(DB_CONNECTION) \
	    png_root_dir=${PNG_ROOT_DIR}
	touch $@

.PHONY: clean
clean:
	rm -f apache/application.wsgi
	rm -f apache/wsgi.conf
	rm -f pyramid_oereb.yml
	#echo "NOTE: not automatically removed Apache configuration!! If you want to do that, do:"
	#echo "(to be run manually with su rights) 
	#echo "rm -f $(APACHE_CONF_DIR)/$(INSTANCE_ID).conf"

.PHONY: cleanall
cleanall: clean
	rm -rf .venv
	echo "NOTE: not automatically removed Apache configuration!! If you want to do that, do:"
	echo "(to be run manually with su rights)"
	echo "rm -f $(APACHE_CONF_DIR)/$(INSTANCE_ID).conf"
