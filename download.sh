#!/bin/bash
# Download sample-metadata.tsv
wget -O 'data/sample-metadata.tsv' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/sample-metadata.tsv'

# Download demux.qza
wget -O 'data/demux.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/demux.qza'

# Download suboptimal-16S-rRNA-classifier.qza
wget -O 'data/suboptimal-16S-rRNA-classifier.qza' \
  'https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/suboptimal-16S-rRNA-classifier.qza'
