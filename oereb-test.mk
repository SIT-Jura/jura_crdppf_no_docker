DB_CONNECTION ?= postgresql://www_data:www_data@localhost:5432/oereb_v2
PYTHON_VERSION ?= 3.7
PYTHON_LIB_PATH = /usr/lib/python3.7
include oereb-template-makefile.mk
