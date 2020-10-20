#!/bin/bash

CURRENT_PATH="$(pwd)"
PDFGEN_VERSION=72efbbafa20fb858d206894de67ae077876a9cc2

docker pull navikt/pdfgen:$PDFGEN_VERSION
docker run \
        -v $CURRENT_PATH/templates:/app/templates \
        -v $CURRENT_PATH/fonts:/app/fonts \
        -v $CURRENT_PATH/resources:/app/resources \
        -v $CURRENT_PATH/data:/app/data \
        -p 8081:8080 \
        -e DISABLE_PDF_GET=false \
        -it \
        --rm \
        navikt/pdfgen:$PDFGEN_VERSION
