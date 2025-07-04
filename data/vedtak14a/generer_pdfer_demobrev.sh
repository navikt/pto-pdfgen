#!/opt/homebrew/bin/bash

PDF_ENDPOINT="http://localhost:8081/api/v1/genpdf/vedtak14a/vedtak14a"
OUTPUT_FOLDER="${1:-$HOME/Downloads/demobrev}"
mkdir -p "$OUTPUT_FOLDER"

malTypes=(
  "STANDARD_INNSATS_BEHOLDE_ARBEID"
  "STANDARD_INNSATS_SKAFFE_ARBEID"
  "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID"
  "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID"
  "GRADERT_VARIG_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "GRADERT_VARIG_TILPASSET_INNSATS_SKAFFE_ARBEID"
  "VARIG_TILPASSET_INNSATS"
)

ungdomsgaranti_malTypes=(
  "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID"
  "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID"
  "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID"
)

getMalTypeLesbartNavn() {
  case "$1" in
    "STANDARD_INNSATS_BEHOLDE_ARBEID") echo "STANDARD_INNSATS-BEHOLDE_ARBEID" ;;
    "STANDARD_INNSATS_SKAFFE_ARBEID") echo "STANDARD_INNSATS-SKAFFE_ARBEID" ;;
    "SITUASJONSBESTEMT_INNSATS_BEHOLDE_ARBEID") echo "SITUASJONSBESTEMT_INNSATS-BEHOLDE_ARBEID" ;;
    "SITUASJONSBESTEMT_INNSATS_SKAFFE_ARBEID") echo "SITUASJONSBESTEMT_INNSATS-SKAFFE_ARBEID" ;;
    "SPESIELT_TILPASSET_INNSATS_BEHOLDE_ARBEID") echo "SPESIELT_TILPASSET_INNSATS-BEHOLDE_ARBEID" ;;
    "SPESIELT_TILPASSET_INNSATS_SKAFFE_ARBEID") echo "SPESIELT_TILPASSET_INNSATS-SKAFFE_ARBEID" ;;
    "GRADERT_VARIG_TILPASSET_INNSATS_BEHOLDE_ARBEID") echo "GRADERT_VARIG_TILPASSET_INNSATS-BEHOLDE_ARBEID" ;;
    "GRADERT_VARIG_TILPASSET_INNSATS_SKAFFE_ARBEID") echo "GRADERT_VARIG_TILPASSET_INNSATS-SKAFFE_ARBEID" ;;
    "VARIG_TILPASSET_INNSATS") echo "VARIG_TILPASSET_INNSATS" ;;
    *) echo "Ukjent malType" ;;
  esac
}
for malType in "${malTypes[@]}"; do
    lesbare_navn=$(getMalTypeLesbartNavn $malType)
    filnavn="${lesbare_navn}.pdf"
    echo "$filnavn"

    contains() {
      local seeking=$1; shift
      local in=1
      for element; do
        if [[ "$element" == "$seeking" ]]; then
          in=0
          break
        fi
      done
      return $in
    }

    if contains "$malType" "${ungdomsgaranti_malTypes[@]}"; then
      ungdomsgaranti=true
    else
      ungdomsgaranti=false
    fi

    echo "🌱 Genererer PDF for demobrev for malType=$malType ungdomsgaranti=$ungdomsgaranti som $filnavn"


    json=$(jq -n \
      --arg malType "$malType" \
      --arg veilederNavn "Veileder Veiledersen" \
      --arg navKontor "Nav Kontor" \
      --arg dato "01. april 2025" \
      --arg malform "NB" \
      --argjson begrunnelse '["Avsnitt 1", "Avsnitt 2"]' \
      --argjson kilder '["Kilde 1", "Kilde 2"]' \
      --argjson mottaker '{"navn":"Navn Navnesen","fodselsnummer":"12345678910"}' \
      --argjson utkast true \
      --argjson ungdomsgaranti "$ungdomsgaranti" \
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

echo "✅ Ferdig genererte pdfer for demobrev i $OUTPUT_FOLDER"
