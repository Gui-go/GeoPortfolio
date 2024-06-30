#!/bin/bash

echo "Running util/init/init.sh"
apt update -y
apt upgrade -y
apt install -y docker.io
# systemctl restart docker

# Function to wait for a container to exit
wait_for_container_to_exit() {
    local container="$1"
    echo "Waiting for container $container to exit..." 
    while :; do
        # Check if the container has exited
        if docker ps -a --filter "name=${container}" --filter "status=exited" | grep -q "${container}"; then
            echo "Container ${container} has exited."
            break # Exit the loop
        else
            echo "Container ${container} is still running. Waiting..."
            sleep 5 # Wait for 5 seconds before checking again
        fi
    done
}

echo "Waiting for container {etl} to exit before moving to the next commands:"
wait_for_container_to_exit "etl"

echo "Inserting tables into PostgreSQL:"
docker exec -i database psql -U user -d mydb < "./init/create_table_cities_ivebeen.sql"
docker exec -i database psql -U user -d mydb < "./init/create_table_geopoints.sql"
docker exec -i database psql -U user -d mydb < "./init/create_table_teste.sql"

ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=user password=passwd host=database" -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=wkb_geometry ./gdfe/gdfe.shp
if [ $? -eq 0 ]; then
 echo "ogr2ogr added /gdfe/gdfe.shp into PostgreSQL successfully"
else
 echo "ogr2ogr command failed with exit code $?"
fi



echo "Sending requests to the GeoServer REST API to create workspace, datastore, and layers:"
python3 init/geoserver_init.py




