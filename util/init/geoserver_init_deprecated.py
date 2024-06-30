from geo.Geoserver import Geoserver

geo = Geoserver('http://geoserver:8080/geoserver/rest', username='admin', password='geoserver')

geo.create_workspace(workspace='demo444')

# # For uploading raster data to the geoserver
# geo.create_coveragestore(layer_name='layer1', path=r'path\to\raster\file.tif', workspace='demo')

# # For creating postGIS connection and publish postGIS table
# geo.create_featurestore(store_name='geo_data', workspace='demo', db='postgres', host='localhost', pg_user='postgres',
#                         pg_password='admin')
# geo.publish_featurestore(workspace='demo', store_name='geo_data', pg_table='geodata_table_name')

# # For uploading SLD file and connect it with layer
# geo.upload_style(path=r'path\to\sld\file.sld', workspace='demo')
# geo.publish_style(layer_name='geoserver_layer_name', style_name='sld_file_name', workspace='demo')

# # For creating the style file for raster data dynamically and connect it with layer
# geo.create_coveragestyle(raster_path=r'path\to\raster\file.tiff', style_name='style_1', workspace='demo',
#                          color_ramp='RdYiGn')
# geo.publish_style(layer_name='geoserver_layer_name', style_name='raster_file_name', workspace='demo')

# # delete workspace
# geo.delete_workspace(workspace='demo')

# # delete layer
# geo.delete_layer(layer_name='agri_final_proj', workspace='demo')

# # delete style file
# geo.delete_style(style_name='kamal2', workspace='demo')
