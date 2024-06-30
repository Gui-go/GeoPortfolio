# GIS_template
Template para aplicações em Geographic Information Systems (GIS)








### Github connection with Azure VM:
###### ls -al ~/.ssh
###### ssh-keygen -t rsa -b 4096 -C "guilhermeviegas1993@gmail.com"
###### eval "$(ssh-agent -s)"
###### ssh-add ~/.ssh/id_rsa
###### cat ~/.ssh/id_rsa.pub
##### copy the SSH key to Github
###### ssh -T git@github.com

#### Run docker app: 
###### docker-compose up --build

### Stop docker app:
###### docker-compose down




# WFS - vetorial
# WMS - Raster

docker exec -it database /bin/sh
docker exec -it frontend /bin/sh
docker exec -it geoserver /bin/sh
psql -U user -d mydb -h database