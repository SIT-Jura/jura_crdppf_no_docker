pyramid_oereb:


  # Here you can set a central proxy which can be used in the application.
  # proxies:
    # http: http://"username":"password"@your_proxy.com:8088
    # https: https://"username":"password"@your_proxy.com:8088

  # The "language" property is a list of all languages supported by this application. It only affects the
  # output of the extract webservice. The default language below and any language specified by a "LANG"
  # parameter in a request of an extract must be in this list to be accepted.
  language:
    - fr

  # The language that should be used by default, if no other language is specified in the request.
  # This has to be one of the languages defined above.
  default_language: fr

  # The "flavour" property is a list of all flavours of data extracts provided by this application.
  # For the moment this only affects the output of the capabilities webservice. In later
  # versions, this will be the place to directly influence the available output formats.
  #
  # Possible flavours are: REDUCED, SIGNED
  # REDUCED:    Means that depending on the cantonal implementation you may be able to select
  #             a defined combination of topics to extract (e.g. only 'federal' topics without
  #             cantonal extensions - and choosing this option, legal provisions are only output
  #             as link.
  # SIGNED:     Is essentially the same as REDUCED, but the extract is certified by the competent
  #             authority
  flavour:
  - REDUCED
  - SIGNED

  print:
    # The pyramid renderer which is used as proxy pass through to the desired service for printable static
    # extract. Here you can define the path to the logic which prepares the output as payload for print
    # service and returns the result to the user.
    # Configuration for MapFish-Print print service
    renderer: pyramid_oereb.contrib.print_proxy.mapfish_print.mapfish_print.Renderer
    # Define whether all geometry data must be included when sending the data to the print service
    with_geometry: False
    # Set an archive path to keep a copy of each generated pdf.
    # pdf_archive_path: /archive
    # The minimum buffer in pixel at 72 DPI between the real estate and the map's border. If your print
    # system draws a margin around the feature (the real estate), you have to set your buffer
    # here accordingly.
    buffer: 10
    # The map size in pixel at 72 DPI (width, height), This is the defined size of a map image
    # (requested in wms urls) inside the static extract. On a pdf report, tha map size will
    # be calculated with the pdf_dpi and the pdf_map_size_millimeters below.
    basic_map_size: [493, 280]
    # The dpi used to calculate the size of the requested map (for pdf export only).
    pdf_dpi: 300
    # The map size (in millimeters) used to calculate the size of the requested map (for pdf export only).
    pdf_map_size_millimeters: [174, 99]
    # Base URL with application of the print server
    #base_url: http://{PRINT_SERVICE_HOST}:{PRINT_SERVICE_PORT}/print/oereb
    base_url: http://localhost:8680/print/oereb
    # Name of the print template to use
    template_name: A4 portrait
    # The headers sent to the print
    headers:
      Content-Type: application/json; charset=UTF-8
      Connection: close
    # Whether to display the RealEstate_SubunitOfLandRegister (Grundbuchkreis) in the pdf extract or not.
    # Default to true.
    display_real_estate_subunit_of_land_register: true
    # Whether to display the Certification section in the pdf extract or not.
    # Default to true
    display_certification: true
    # Group elements of "LegalProvision" and "Hints" with the same "Title.Text" together yes/no
    # Disabled by default.
    group_legal_provisions: false
    # Will make an estimation of the total length of the Table of Content (TOC) and control that the page
    # numbering in the output pdf is consistent with TOC numbering. If it is known that the TOC is very long and
    # could run over more than one page, it is preferred to set this to true. The drawback is that it might need
    # more time to generate the PDF. If set to false, it will assume that only one TOC page exists, and this can
    # lead to wrong numbering in the TOC.
    compute_toc_pages: false
    # Specify any additional URL parameters that the print shall use for WMS calls
    wms_url_params:
      TRANSPARENT: 'true'
      ogcserver: 'Main_PNG'

    # If you want the print to keep some custom URL parameters directly from the reference_wms you have defined,
    # then use the configuration option wms_url_keep_params.
    # In wms_url_keep_params, you can list which URL parameter values should be read from the reference_wms
    # and used by the print.
    # wms_url_keep_params:
    #   - ogcserver
    # Flag to print or not the canton logo
    print_canton_logo: true

  # The "app_schema" property contains only one sub property "name". This is directly related to the database
  # creation process, because this name is used as schema name in the target database. The app_schema holds
  # all application stuff like: addresses, municipalities, real estates, etc.
  # Please note that this is only necessary if you want to use the standard configuration. Normally you don't
  # need to adjust this. Only in the unlikely case of another schema in the same database with the same name
  # you can change it here to avoid name collision. Of course you can configure the application to load this
  # data from elsewhere.
  app_schema:
    law_status_lookup:
      - data_code: inKraft
        transfer_code: inKraft
        extract_code: inForce
      - data_code: AenderungMitVorwirkung
        transfer_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
      - data_code: AenderungOhneVorwirkung
        transfer_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
    document_types_lookup:
      - data_code: Rechtsvorschrift
        transfer_code: Rechtsvorschrift
        extract_code: LegalProvision
      - data_code: GesetzlicheGrundlage
        transfer_code: GesetzlicheGrundlage
        extract_code: Law
      - data_code: Hinweis
        transfer_code: Hinweis
        extract_code: Hint
    name: pyramid_oereb_main
    models: pyramid_oereb.contrib.data_sources.standard.models.main
    db_connection: &main_db_connection
      postgresql://www-data:www-data@localhost:5432/pyramid_oereb

  # Define the SRID which your server is representing. Note: Only one projection system is possible in the
  # application. It does not provide any reprojection nor data in different projection systems. Take care in
  # your importing process! 
  srid: 2056

  # definition of the available geometry types for different checks
  geometry_types:
    point:
      types:
       - Point
       - MultiPoint
    line:
       types:
       - LineString
       - LinearRing
       - MultiLineString
    polygon:
       types:
       - Polygon
       - MultiPolygon
    collection:
        types:
        - GeometryCollection

  # Configuration option for full extract: apply SLD on land register WMS (defaults to true)
  #full_extract_use_sld: true

  # Defines the information of the oereb cadastre providing authority. Please change this to your data. This
  # will be directly used for producing the extract output.
  plr_cadastre_authority:
    # The name of your Office. For instance: Amt für Geoinformation Basel-Landschaft
    name:
        fr: Section du cadastre et de la géoinformation
    # An online link to web presentation of your office. For instance: https://www.geo.bl.ch/
    office_at_web: http://www.jura.ch/scg
    # The street name of the address of your office. For instance: Mühlemattstrasse
    street: Rue des Moulins
    # The street number of the address of your office. For instance: 36
    number: 2
    # The ZIP code of the address of your office. For instance: 4410
    postal_code: 2800
    # The city name of the address of your office. For instance: Liestal
    city: Delémont

  # The processor of the oereb project needs access to real estate data. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the real estate out of an existing
  # database table to avoid imports of this data every time it gets updates you only need to change the model
  # bound to the source. The model must implement the same field names and information as the default model
  # does.
  real_estate:
    plan_for_land_register:
      # WMS URL to query the plan for land register used for all themes pages
      reference_wms:
        fr: https://geo-test.jura.ch/mapserv_proxy?ogcserver=Main_PNG&SERVICE=WMS&REQUEST=GetMap&VERSION=1.3.0&STYLES=default&CRS=EPSG:2056&BBOX=2475000,1065000,2850000,1300000&WIDTH=493&HEIGHT=280&FORMAT=image/png&LAYERS=plan_cadastral_crdppf_pyramid_oereb_page_garde
      layer_index: 0
      layer_opacity: 1.0
    plan_for_land_register_main_page:
      # WMS URL to query the plan for land register specially for static extracts overview page
      reference_wms:
        fr: https://geo-test.jura.ch/mapserv_proxy?ogcserver=Main_PNG&SERVICE=WMS&REQUEST=GetMap&VERSION=1.3.0&STYLES=default&CRS=EPSG:2056&BBOX=2475000,1065000,2850000,1300000&WIDTH=493&HEIGHT=280&FORMAT=image/png&LAYERS=plan_cadastral_crdppf_pyramid_oereb
      layer_index: 0
      layer_opacity: 1.0
    visualisation:
      method: pyramid_oereb.core.hook_methods.produce_sld_content
      # Note: these parameters must fit to the attributes provided by the RealEstateRecord!!!!
      url_params:
        - egrid
      layer:
        name: cad_bien_fonds
      style:
        stroke_opacity: 0.6
        stroke_color: '#e60000'
        stroke_width: 5
    # The real estate must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.real_estate.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the real estate database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.RealEstate

  # The processor of the oereb project needs access to address data. In the standard configuration, this
  # is assumed to be read from a database. Hint: If you want to read the addresses out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  address:
    # The address must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.address.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the address database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Address
        # Alternatively you can use the search service of the GeoAdmin API to look up the real estate by
        # address. Replace the configuration above with the following lines:
        # class: pyramid_oereb.lib.sources.address.AddressGeoAdminSource
        # # Optional referer to use.
        # referer: http://my.referer.ch
        # params:
          # # URL of the GeoAdmin API SearchServer
          # geoadmin_search_api: https://api3.geo.admin.ch/rest/services/api/SearchServer
          # # Origins to use (should be "address" only)
          # origins: address

  # The processor of the oereb project needs access to municipality data. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the municipality out of an existing
  # database table to avoid imports of this data every time it gets updates you only need to change the model
  # bound to the source. The model must implement the same field names and information as default model
  # does.
  municipality:
    # The municipality must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.municipality.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the municipality database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Municipality

  # The extract provides logos. Therefore you need to provide the logos from the database
  # or by a path to these logos. Note: This must be a valid absolute system path available
  # for reading by the user running this server.
  logo_lookups:
    # The logo representing the swiss confederation. You can use it as is because it is provided in this
    # repository, but if you need to change it for any reason: Feel free...
    confederation: ch
    # The logo representing the oereb extract CI. You can use it as is because it is provided in this
    # repository, but if you need to change it for any reason: Feel free...
    oereb: ch.plr
    # The logo representing your canton. Replace with your own logo!
    canton: ju

  # The processor of the oereb project joins the logos. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  logos:
    # The logo images must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.logo.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the logo images database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Logo

   # The processor of the oereb project joins the document type labels. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  document_types:
    # The document type text elements must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.document_types.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the document type texts database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.DocumentTypeText

  # The processor of the oereb project joins the document type labels. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  documents:
    # The document type text elements must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.document.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the document type texts database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Document

  # The processor of the oereb project joins the document type labels. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  offices:
    # The document type text elements must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.office.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the document type texts database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Office

  # The processor of the oereb project needs access to theme data. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the themes out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  theme:
    # The themes must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.theme.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the theme database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Theme

  # The processor of the oereb project needs access to theme document data. In the standard configuration
  # this is assumed to be read from a database. Hint: If you want to read the theme documents out of an existing
  # database table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  theme_document:
    # The theme documents must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.theme_document.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the theme database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.ThemeDocument

  # The processor of the oereb project needs access to glossary data. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the glossary out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  glossary:
    # The glossary must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.glossary.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the glossary database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Glossary

  # The processor of the oereb project needs access to disclaimer data. In the standard
  # configuration this is assumed to be read from a database. Hint: If you want to read the exclusion of
  # liability out of an existing database table to avoid imports of this data every time it gets updates you
  # only need to change the model bound to the source. The model must implement the same field names and
  # information as the default model does.
  disclaimer:
    # The disclaimer must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.disclaimer.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the disclaimer database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.Disclaimer

  # The processor of the oereb project joins the law status labels. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  law_status_labels:
    # The real estate type text elements must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.law_status.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the document type texts database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.LawStatus

  # The processor of the oereb project joins the real estate type labels. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the values out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  real_estate_type:
    lookup:
      - data_code: Liegenschaft
        transfer_code: Liegenschaft
        extract_code: RealEstate
      - data_code: SelbstRecht.Baurecht
        transfer_code: SelbstRecht.Baurecht
        extract_code: Distinct_and_permanent_rights.BuildingRight
      - data_code: SelbstRecht.Quellenrecht
        transfer_code: SelbstRecht.Quellenrecht
        extract_code: Distinct_and_permanent_rights.right_to_spring_water
      - data_code: SelbstRecht.Konzessionsrecht
        transfer_code: SelbstRecht.Konzessionsrecht
        extract_code: Distinct_and_permanent_rights.concession
      - data_code: SelbstRecht.weitere
        transfer_code: SelbstRecht.weitere
        extract_code: Distinct_and_permanent_rights.other
      - data_code: Bergwerk
        transfer_code: Bergwerk
        extract_code: Mineral_rights
    # The real estate type text elements must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.real_estate_type.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the document type texts database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.RealEstateType

  # The processor of the oereb project needs access to general information data. In the standard
  # configuration this is assumed to be read from a database. Hint: If you want to read the general
  # information out of an existing database table to avoid imports of this data every time it gets updates, you
  # only need to change the model bound to the source. The model must implement the same field names and
  # information as the default model does.
  general_information:
    # The general_information must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.general_information.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the general_information database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.GeneralInformation

  # The processor of the oereb project needs access to map layering data. In the standard configuration this
  # is assumed to be read from a database. Hint: If you want to read the map layering out of an existing database
  # table to avoid imports of this data every time it gets updates, you only need to change the model bound to
  # the source. The model must implement the same field names and information as the default model does.
  map_layering:
    # The map layering must have a property source.
    source:
      # The source must have a class which represents the accessor to the source. In this example, it is an
      # already implemented source which reads data from a database.
      class: pyramid_oereb.contrib.data_sources.standard.sources.map_layering.DatabaseSource
      # The necessary parameters to use this class
      params:
        # The connection path where the database can be found
        db_connection: *main_db_connection
        # The model which maps the map layering database table.
        model: pyramid_oereb.contrib.data_sources.standard.models.main.MapLayering

  # The extract is the entry point which binds everything
  # related to data together.
  extract:
    # Information about the official survey (last update and provider) used as a base map in the extract
    base_data:
      methods:
        date: pyramid_oereb.core.hook_methods.get_surveying_data_update_date
        provider:  pyramid_oereb.core.hook_methods.get_surveying_data_provider

    sort_within_themes_method: pyramid_oereb.core.hook_methods.plr_sort_within_themes
    # Example of a specific sorting method:
    # sort_within_themes_method: pyramid_oereb.contrib.plr_sort_within_themes_by_type_code
    # Redirect configuration for type URL. You can use any attribute of the real estate RealEstateRecord
    # (e.g. "{egrid}") to parameterize the URL.
    #redirect: https://geoview.bl.ch/oereb/?egrid={egrid}

  # All PLRs which are provided by this application. This is related to all application behaviour, especially
  # the extract creation process which loops over this list.
  plrs:

  - code: ch.Planungszonen
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: reserved_areas
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis


  - code: ch.Nutzungsplanung
    geometry_type: GEOMETRYCOLLECTION
    # Define the minimal area and length for public law restrictions that should be considered as 'true' restrictions
    # and not as calculation errors (false trues) due to topological imperfections
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: land_use_plans
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis


  - code: ch.ProjektierungszonenNationalstrassen
    geometry_type: MULTIPOLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: motorways_project_planing_zones
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.Laermempfindlichkeitsstufen
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: noise_sensitivity_levels
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis
        
  - code: ch.BaulinienNationalstrassen
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: motorways_building_lines
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.ProjektierungszonenEisenbahnanlagen
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: railways_project_planning_zones
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BaulinienEisenbahnanlagen
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: railways_building_lines
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.ProjektierungszonenFlughafenanlagen
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: airports_project_planning_zones
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BaulinienFlughafenanlagen
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: airports_building_lines
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.Sicherheitszonenplan
    geometry_type: MULTIPOLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: airports_security_zone_plans
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis
    download: https://data.geo.admin.ch/ch.bazl.sicherheitszonenplan.oereb/data.zip

  - code: ch.BelasteteStandorte
    geometry_type: GEOMETRYCOLLECTION
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: contaminated_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BelasteteStandorteMilitaer
    geometry_type: GEOMETRYCOLLECTION
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: contaminated_military_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BelasteteStandorteZivileFlugplaetze
    geometry_type: GEOMETRYCOLLECTION
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: contaminated_civil_aviation_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BelasteteStandorteOeffentlicherVerkehr
    geometry_type: GEOMETRYCOLLECTION
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: contaminated_public_transport_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.Grundwasserschutzzonen
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: groundwater_protection_zones
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.Grundwasserschutzareale
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: groundwater_protection_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.StatischeWaldgrenzen
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: forest_perimeters
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      # wkaltz: changed to fit current extract
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    # wkaltz: changed to fit current extract
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.Waldabstandslinien
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 1.0
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: forest_distance_lines
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.ProjektierungszonenStarkstromanlagen
    geometry_type: MULTIPOLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: nominal_high_voltage_reserved_zones
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch.BaulinienStarkstromanlagen
    geometry_type: LINESTRING
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: true
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: high_voltage_installations_building_lines
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  - code: ch_ju_inventories_archaelogical_paleontological_sites
    geometry_type: POLYGON
    thresholds:
      length:
        limit: 1.0
        unit: 'm'
        precision: 2
      area:
        limit: 1.0
        unit: 'm²'
        precision: 2
      percentage:
        precision: 1
    language: fr
    federal: false
    standard: true
    view_service:
      layer_index: 1
      layer_opacity: 0.75
    source:
      class: pyramid_oereb.contrib.data_sources.standard.sources.plr.DatabaseSource
      params:
        db_connection: *main_db_connection
        model_factory: pyramid_oereb.contrib.data_sources.standard.models.theme.model_factory_string_pk
        schema_name: ch_ju_inventories_archaelogical_paleontological_sites
    hooks:
      get_symbol: pyramid_oereb.contrib.data_sources.standard.hook_methods.get_symbol
      get_symbol_ref: pyramid_oereb.core.hook_methods.get_symbol_ref
    law_status_lookup:
      - data_code: inKraft
        extract_code: inForce
        transfer_code: inKraft
      - data_code: AenderungMitVorwirkung
        extract_code: changeWithPreEffect
        transfer_code: AenderungMitVorwirkung
      - data_code: AenderungOhneVorwirkung
        extract_code: changeWithoutPreEffect
        transfer_code: AenderungOhneVorwirkung
    document_types_lookup:
      - data_code: Rechtsvorschrift
        extract_code: LegalProvision
        transfer_code: Rechtsvorschrift
      - data_code: GesetzlicheGrundlage
        extract_code: Law
        transfer_code: GesetzlicheGrundlage
      - data_code: Hinweis
        extract_code: Hint
        transfer_code: Hinweis

  # The error message returned if an error occurs when requesting a static extract
  # The content of the message is defined in the specification (document "Inhalt und Darstellung des statischen Auszugs")
  static_error_message:
    de: "Ein oder mehrere ÖREB-Themen stehen momentan nicht zur Verfügung. Daher kann kein Auszug erstellt werden. Versuchen Sie es zu einem späteren Zeitpunkt erneut. Wir entschuldigen uns für die Unannehmlichkeiten."
    fr: "Un ou plusieurs thèmes RDPPF sont momentanément indisponibles. L’extrait ne peut donc pas être établi. Veuillez réessayer plus tard. Nous vous prions de nous excuser pour ce désagrément."
    it: "Uno o più temi relativi alle RDPP non sono attualmente disponibili. Non è pertanto possibile allestire alcun estratto. Vi preghiamo di riprovare più tardi. Ci scusiamo per l’inconveniente."
