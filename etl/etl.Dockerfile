FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y postgresql-client
RUN apt install -y gdal-bin

COPY data/ data/
COPY init/ init/

RUN apt update -y
RUN apt install python3-pip -y
RUN pip install --upgrade pip --break-system-packages
RUN apt install python3 -y
RUN pip install -r init/requirements.txt --break-system-packages
# RUN chmod +x init/etl.py
# RUN python3 init/etl.py


RUN chmod +x init/init.sh
CMD ["sh", "init/init.sh"]
