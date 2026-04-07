#!/bin/bash

# HAC basecalling
dorado basecaller hac "/mnt/d/Oxford Nanopore/fastq/POD5 Secuenciacion" > hac.bam

# SUP basecalling
dorado basecaller sup "/mnt/d/Oxford Nanopore/fastq/POD5 Secuenciacion" > sup.bam
