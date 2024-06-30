#!/usr/bin/python3

import numpy as np
import pandas as pd
import geopandas as gpd
import random

# Function to prepare the data:
def fct_data(
    path_to_data = 'data/rede/',
    CRsystem = 'EPSG:4326'
    ) -> gpd.GeoDataFrame:
    """
    abc
    """

    print("Running fct_data()...")

    # Load the Rede Rodoviária data
    gdf = gpd.read_file(path_to_data)
    gdf = gdf.set_crs(epsg=4674)    #Set the CRS of the GeoDataFrame, specific to Brazil (more precision)
    gdfe = gdf.explode()
    gdfe = gdfe.set_geometry('geometry')
    gdfe = gpd.GeoDataFrame(gdfe, geometry='geometry', crs=CRsystem)

    # Length of each road segment
    gdfe['length'] = gdfe['geometry'].length

    # Generate random weights
    vlow=0; vhigh=1; nv = len(gdfe)
    gdfe['randomWeight'] = [random.uniform(vlow, vhigh) for _ in range(nv)]

    gdfe = gpd.GeoDataFrame(gdfe, geometry="geometry", crs=CRsystem)
    #gdfe.to_csv("data/gdfe/gdfe.csv", index=0, sep=",")
    gdfe.to_file("data/gdfe/gdfe.shp")

    return gdfe


fct_data()

