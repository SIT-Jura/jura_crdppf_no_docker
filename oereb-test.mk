DB_CONNECTION ?= postgresql://postgres:password@localhost:5432/dump_wkaltz_20211127
PYTHON_VERSION ?= 3.8
PYTHON_LIB_PATH = /usr/lib/python3.8
include oereb-template-makefile.mk
