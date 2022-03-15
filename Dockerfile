FROM ghcr.io/navikt/pdfgen/pdfgen:d84f2a198a1b05af62b87ce994f0a23e22260bca
COPY templates /app/templates
COPY fonts /app/fonts
COPY resources /app/resources
