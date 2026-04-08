#!/bin/bash

# Uso: bash scripts/basecalling.sh <RAW_DIR> <RESULTS_DIR>
# Ejemplo: bash scripts/basecalling.sh "../data/raw" "../results/basecalling"

# -------------------------
# Comprobación de argumentos
# -------------------------
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <RAW_DIR> <RESULTS_DIR>"
    exit 1
fi

RAW_DIR=$1
RESULTS_DIR=$2

# Crear carpeta de resultados si no existe
mkdir -p "$RESULTS_DIR"

# Crear archivo de log con timestamp
LOG="$RESULTS_DIR/basecalling_$(date +%Y%m%d_%H%M%S).log"
echo "Iniciando basecalling pipeline $(date)" | tee -a "$LOG"

# -------------------------
# Función para ejecutar basecalling
# -------------------------
run_basecaller() {
    local MODEL=$1
    local LABEL=$2

    echo "Iniciando $LABEL basecalling..." | tee -a "$LOG"
    
    BAM="$RESULTS_DIR/${MODEL}.bam"
    FASTQ="$RESULTS_DIR/${MODEL}.fastq"
    FILTERED="$RESULTS_DIR/${MODEL}_filtered.fastq"

    # Basecalling
    dorado basecaller "$MODEL" "$RAW_DIR" > "$BAM"
    
    # Convertir a FASTQ
    samtools fastq "$BAM" > "$FASTQ"
    
    # Filtrar por longitud 2000–5000 bp
    NanoFilt -l 2000 --maxlength 5000 "$FASTQ" > "$FILTERED"

    echo "$LABEL basecalling y filtrado completado." | tee -a "$LOG"
    echo "Archivos generados:" | tee -a "$LOG"
    echo "  BAM: $BAM" | tee -a "$LOG"
    echo "  FASTQ: $FASTQ" | tee -a "$LOG"
    echo "  Filtrado: $FILTERED" | tee -a "$LOG"
    echo "" | tee -a "$LOG"
}

# -------------------------
# Ejecutar basecalling para HAC y SUP
# -------------------------
run_basecaller "hac" "HAC"
run_basecaller "sup" "SUP"

echo "Pipeline completado. Resultados en $RESULTS_DIR" | tee -a "$LOG"
