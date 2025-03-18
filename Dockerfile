FROM europe-north1-docker.pkg.dev/nais-management-233d/pdfgen/pdfgen:2.0.72
COPY templates /app/templates
COPY fonts /app/fonts
