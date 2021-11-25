#
# The Apache mod_wsgi configuration file.
#
# We use mod_wsgi's daemon mode. And we assign a specific process
# group to the WSGI application.
#
# Note: once we use mod_wsgi 3 we'll be able to get rid of the
# Location block by passing process-group and application-group
# options to the WSGIScriptAlias directive.
#


# define a process group
WSGIDaemonProcess oereb:${instanceid} display-name=%{GROUP} user=${modwsgi_user} home=${directory} python-home=${directory}/.venv

# define the path to the WSGI app
WSGIScriptAlias /${instanceid}/wsgi ${directory}/apache/application.wsgi

# assign the WSGI app instance the process group defined aboven, we put the WSGI
# app instance in the global application group so it is always executed within
# the main interpreter
<Location /${instanceid}/wsgi>
    WSGIProcessGroup oereb:${instanceid}
    WSGIApplicationGroup %{GLOBAL}

    SetEnvIf x-forwarded-proto https HTTPS=1

    Require all granted
</Location>
