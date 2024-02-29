#!/bin/bash

CURRENT_PATH="$(pwd)"
PDFGEN_VERSION=2.0.21

# Legg til for debug: -e JDK_JAVA_OPTIONS \

docker pull ghcr.io/navikt/pdfgen:$PDFGEN_VERSION
docker run \
        -v $CURRENT_PATH/templates:/app/templates \
        -v $CURRENT_PATH/fonts:/app/fonts \
        -v $CURRENT_PATH/data:/app/data \
        -v $CURRENT_PATH/resources:/app/resources \
        -v $CURRENT_PATH/logback-local-test.xml:/app/logback-local-test.xml \
        -p 8081:8080 \
        -e JDK_JAVA_OPTIONS='-Dlogback.configurationFile=logback-local-test.xml' \
        -e DISABLE_PDF_GET=false \
        -e JDK_JAVA_OPTIONS \
        -it \
        --rm \
        ghcr.io/navikt/pdfgen:$PDFGEN_VERSION
