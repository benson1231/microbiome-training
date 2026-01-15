#!/bin/bash

wget -O 'results/sample-metadata.tsv' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/sample-metadata.tsv'


qiime metadata tabulate \
  --m-input-file results/sample-metadata.tsv \
  --o-visualization results/sample-metadata.qzv


wget -O 'results/demux.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/demux.qza'

qiime demux summarize \
  --i-data results/demux.qza \
  --o-visualization results/demux.qzv