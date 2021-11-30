DB_CONNECTION ?= postgresql://www-data:www-data@localhost:5432/pyramid_oereb
PYTHON_VERSION ?= 3.7
PYTHON_LIB_PATH = /usr/lib/python3.7
include oereb-template-makefile.mk
