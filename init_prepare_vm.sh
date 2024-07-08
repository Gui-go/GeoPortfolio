#!/bin/bash

init_prepare_vm() {
    local public_ip="$1"
    local storage_account_key="$2"
    local github_token="$3"

    echo 'Update and upgrade:'
    sudo apt update -y
    sudo apt upgrade -y

    echo 'Install docker and docker-compose:'
    sudo apt install docker -y
    sudo apt install docker-compose -y

    sudo apt install nginx-full 

    echo 'Install additional packages:'
    sudo apt install unzip

    echo 'Install azure-cli:'
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    sudo apt update
    sudo apt install azure-cli
    sudo ls -la /home/useradmin/.azure
    sudo chown -R useradmin:useradmin /home/useradmin/.azure
    sudo chmod -R 700 /home/useradmin/.azure

    echo 'Create vars:'
    echo "export public_ip=$public_ip" >> ~/.bashrc
    echo "storage_account_key=$storage_account_key" >> ~/.bashrc
    echo "github_token=$github_token" >> ~/.bashrc

    echo 'Git clone the repo:'
    git clone https://$github_token:x-oauth-basic@github.com/project-proj/project.git

    #echo 'Download rede.zip data from Azure storage:'
    mkdir -p ~/GIS_template/etl/data/
    #sudo az storage blob download --container-name data --file ~/GIS_template/etl/data/rede.zip --name 'rede.zip' --account-key $storage_account_key --account-name baitatec
    #sudo unzip ~/GIS_template/etl/data/rede.zip -d ~/GIS_template/etl/data/
    
    # sudo az storage blob download --container-name gisbaitatec --file ~/GIS_template/etl/data/acidentes.zip --name 'acidentes.zip' --account-key $storage_account_key --account-name baitatec
    # sudo unzip ~/GIS_template/etl/data/acidentes.zip -d ~/GIS_template/etl/data/
    # sudo az storage blob download --container-name gisbaitatec --file ~/GIS_template/etl/data/roubos.zip --name 'roubos.zip' --account-key $storage_account_key --account-name baitatec
    # sudo unzip ~/GIS_template/etl/data/roubos.zip -d ~/GIS_template/etl/data/
    # sudo az storage blob download --container-name gisbaitatec --file ~/GIS_template/etl/data/rodoviasBR2014.zip --name 'rodoviasBR2014.zip' --account-key $storage_account_key --account-name baitatec
    # sudo unzip ~/GIS_template/etl/data/rodoviasBR2014.zip -d ~/GIS_template/etl/data/

    echo 'Replace variables:'
    sed -i "s/{{PUBLIC_IP}}/$public_ip/g" ~/GIS_template/frontend/init/nginx.conf
    sed -i "s/{{PUBLIC_IP}}/$public_ip/g" ~/GIS_template/frontend/web/index.html

}

# Call function:
init_prepare_vm "$1" "$2" "$3"

