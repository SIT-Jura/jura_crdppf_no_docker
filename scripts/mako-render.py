#!/usr/bin/python
# -*- coding: utf-8 -*-

# Tranforms one mako with the given remplacement variable.
# Example:python ./scripts/mako-render.py my_folder/my_file_without_mako paramA=foo paramB=bar

from sys import argv
from mako.template import Template

file=argv[1]
params=argv[2:]

# print("Render {file} with params {params}".format(file=file, params=params))
template = Template(filename='{file}.mako'.format(file=file), input_encoding='utf-8', output_encoding='utf-8')

render_arguments = dict()
for param in params:
    ra = param.split('=')
    render_arguments[ra[0]] = ra[1]

# note: for python3, need to explicitly open file as "binary"
with open(file,'wb') as f:
    f.write(template.render(**render_arguments))
