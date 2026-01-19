#!/bin/bash

mkdir -p gut-to-soil/data

# ============================================================
# gut-to-soil
# ============================================================
wget -O 'gut-to-soil/data/sample-metadata.tsv' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/sample-metadata.tsv'

# ------------------------------------------------------------
# Download demultiplexed sequencing data
# - File format: QIIME 2 artifact (.qza)
# - Content: Sequencing reads already split by sample barcodes
# - Purpose: Input for downstream steps such as DADA2 or Deblur
# ------------------------------------------------------------
wget -O 'gut-to-soil/data/demux.qza' \
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
wget -O 'gut-to-soil/data/suboptimal-16S-rRNA-classifier.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/suboptimal-16S-rRNA-classifier.qza'


# ============================================================
# moving-pictures
# ============================================================
mkdir -p moving-pictures/data

wget -O 'moving-pictures/data/sample-metadata.tsv' \
  'https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/sample-metadata.tsv'

wget -O 'moving-pictures/data/emp-single-end-sequences.zip' \
  'https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/emp-single-end-sequences.zip'

unzip -d moving-pictures/data/emp-single-end-sequences moving-pictures/data/emp-single-end-sequences.zip

wget -O 'moving-pictures/data/gg-13-8-99-515-806-nb-classifier.qza' \
  'https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/gg-13-8-99-515-806-nb-classifier.qza'
