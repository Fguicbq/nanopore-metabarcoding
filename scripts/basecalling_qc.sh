#!/bin/bash

# Uso: bash scripts/basecalling_qc.sh <RESULTS_DIR>
# Ejemplo: bash scripts/basecalling_qc.sh "../results/basecalling"

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <RESULTS_DIR>"
    exit 1
fi

RESULTS_DIR=$1
REPORT_FILE="$RESULTS_DIR/basecalling_qc_report.txt"

echo "Generando QC report para HAC y SUP..." | tee "$REPORT_FILE"
echo "Fecha: $(date)" | tee -a "$REPORT_FILE"
echo "Resultados en: $RESULTS_DIR" | tee -a "$REPORT_FILE"
echo "----------------------------------------" | tee -a "$REPORT_FILE"

# Función para calcular estadísticas de un FASTQ
qc_fastq() {
    local FILE=$1
    local LABEL=$2

    if [ ! -f "$FILE" ]; then
        echo "Archivo $FILE no encontrado, saltando $LABEL QC." | tee -a "$REPORT_FILE"
        return
    fi

    TOTAL=$(grep -c "^@" "$FILE")
    MIN=$(awk 'NR%4==2{print length($0)}' "$FILE" | sort -n | head -1)
    MAX=$(awk 'NR%4==2{print length($0)}' "$FILE" | sort -n | tail -1)
    MEAN=$(awk 'NR%4==2{sum+=length($0); n++} END {if(n>0) print sum/n; else print 0}' "$FILE")

    echo "------ $LABEL QC ------" | tee -a "$REPORT_FILE"
    echo "Total reads: $TOTAL" | tee -a "$REPORT_FILE"
    echo "Longitud mínima: $MIN" | tee -a "$REPORT_FILE"
    echo "Longitud máxima: $MAX" | tee -a "$REPORT_FILE"
    echo "Longitud promedio: $MEAN" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
}

# HAC
qc_fastq "$RESULTS_DIR/hac.fastq" "HAC raw"
qc_fastq "$RESULTS_DIR/hac_filtered.fastq" "HAC filtrados"

# SUP
qc_fastq "$RESULTS_DIR/sup.fastq" "SUP raw"
qc_fastq "$RESULTS_DIR/sup_filtered.fastq" "SUP filtrados"

echo "QC completado. Reporte guardado en $REPORT_FILE" | tee -a "$REPORT_FILE"