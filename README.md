# pto-pdfgen

PDF generator for PTO.

#### Lokal testing
[20.03.2025] *Tar foreløpig bort nedlasting av image fra GAR, siden det ikke funker ordentlig i GH-workflowen*

~~For å laste ned pdf-gen-imaget lokalt må du autentisere deg mot gcloud.~~

- ~~Kjør `gcloud auth login` eventuelt `nais login`~~
- ~~Kun første gang, kjør `gcloud auth configure-docker europe-north1-docker.pkg.dev` og godta~~

~~Nå skal~du ha tilgang til å laste ned imaget fra GAR (Google Artifact Registry) lokalt.~~

Kjør `./run_development.sh`

PDF vil bli laget ved kall til `http://localhost:8081/api/v1/genpdf/<application>/<template>`
Innholdet hentes fra `/data/<application>/<template>.json`. I prod så POSTes JSON til endepunktet istedenfor

Testing av § 14 a-vedtak: http://localhost:8081/api/v1/genpdf/vedtak14a/vedtak14a


Testdata for `/templates/<application>/<template>` settes i `/data/<application>/<template>.json` 
