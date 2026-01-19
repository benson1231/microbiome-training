#!/bin/bash

# https://amplicon-docs.qiime2.org/en/stable/tutorials/moving-pictures.html

source ../.env

# Create results directory
mkdir -p results
echo -e "${GREEN}Create directory: results${RESET}"

qiime metadata tabulate \
  --m-input-file data/sample-metadata.tsv \
  --o-visualization results/sample-metadata-viz.qzv

qiime tools import \
  --type 'EMPSingleEndSequences' \
  --input-path data/emp-single-end-sequences \
  --output-path results/emp-single-end-sequences.qza

qiime demux emp-single \
  --i-seqs results/emp-single-end-sequences.qza \
  --m-barcodes-file data/sample-metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences results/demux.qza \
  --o-error-correction-details results/demux-details.qza

qiime demux summarize \
  --i-data results/demux.qza \
  --o-visualization results/demux.qzv

qiime dada2 denoise-single \
  --i-demultiplexed-seqs results/demux.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences results/rep-seqs.qza \
  --o-table results/table.qza \
  --o-denoising-stats results/denoising-stats.qza \
  --o-base-transition-stats results/base-transition-stats.qza

qiime metadata tabulate \
  --m-input-file results/denoising-stats.qza \
  --o-visualization results/denoising-stats.qzv

qiime quality-filter q-score \
  --i-demux results/demux.qza \
  --o-filtered-sequences results/demux-filtered.qza \
  --o-filter-stats results/demux-filter-stats.qza

qiime deblur denoise-16S \
  --i-demultiplexed-seqs results/demux-filtered.qza \
  --p-trim-length 120 \
  --p-sample-stats \
  --o-representative-sequences results/rep-seqs-deblur.qza \
  --o-table results/table-deblur.qza \
  --o-stats results/deblur-stats.qza

qiime metadata tabulate \
  --m-input-file results/demux-filter-stats.qza \
  --o-visualization results/demux-filter-stats.qzv

qiime deblur visualize-stats \
  --i-deblur-stats results/deblur-stats.qza \
  --o-visualization results/deblur-stats.qzv

qiime feature-table summarize \
  --i-table results/table.qza \
  --m-sample-metadata-file data/sample-metadata.tsv \
  --o-visualization results/table.qzv

qiime feature-table tabulate-seqs \
  --i-data results/rep-seqs.qza \
  --o-visualization results/rep-seqs.qzv

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences results/rep-seqs.qza \
  --o-alignment results/aligned-rep-seqs.qza \
  --o-masked-alignment results/masked-aligned-rep-seqs.qza \
  --o-tree results/unrooted-tree.qza \
  --o-rooted-tree results/rooted-tree.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny results/rooted-tree.qza \
  --i-table results/table.qza \
  --p-sampling-depth 1103 \
  --m-metadata-file data/sample-metadata.tsv \
  --output-dir results/diversity-core-metrics-phylogenetic

qiime diversity alpha-group-significance \
  --i-alpha-diversity results/diversity-core-metrics-phylogenetic/faith_pd_vector.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/faith-pd-group-significance.qzv
qiime diversity alpha-group-significance \
  --i-alpha-diversity results/diversity-core-metrics-phylogenetic/evenness_vector.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/evenness-group-significance.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix results//diversity-core-metrics-phylogenetic/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --m-metadata-column body-site \
  --p-pairwise \
  --o-visualization results/unweighted-unifrac-body-site-group-significance.qzv
qiime diversity beta-group-significance \
  --i-distance-matrix results/diversity-core-metrics-phylogenetic/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --m-metadata-column subject \
  --p-pairwise \
  --o-visualization results/unweighted-unifrac-subject-group-significance.qzv

qiime emperor plot \
  --i-pcoa results/diversity-core-metrics-phylogenetic/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization results/unweighted-unifrac-emperor-days-since-experiment-start.qzv
qiime emperor plot \
  --i-pcoa results/diversity-core-metrics-phylogenetic/bray_curtis_pcoa_results.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization results/bray-curtis-emperor-days-since-experiment-start.qzv

qiime diversity alpha-rarefaction \
  --i-table results/table.qza \
  --i-phylogeny results/rooted-tree.qza \
  --p-max-depth 4000 \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/alpha-rarefaction.qzv


qiime feature-classifier classify-sklearn \
  --i-classifier data/gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads results/rep-seqs.qza \
  --o-classification results/taxonomy.qza
qiime metadata tabulate \
  --m-input-file results/taxonomy.qza \
  --o-visualization results/taxonomy.qzv

qiime taxa barplot \
  --i-table results/table.qza \
  --i-taxonomy results/taxonomy.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --o-visualization results/taxa-bar-plots.qzv

qiime feature-table filter-samples \
  --i-table results/table.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-where '[body-site]="gut"' \
  --o-filtered-table results/gut-table.qza

qiime composition ancombc \
  --i-table results/gut-table.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-formula subject \
  --o-differentials results/ancombc-subject.qza
qiime composition da-barplot \
  --i-data results/ancombc-subject.qza \
  --p-significance-threshold 0.001 \
  --o-visualization results/da-barplot-subject.qzv

qiime taxa collapse \
  --i-table results/gut-table.qza \
  --i-taxonomy results/taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table results/gut-table-l6.qza
qiime composition ancombc \
  --i-table results/gut-table-l6.qza \
  --m-metadata-file data/sample-metadata.tsv \
  --p-formula subject \
  --o-differentials results/l6-ancombc-subject.qza
qiime composition da-barplot \
  --i-data results/l6-ancombc-subject.qza \
  --p-significance-threshold 0.001 \
  --o-visualization results/l6-da-barplot-subject.qzv