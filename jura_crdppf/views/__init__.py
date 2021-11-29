# -*- coding: utf-8 -*-
import logging

log = logging.getLogger(__name__)

def includeme(config):

    config.add_static_view('views/static', 'jura_crdppf.views:static', cache_max_age=3600)
