VENV_BIN ?= .venv/bin/
DIRECTORY ?= $(shell pwd)
VENV_LIB ?= $(DIRECTORY)/.venv/lib
# PYTHON_PATH = /usr/lib/python3.6
PYTHON_VERSION ?=
PYTHON_LIB_PATH ?=
PIP_OPTIONS ?= --trusted-host pypi.org --trusted-host files.pythonhosted.org --extra-index-url https://test.pypi.org/simple
PIP_UPDATE = $(VENV_BIN)pip install --upgrade pip setuptools wheel ${PIP_OPTIONS}
PIP_CMD ?= $(VENV_BIN)pip install $(PIP_OPTIONS) -e .

INSTANCE_ID ?=
MODWSGI_USER ?= 
PACKAGE ?=

DB_CONNECTION ?=
PNG_ROOT_DIR ?= ./

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
build: .venv/install-timestamp templates-timestamp

.venv/timestamp:
	#virtualenv --python=python3 .venv
	python3 -m virtualenv --python=python3.7 .venv
	touch $@

.venv/install-timestamp: .venv/timestamp setup.py
	$(PIP_UPDATE)
	$(PIP_CMD)
	touch $@

templates-timestamp: .venv/templates.timestamp

.venv/templates.timestamp: pyramid_oereb.yml
	touch $@

.PHONY: templates
templates: pyramid_oereb.yml .venv/templates.timestamp 
	.venv/templates.timestamp
	
pyramid_oereb.yml: pyramid_oereb.yml.mako
	$(PRERULE_MAKO)
	$(VENV_BIN)python scripts/mako-render.py pyramid_oereb.yml \
	    db_connection=$(DB_CONNECTION) \
	    png_root_dir=${PNG_ROOT_DIR}
	touch $@

.PHONY: clean
clean:
	rm -f pyramid_oereb.yml

.PHONY: cleanall
cleanall: clean
	rm -rf .venv
