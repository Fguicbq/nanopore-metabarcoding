#!/bin/bash

# =========================================
# PIPELINE: BASECALLING → DEMUX → FASTQ
# (VERSIÓN PORTABLE PARA GITHUB)
# =========================================

set -euo pipefail

# -------------------------
# Uso
# -------------------------
# bash scripts/full_pipeline_demux.sh <RAW_DIR> <OUT_DIR>
# Ejemplo:
# bash scripts/full_pipeline_demux.sh "/ruta/a/pod5" "results/basecall"

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <RAW_DIR> <OUT_DIR>"
    exit 1
fi

RAW_DIR=$1
OUT_DIR=$2
DEMUX_DIR="$OUT_DIR/demux_hac"

# -------------------------
# Crear carpetas
# -------------------------
echo "==> Creando estructura..."
mkdir -p "$OUT_DIR"
mkdir -p "$DEMUX_DIR"

# -------------------------
# 1. Basecalling HAC con barcodes
# -------------------------
echo "==> Iniciando basecalling HAC..."

dorado basecaller hac \
--kit-name SQK-NBD114-24 \
--no-trim \
"$RAW_DIR" \
> "$OUT_DIR/hac_barcoded.bam"

echo "==> Basecalling completado"

# -------------------------
# 2. Demultiplexado
# -------------------------
echo "==> Iniciando demultiplexado..."

dorado demux \
--kit-name SQK-NBD114-24 \
--output-dir "$DEMUX_DIR" \
--no-trim \
"$OUT_DIR/hac_barcoded.bam"

echo "==> Demultiplexado completado"

# -------------------------
# 3. Post-procesamiento
# -------------------------
cd "$DEMUX_DIR"

echo "==> Creando estructura interna..."
mkdir -p bam fastq extras metadata

# -------------------------
# 4. Convertir BAM → FASTQ
# -------------------------
echo "==> Convirtiendo BAM a FASTQ..."

for f in *.bam; do
    samtools fastq "$f" > "${f%.bam}.fastq"
done

# -------------------------
# 5. Organizar archivos
# -------------------------
echo "==> Organizando archivos..."

mv *.bam bam/ 2>/dev/null || true
mv *.fastq fastq/ 2>/dev/null || true

# -------------------------
# 6. Separar archivos especiales
# -------------------------
echo "==> Separando archivos especiales..."

mv bam/*barcode23* extras/ 2>/dev/null || true
mv bam/*unclassified* extras/ 2>/dev/null || true

echo "==> Pipeline completado (sin trimming ni filtrado)"
echo "Resultados en: $DEMUX_DIR"