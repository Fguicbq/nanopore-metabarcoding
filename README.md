# Nanopore Metabarcoding Benchmark

## 1. Background

Long-read sequencing using Oxford Nanopore technology enables near full-length ribosomal operon sequencing (~2.4 kb), improving taxonomic resolution in metabarcoding studies. However, both basecalling models and taxonomic classification strategies can introduce biases in downstream microbial community profiling.

## 2. Problem Statement

The impact of basecalling accuracy (HAC vs SUP) and classification methodology (alignment-based vs k-mer-based) on taxonomic assignment and diversity estimation remains insufficiently characterized for long-read metabarcoding datasets.

## 3. Objective

To evaluate how different basecalling models and taxonomic classification approaches affect:

- Read quality and length distribution
- Taxonomic resolution
- Species abundance estimation
- Alpha and beta diversity metrics

## 4. Experimental Design

### Input Data
- Platform: Oxford Nanopore (Flongle R10.4.1)
- Data type: Long-read amplicons (~2.4 kb)
- Raw format: POD5

### Basecalling
Performed using Dorado:

- HAC model
- SUP model

### Pipelines

#### Pipeline A (Alignment-based)
- Tool: Minimap2
- Databases: EMU / rEGEN

#### Pipeline B (k-mer based)
- Tool: Kraken2
- Post-processing: Bracken

## 5. Workflow Overview

POD5 → Basecalling → FASTQ → QC → Contamination removal → Taxonomic classification → Diversity analysis

## 6. Current Status

- [x] Dorado installation
- [x] HAC basecalling running
- [ ] SUP basecalling
- [ ] QC analysis
- [ ] Taxonomic classification
- [ ] Comparative analysis

## 7. Reproducibility

Basecalling command:

```bash
dorado basecaller hac "<POD5_PATH>" > test.bam
