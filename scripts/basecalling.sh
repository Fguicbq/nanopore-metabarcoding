#!/bin/bash

# Uso: bash scripts/basecalling.sh <RAW_DIR> <RESULTS_DIR>
# Ejemplo: bash scripts/basecalling.sh "../data/raw" "../results/basecalling"

# Comprobar que se pasaron los argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <RAW_DIR> <RESULTS_DIR>"
    exit 1
fi

RAW_DIR=$1
RESULTS_DIR=$2

# Crear carpeta de resultados si no existe
mkdir -p "$RESULTS_DIR"

# -------------------------
# HAC basecalling
# -------------------------
echo "Iniciando HAC basecalling..."
dorado basecaller hac "$RAW_DIR" > "$RESULTS_DIR/hac.bam"

# Convertir a FASTQ
samtools fastq "$RESULTS_DIR/hac.bam" > "$RESULTS_DIR/hac.fastq"

# Filtrar por longitud 2000–5000 bp
NanoFilt -l 2000 --maxlength 5000 "$RESULTS_DIR/hac.fastq" > "$RESULTS_DIR/hac_filtered.fastq"

echo "HAC basecalling y filtrado completado."
echo "Resultados en $RESULTS_DIR"

# -------------------------
# SUP basecalling
# -------------------------
echo "Iniciando SUP basecalling..."
dorado basecaller sup "$RAW_DIR" > "$RESULTS_DIR/sup.bam"

# Convertir a FASTQ
samtools fastq "$RESULTS_DIR/sup.bam" > "$RESULTS_DIR/sup.fastq"

# Filtrar por longitud 2000–5000 bp
NanoFilt -l 2000 --maxlength 5000 "$RESULTS_DIR/sup.fastq" > "$RESULTS_DIR/sup_filtered.fastq"

echo "SUP basecalling y filtrado completado."
echo "Resultados en $RESULTS_DIR"

# -------------------------
# Resumen opcional
# -------------------------
echo "Resumen de reads HAC filtrados:"
grep -c "^@" "$RESULTS_DIR/hac_filtered.fastq"
echo "Resumen de reads SUP filtrados:"
grep -c "^@" "$RESULTS_DIR/sup_filtered.fastq"
