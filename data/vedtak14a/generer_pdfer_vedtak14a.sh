#!/opt/homebrew/bin/bash

PDF_ENDPOINT="http://localhost:8081/api/v1/genpdf/vedtak14a/vedtak14a"
OUTPUT_FOLDER="${1:-$HOME/Downloads/vedtak14a}"
mkdir -p "$OUTPUT_FOLDER"

malTypes=(
  "STANDARD_INNSATS_BEHOLDE_ARBEID"
  "STANDARD_INNSATS_SKAFFE_ARBEID"
  "STANDARD_INNSATS_SKAFFE_ARBEID_PROFILERING"
  "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID"
  "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID"
  "GRADERT_VARIG_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "GRADERT_VARIG_TILPASSET_INNSATS_SKAFFE_ARBEID"
  "VARIG_TILPASSET_INNSATS"
)
malforms=("NN" "NB")

getMalTypeLesbartNavn() {
  case "$1" in
    "STANDARD_INNSATS_BEHOLDE_ARBEID") echo "Gode muligheter beholde arbeid" ;;
    "STANDARD_INNSATS_SKAFFE_ARBEID") echo "Gode muligheter - skaffe arbeid" ;;
    "STANDARD_INNSATS_SKAFFE_ARBEID_PROFILERING") echo "Gode muligheter - skaffe arbeid profilering" ;;
    "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID") echo "Trenger veiledning - beholde arbeid" ;;
    "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID") echo "Trenger veiledning - skaffe arbeid" ;;
    "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID") echo "Trenger veiledning - nedsatt arbeidsevne beholde arbeid" ;;
    "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID") echo "Trenger veiledning - nedsatt arbeidsevne skaffe arbeid" ;;
    "GRADERT_VARIG_TILPASSET_INNSATS_BEHOLDE_ARBEID") echo "Jobbe delvis - beholde arbeid" ;;
    "GRADERT_VARIG_TILPASSET_INNSATS_SKAFFE_ARBEID") echo "Jobbe delvis - skaffe arbeid" ;;
    "VARIG_TILPASSET_INNSATS") echo "Liten mulighet til å jobbe" ;;
    *) echo "Ukjent malType" ;;
  esac
}

for malType in "${malTypes[@]}"; do
  for malform in "${malforms[@]}"; do
    lesbare_navn=$(getMalTypeLesbartNavn $malType)
    filnavn="${lesbare_navn} ${malform}.pdf"

    echo "🌱 Genererer PDF uten ungdomsgaranti for malType=$malType malform=$malform som $filnavn"

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
      --argjson ungdomsgaranti false \
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
      }'
    )

    curl -s -X POST "$PDF_ENDPOINT" \
      -H "Content-Type: application/json" \
      -d "$json" \
      --output "$OUTPUT_FOLDER/$filnavn"

    sleep 1
  done
done

echo "✅ Ferdig genererte pdfer for vedtak14a (uten ungomdsgaranti) i $OUTPUT_FOLDER"
