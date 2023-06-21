#!/bin/bash
update(){
    SERVICE_NAME=$1

    echo "dependency update..."
    cd services/ms-${SERVICE_NAME}
    helm dep update
}

create(){
    SERVICE_NAME=$1
    mkdir -p services/ms-${SERVICE_NAME}

    echo "Creating Chart for service ${SERVICE_NAME}..."
    cp -R templates/*.yaml services/ms-${SERVICE_NAME}/
    sed -i '' -e "s/<SERVICE_NAME>/${SERVICE_NAME}/" services/ms-${SERVICE_NAME}/*.yaml

    update ${SERVICE_NAME}
}

if [ $1 == "create" ]; then
    SERVICE_NAME=$2
    create $SERVICE_NAME
    exit 0
elif [ $1 == "update" ]; then
    SERVICE_NAME=$2
    update $SERVICE_NAME
    exit 0
fi
