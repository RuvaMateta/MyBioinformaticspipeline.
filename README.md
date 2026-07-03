## MyBioinformaticspipeline.

## Scripts from staged bioinformatics practical

## Bioinformatics Practical Script 1 (Tomato SNP/INDEL Calling Pipeline)

## Overview

The pipeline performs variant calling (SNPs and INDELs) from raw sequencing data of tomato samples, using standard tools in a Linux (WSL) environment.

## Features

**Automated Workflow** – end‑to‑end pipeline from raw FASTQ files to filtered VCF outputs.

**Quality Control** – generates detailed FastQC reports for raw sequencing reads.

**Read Trimming** – removes adapters and low‑quality bases using fastp. 

**Reference Genome Handling** – downloads and indexes the tomato reference genome for alignment.

**Read Alignment** – aligns trimmed reads to the reference genome with BWA‑MEM.

**File Processing** – converts SAM to BAM, sorts, and indexes using Samtools.

**Variant Calling** – detects SNPs and INDELs with bcftools.

**Variant Filtering** – applies quality and depth thresholds to produce high‑confidence variants.

**Reproducibility** – modular script structure for easy reruns and adaptation to other datasets.

**Organized Outputs** – results stored in dedicated folders (`qc_reports/`, `trimmed/`, `alignments/`, `variants/`) for clarity.

## Tools & Dependencies

**WSL (Ubuntu)** – execution environment

**FastQC** – read quality assessment

**fastp** – read trimming and filtering

**BWA** – reference genome indexing and alignment

**Samtools** – BAM file processing (sorting, indexing)

**bcftools** – variant calling and filtering

**Git/GitHub** – version control and collaboration

## Repository Structure

```bash
bioinformatics-pipeline/     
├── alignments                    #BAM Files
├── docs                   
├── qc_reports                    #FASTQC output 
├── reference                     #Reference Genome + BWA Index
├── scripts                       #Pipeline Scripts
│   └── tomato_pipeline.sh
├── trimmed                       #fastp Trimmed Reads
└── variants                      #VCF Files
```

## Pipeline Execution

##The pipeline executes a complete workflow from raw FASTQ files to high‑confidence SNP and INDEL variants. Each stage—quality control, trimming, alignment, variant calling, and filtering—is automated to ensure reproducible and organized results.

## Quality Control and Filtering Results
**Quality Control (QC)**
Raw sequencing reads are first assessed using **FastQC**, which generates detailed reports on per‑base quality scores, GC content, sequence duplication levels, and adapter contamination. These reports help identify potential issues before downstream analysis.

**Read Trimming:**
Low‑quality bases and adapter sequences are removed using **fastp**, producing clean, high‑quality reads. Fastp also generates HTML and JSON reports summarizing trimming statistics.

**Variant Filtering:**  
After alignment and variant calling, raw SNP and INDEL calls are filtered with **bcftools**. Filters remove low‑confidence variants based on quality score thresholds ( QUAL < 20) and read depth ( DP < 10).  
  The final output is a **filtered VCF file** containing only high‑quality, high‑confidence variants suitable for downstream genetic analysis.



