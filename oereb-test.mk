DB_CONNECTION ?= postgresql://postgres:password@localhost:5432/stage_pyramid_oereb_20211126_1615
PYTHON_VERSION ?= 3.7
PYTHON_LIB_PATH = /usr/lib/python3.7
include oereb-template-makefile.mk
