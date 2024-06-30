#!/bin/bash

# Function to check if PostgreSQL is ready
is_postgres_ready() {
  pg_isready -h database -U user -d mydb -q
}

# Wait for PostgreSQL to be ready
until is_postgres_ready; do
  echo "PostgreSQL is not ready yet. Waiting..."
  sleep 5
done
echo "PostgreSQL is ready now."

# Run etl.py to get the data transformed in Python:
mkdir -p data/gdfe/
chmod +x init/etl.py
python3 init/etl.py
echo "etl.py done"

# # Insert gdfe.shp into Postgres:
# # ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=user password=passwd host=database" -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=wkb_geometry ./data/rede/rede.shp
# ogr2ogr -f "PostgreSQL" PG:"dbname=mydb user=user password=passwd host=database" -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=wkb_geometry ./data/gdfe/gdfe.shp
# if [ $? -eq 0 ]; then
#  echo "ogr2ogr added data/gdfe/gdfe.shp into PostgreSQL successfully"
# else
#  echo "ogr2ogr command failed with exit code $?"
# fi

