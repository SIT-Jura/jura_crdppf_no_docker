import site
import sys
import re

# We want to make sure we are using venv packages only. 
#
print("*** OEREB application integration: sys.prefix {}".format(sys.prefix))
print("*** OEREB application integration: sys.path before transformation {}".format(sys.path))
sys.path = ['${directory}', '${python_lib_path}/lib-dynload', '${venv_lib}/python${python_version}/site-packages', '${python_lib_path}']
print("*** OEREB application integration: sys.path after transformation {}".format(sys.path))

from pyramid.paster import get_app, setup_logging

configfile = "${directory}/production.ini"
setup_logging(configfile)
application = get_app(configfile, 'main')
