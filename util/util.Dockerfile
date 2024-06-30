FROM ubuntu:24.04

# WORKDIR /app

# COPY /init/ /init

RUN apt update -y
RUN apt install -y gdal-bin libgdal-dev
RUN apt install python3-pip -y
RUN apt install postgresql-client -y
RUN pip install --upgrade pip --break-system-packages
# RUN apt install python3-full -y
RUN apt install python3 -y
RUN pip install --upgrade pip --break-system-packages
COPY /init/requirements.txt /init/requirements.txt
RUN pip install -r init/requirements.txt --break-system-packages
COPY /init/ /init
COPY /gdfe/ /gdfe
RUN chmod +x init/init.sh
RUN ls -a

CMD ["sh", "init/init.sh"]
