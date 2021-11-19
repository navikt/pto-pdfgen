FROM docker.pkg.github.com/navikt/pdfgen/pdfgen:08f2f8db6eeccc5f33fae12c267235951bb1ec56
COPY templates /app/templates
COPY fonts /app/fonts
COPY resources /app/resources
