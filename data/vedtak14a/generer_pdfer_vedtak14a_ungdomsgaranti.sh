#!/bin/bash

PDF_ENDPOINT="http://localhost:8081/api/v1/genpdf/vedtak14a/vedtak14a"
OUTPUT_FOLDER="${1:-$HOME/Downloads/vedtak14a_ungdomsgaranti}"
mkdir -p "$OUTPUT_FOLDER"

ungdomsgaranti_types=(
  "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID"
  "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID"
)

malforms=("NN" "NB")

getMalTypeLesbartNavn() {
  case "$1" in
    "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID") echo "Trenger veiledning - beholde arbeid" ;;
    "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID") echo "Trenger veiledning - skaffe arbeid" ;;
    "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID") echo "Trenger veiledning - nedsatt arbeidsevne beholde arbeid" ;;
    "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID") echo "Trenger veiledning - nedsatt arbeidsevne skaffe arbeid" ;;
    *) echo "Ukjent malType" ;;
  esac
}
for malType in "${ungdomsgaranti_types[@]}"; do
  for malform in "${malforms[@]}"; do
    lesbart_navn=$(getMalTypeLesbartNavn $malType)
    filnavn="Ungdomsgaranti - ${lesbart_navn} ${malform}.pdf"

    echo "🌱 Genererer PDF med ungdomsgaranti for malType=$malType malform=$malform som '$filnavn'"

    json=$(jq -n \
      --arg malType "$malType" \
      --arg veilederNavn "Veileder Veiledersen" \
      --arg navKontor "Nav Kontor" \
      --arg dato "01. april 2025" \
      --arg malform "$malform" \
      --argjson begrunnelse '["Avsnitt 1", "Avsnitt 2"]' \
      --argjson kilder '["Kilde 1", "Kilde 2"]' \
      --argjson mottaker '{"navn":"Navn Navnesen","fodselsnummer":"12345678910"}' \
      --argjson utkast true \
      --argjson ungdomsgaranti true \
      '{
        malType: $malType,
        veilederNavn: $veilederNavn,
        navKontor: $navKontor,
        dato: $dato,
        malform: $malform,
        begrunnelse: $begrunnelse,
        kilder: $kilder,
        mottaker: $mottaker,
        utkast: $utkast,
        ungdomsgaranti: $ungdomsgaranti
      }')

    curl -s -X POST "$PDF_ENDPOINT" \
      -H "Content-Type: application/json" \
      -d "$json" \
      --output "$OUTPUT_FOLDER/$filnavn"

    sleep 1
  done
done

echo "✅ Ferdig genererte pdfer for vedtak14a med ungdomsgaranti i: $OUTPUT_FOLDER"
