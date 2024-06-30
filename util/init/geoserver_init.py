import requests
import time

# Parameters:
ws_name = "ws1"
ds_name = "ds1"
layer_name1 = "cities_ivebeen"
layer_name2 = "geopoints"
layer_name3 = "teste"
layer_name4 = "gdfe"
db_host = "database"
db_port = "5432"
db_name = "mydb"
db_user = "user"
db_passwd = "passwd"
auth = ('admin', 'geoserver')

# GeoServer REST API endpoints:
base_url = 'http://geoserver:8080/geoserver/rest'
workspace_url = f'{base_url}/workspaces'
datastore_url = f'{base_url}/workspaces/{ws_name}/datastores'
featuretype_url = f'{base_url}/workspaces/{ws_name}/datastores/{ds_name}/featuretypes'

# Function to check if GeoServer is ready:
def is_geoserver_ready():
    try:
        response = requests.get(base_url, auth=auth)
        return response.status_code == 200
    except requests.exceptions.RequestException:
        return False

# Wait for GeoServer to be ready:
max_retries = 20
retry_interval = 5
retry_count = 0

while not is_geoserver_ready() and retry_count < max_retries:
    print("Waiting for GeoServer to be ready...")
    time.sleep(retry_interval)
    retry_count += 1
if not is_geoserver_ready():
    print("Max retries exceeded. Unable to connect to GeoServer.")
else:
    workspace_data = f'<workspace><name>{ws_name}</name></workspace>'
    response_workspace = requests.post(workspace_url, data=workspace_data, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{ws_name} Workspace Creation Status Code: {response_workspace.status_code}')
    # print(f'{ws_name} Creation Workspace Response: {response_workspace.text}')

    # Create a PostGIS data store
    datastore_data = f'''
    <dataStore>
        <name>{ds_name}</name>
        <connectionParameters>
            <host>{db_host}</host>
            <port>{db_port}</port>
            <database>{db_name}</database>
            <user>{db_user}</user>
            <passwd>{db_passwd}</passwd>
            <dbtype>postgis</dbtype>
        </connectionParameters>
    </dataStore>
    '''
    response_datastore = requests.post(datastore_url, data=datastore_data, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{ds_name} Data Store Creation Status Code: {response_datastore.status_code}')

    # Create a new layer
    layer_data1 = f'''
    <featureType>
        <name>{layer_name1}</name>
        <nativeName>{layer_name1}</nativeName>
        <title>{layer_name1}</title>
        <srs>EPSG:4326</srs>
        <nativeBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </nativeBoundingBox>
        <latLonBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </latLonBoundingBox>
        <projectionPolicy>FORCE_DECLARED</projectionPolicy>
    </featureType>
    '''
    response1 = requests.post(featuretype_url, data=layer_data1, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{layer_name1} Layer Creation Status Code: {response1.status_code}')

    # Create a new layer
    layer_data2 = f'''
    <featureType>
        <name>{layer_name2}</name>
        <nativeName>{layer_name2}</nativeName>
        <title>{layer_name2}</title>
        <srs>EPSG:4326</srs>
        <nativeBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </nativeBoundingBox>
        <latLonBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </latLonBoundingBox>
        <projectionPolicy>FORCE_DECLARED</projectionPolicy>
    </featureType>
    '''
    response2 = requests.post(featuretype_url, data=layer_data2, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{layer_name2} Layer Creation Status Code: {response2.status_code}')

    # Create a new layer
    layer_data3 = f'''
    <featureType>
        <name>{layer_name3}</name>
        <nativeName>{layer_name3}</nativeName>
        <title>{layer_name3}</title>
        <srs>EPSG:4336</srs>
        <nativeBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </nativeBoundingBox>
        <latLonBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </latLonBoundingBox>
        <projectionPolicy>FORCE_DECLARED</projectionPolicy>
    </featureType>
    '''
    response3 = requests.post(featuretype_url, data=layer_data3, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{layer_name3} Layer Creation Status Code: {response3.status_code}')

    # Create a new layer
    layer_data4 = f'''
    <featureType>
        <name>{layer_name4}</name>
        <nativeName>{layer_name4}</nativeName>
        <title>{layer_name4}</title>
        <srs>EPSG:4336</srs>
        <nativeBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </nativeBoundingBox>
        <latLonBoundingBox>
            <minx>-180.0</minx>
            <maxx>180.0</maxx>
            <miny>-90.0</miny>
            <maxy>90.0</maxy>
        </latLonBoundingBox>
        <projectionPolicy>FORCE_DECLARED</projectionPolicy>
    </featureType>
    '''
    response4 = requests.post(featuretype_url, data=layer_data4, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'{layer_name4} Layer Creation Status Code: {response4.status_code}')

    # Publish the layer
    publish_data = f'<task><operation>generate</operation><data><layer>{featuretype_url}</layer></data></task>'
    response_publish = requests.post(featuretype_url, data=publish_data, headers={'Content-type': 'text/xml'}, auth=auth)
    print(f'Publish Layer Status Code: {response_publish.status_code}')

print("GeoServer is ready!")




