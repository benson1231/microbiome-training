#!/bin/bash

# https://amplicon-docs.qiime2.org/en/stable/tutorials/gut-to-soil.html

# Create results directory
mkdir -p results

# Create sample-metadata.qzv for qiime2 view
qiime metadata tabulate \
  --m-input-file data/sample-metadata.tsv \
  --o-visualization results/sample-metadata.qzv

# Create demultiplexed sequence QC summary
qiime demux summarize \
  --i-data data/demux.qza \
  --o-visualization results/demux.qzv

# ============================================================
# Use DADA2 for ASV denoising
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs data/demux.qza \
  --p-trim-left-f 0 \
  --p-trunc-len-f 250 \
  --p-trim-left-r 0 \
  --p-trunc-len-r 250 \
  --o-representative-sequences results/asv-seqs.qza \
  --o-table results/asv-table.qza \
  --o-denoising-stats results/denoising-stats.qza \
  --o-base-transition-stats results/base-transition-stats.qza

# DADA2 results visualization
qiime metadata tabulate \
  --m-input-file results/denoising-stats.qza \
  --o-visualization results/denoising-stats.qzv

# Create ASV table
qiime feature-table summarize-plus \
  --i-table results/asv-table.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-summary results/asv-table.qzv \
  --o-sample-frequencies results/sample-frequencies.qza \
  --o-feature-frequencies results/asv-frequencies.qza

# ASV table visualization
qiime feature-table tabulate-seqs \
  --i-data results/asv-seqs.qza \
  --m-metadata-file results/asv-frequencies.qza \
  --o-visualization results/asv-seqs.qzv

# ============================================================
# Filter features
qiime feature-table filter-features \
  --i-table results/asv-table.qza \
  --p-min-samples 2 \
  --o-filtered-table results/asv-table-ms2.qza

# Filter sequences only on filtered features
qiime feature-table filter-seqs \
  --i-data results/asv-seqs.qza \
  --i-table results/asv-table-ms2.qza \
  --o-filtered-data results/asv-seqs-ms2.qza

# Summarize filtered table
qiime feature-table summarize-plus \
  --i-table results/asv-table-ms2.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-summary results/asv-table-ms2.qzv \
  --o-sample-frequencies results/sample-frequencies-ms2.qza \
  --o-feature-frequencies results/asv-frequencies-ms2.qza

# ============================================================
# Create taxonomy.qza
qiime feature-classifier classify-sklearn \
  --i-classifier data/suboptimal-16S-rRNA-classifier.qza \
  --i-reads results/asv-seqs-ms2.qza \
  --o-classification results/taxonomy.qza

# Create asv-seqs-ms2.qzv
qiime feature-table tabulate-seqs \
  --i-data results/asv-seqs-ms2.qza \
  --i-taxonomy results/taxonomy.qza \
  --o-visualization results/asv-seqs-ms2.qzv

# ============================================================
# Create boots-kmer-diversity
qiime boots kmer-diversity \
  --i-table results/asv-table-ms2.qza \
  --i-sequences results/asv-seqs-ms2.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-sampling-depth 96 \
  --p-n 10 \
  --p-replacement \
  --p-alpha-average-method median \
  --p-beta-average-method medoid \
  --output-dir results/boots-kmer-diversity

# Create alpha-rarefaction
qiime diversity alpha-rarefaction \
  --i-table results/asv-table-ms2.qza \
  --p-max-depth 260 \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/alpha-rarefaction.qzv

# Create Taxonomic bar plots
qiime taxa barplot \
  --i-table results/asv-table-ms2.qza \
  --i-taxonomy results/taxonomy.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/taxa-bar-plots.qzv

# ============================================================
# Differential abundance testing with ANCOM-BC2
qiime feature-table filter-samples \
  --i-table results/asv-table-ms2.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-where '[SampleType] IN ("Human Excrement Compost", "Human Excrement", "Food Compost")' \
  --o-filtered-table results/asv-table-ms2-dominant-sample-types.qza

# Create ancombc2-results
qiime composition ancombc2 \
  --i-table results/asv-table-ms2-dominant-sample-types.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-fixed-effects-formula SampleType \
  --p-reference-levels 'SampleType::Human Excrement Compost' \
  --o-ancombc2-output results/ancombc2-results.qza

# Create ancombc2-barplot
qiime composition ancombc2-visualizer \
  --i-data results/ancombc2-results.qza \
  --i-taxonomy results/taxonomy.qza \
  --o-visualization results/ancombc2-barplot.qzv