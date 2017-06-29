# DADA_16S_pipeline

## Requirements
- R version 3.4.0
- R packages: - DADA2 version 1.4
              - Tidyverse
              - Phyloseq
              - ggplot2
              - Ampvis
- Awk
- Perl
- kronatools
- app_otu_to_krona.pl (https://github.com/Ecogenomics/APP)
- QIIME 1.9 (Or download BIOM directly)

## Setup environment
- Download following files: 
- rdp_species_assignment_16.fa.gz (https://zenodo.org/record/801828#.WVS6XelLdPY)
- rdp_train_set_16.fa.gz (https://zenodo.org/record/801828#.WVS6XelLdPY)

- Create repository for the results:
```
mkdir results
```

- Create custom metadata file (see example below or meta_example.txt):
```
#SampleID Meta_1  Meta_2 ..
Sample_1  data  data  ..
Sample_2  data  data  ..
```
### Note: Make sure the columns are separated by tabulation
