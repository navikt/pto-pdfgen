# pto-pdfgen

PDF generator for PTO.

#### Lokal testing
Kjør `./run_development.sh`

PDF vil bli laget ved kall til http://localhost:8081/api/v1/genpdf/<application>/<template>
Innholdet hentes fra `/data/<application>/<template>.json`. I prod så POSTes JSON til endepunktet istedenfor

Testing av vedtak 14a: http://localhost:8081/api/v1/genpdf/vedtak14a/vedtak14a


Testdata for `/templates/<application>/<template>` settes i `/data/<application>/<template>.json` 
