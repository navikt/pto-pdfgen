#!/bin/bash

CURRENT_PATH="$(pwd)"
PDFGEN_VERSION=2.0.97

# Legg til for debug: -e JDK_JAVA_OPTIONS \

docker pull ghcr.io/navikt/pdfgen:$PDFGEN_VERSION
docker run \
        -v $CURRENT_PATH/templates:/app/templates \
        -v $CURRENT_PATH/fonts:/app/fonts \
        -v $CURRENT_PATH/data:/app/data \
        -v $CURRENT_PATH/resources:/app/resources \
        -p 8081:8080 \
        -e DISABLE_PDF_GET=false \
        -e DEV_MODE=true \
        -e JDK_JAVA_OPTIONS \
        -it \
        --rm \
        ghcr.io/navikt/pdfgen:$PDFGEN_VERSION
