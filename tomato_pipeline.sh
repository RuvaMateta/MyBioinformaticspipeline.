
#!/bin/bash
# Bioinformatics Practical Script (Tomato SNP/INDEL calling)
# Author: Ruvarashe
# --- Stage 1: Quality check with FastQC ---
#FASTAQ Files downloaded from ENA browser, 2paired end sequences were selected and stored in browser

mkdir -p qc_reports
fastqc /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279501_1.fastq.gz /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279501_2.fastq.gz \
       /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279488_1.fastq.gz /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279488_2.fastq.gz \
       -o qc_reports

# --- Stage 2: Read trimming with fastp ---
mkdir -p trimmed
fastp -i /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279501_1.fastq.gz -I /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279501_2.fastq.gz \
      -o trimmed/SRR7279501_trimmed_1.fastq.gz -O trimmed/SRR7279501_trimmed_2.fastq.gz \
      -h trimmed/SRR7279501_fastp.html -j trimmed/SRR7279501_fastp.json

fastp -i /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279488_1.fastq.gz -I /mnt/c/Users/RUVA/Desktop/Rawsequencedata/SRR7279488_2.fastq.gz \
      -o trimmed/SRR7279488_trimmed_1.fastq.gz -O trimmed/SRR7279488_trimmed_2.fastq.gz \
      -h trimmed/SRR7279488_fastp.html -j trimmed/SRR7279488_fastp.json

# --- Stage 3: Reference genome download and indexing ---
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-54/fasta/solanum_lycopersicum/dna/Solanum_lycopersicum.SL3.0.dna.toplevel.fa.gz
bwa index /mnt/c/Users/RUVA/Desktop/Rawsequencedata/Solanum_lycopersicum.SL3.0.dna.toplevel.fa

# --- Stage 4: Alignment with BWA MEM ---
mkdir -p alignments
bwa mem /mnt/c/Users/RUVA/Desktop/Rawsequencedata/Solanum_lycopersicum.SL3.0.dna.toplevel.fa \
    QCTRIM/SRR7279501_trimmed_1.fastq.gz QCTRIM/SRR7279501_trimmed_2.fastq.gz \
    | samtools view -bS - > alignments/SRR7279501.bam

bwa mem /mnt/c/Users/RUVA/Desktop/Rawsequencedata/Solanum_lycopersicum.SL3.0.dna.toplevel.fa \
    QCTRIM/SRR7279488_trimmed_1.fastq.gz QCTRIM/SRR7279488_trimmed_2.fastq.gz \
    | samtools view -bS - > alignments/SRR7279488.bam

# --- Stage 5: Sort and index BAM files ---
samtools sort -o alignments/SRR7279501_sorted.bam alignments/SRR7279501.bam
samtools index alignments/SRR7279501_sorted.bam

samtools sort -o alignments/SRR7279488_sorted.bam alignments/SRR7279488.bam
samtools index alignments/SRR7279488_sorted.bam

# --- Stage 6: Variant calling with bcftools ---
mkdir -p variants
bcftools mpileup -Ou -f /mnt/c/Users/RUVA/Desktop/reference/Solanum_lycopersicum.SL3.0.dna.toplevel.fa \
    alignments/SRR7279488_sorted.bam | \
    bcftools call -mv -Ov -o variants/raw_variants_SRR7279488.vcf

# --- Stage 7: Filter SNPs and INDELs ---
bcftools filter -s LOWQUAL -e '%QUAL<20 || DP<10' variants/raw_variants_SRR7279488.vcf > variants/filtered_variants_SRR7279488.vcf

echo "Pipeline complete. Final filtered VCF for SRR7279488: variants/filtered_variants_SRR7279488.vcf"
