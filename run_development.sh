#!/bin/bash

CURRENT_PATH="$(pwd)"
PDFGEN_VERSION=d84f2a198a1b05af62b87ce994f0a23e22260bca

# Legg til for debug: -e JAVA_OPTS='-Dlogback.configurationFile=logback-remote-debug.xml' \

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
