#!/bin/bash

CURRENT_PATH="$(pwd)"
PDFGEN_VERSION=2.0.72

# Legg til for debug: -e JDK_JAVA_OPTIONS \

docker pull europe-north1-docker.pkg.dev/nais-management-233d/pdfgen/pdfgen:$PDFGEN_VERSION
docker run \
        -v $CURRENT_PATH/templates:/app/templates \
        -v $CURRENT_PATH/fonts:/app/fonts \
        -v $CURRENT_PATH/data:/app/data \
        -p 8081:8080 \
        -e DISABLE_PDF_GET=false \
        -e JDK_JAVA_OPTIONS \
        -it \
        --rm \
        europe-north1-docker.pkg.dev/nais-management-233d/pdfgen/pdfgen:$PDFGEN_VERSION
