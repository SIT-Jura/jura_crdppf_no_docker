import pyramid_oereb
import yaml
from pyramid.config import Configurator


def main(_, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    # Read and update settings for oereb client
    settings = config.get_settings()
    with open(settings.get('oereb_client.cfg'), encoding='utf-8') as f:
        settings.update({
            'oereb_client': yaml.load(f.read()).get('oereb_client')
        })

    # Include pyramid_oereb back-end configuration
    config.include('pyramid_oereb', route_prefix='oerebv2')
    # Including oereb_client configuration
    config.include('oereb_client', route_prefix='oerebv2')
    config.include('jura_crdppf.views', route_prefix='oerebv2')

    config.scan()
    return config.make_wsgi_app()
