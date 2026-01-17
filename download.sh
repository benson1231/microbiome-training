#!/bin/bash
# ============================================================
# This script downloads example data used in the QIIME 2
#
# The files include:
#   1. Sample metadata (TSV format)
#   2. Demultiplexed sequencing data (QIIME 2 artifact)
#   3. A pre-trained 16S rRNA taxonomic classifier
# ============================================================

# It is recommended to create the data directory beforehand
mkdir -p data

# ------------------------------------------------------------
# Download sample metadata
# - File format: TSV
# - Purpose: Provides sample-level information required by
#   QIIME 2 (e.g., sample IDs, experimental groups, environments)
# ------------------------------------------------------------
wget -O 'data/sample-metadata.tsv' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/sample-metadata.tsv'

# ------------------------------------------------------------
# Download demultiplexed sequencing data
# - File format: QIIME 2 artifact (.qza)
# - Content: Sequencing reads already split by sample barcodes
# - Purpose: Input for downstream steps such as DADA2 or Deblur
# ------------------------------------------------------------
wget -O 'data/demux.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/demux.qza'

# ------------------------------------------------------------
# Download a pre-trained 16S rRNA classifier (suboptimal version)
# - File format: QIIME 2 artifact (.qza)
# - Content: Naive Bayes classifier trained on reference sequences
# - Purpose: Taxonomic assignment of ASVs
# - Note: This classifier is provided for tutorial purposes.
#         For real analyses, use a classifier trained on the
#         appropriate region and reference database.
# ------------------------------------------------------------
wget -O 'data/suboptimal-16S-rRNA-classifier.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/suboptimal-16S-rRNA-classifier.qza'
