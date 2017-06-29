# DADA_16S_pipeline

## Requirements
- R version 3.4.0
- R packages: 
  - DADA2 version 1.4
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

## Usage
- With qsub, simply run the queue_script.sh:
```
qsub queue_script.sh
```

- Without qsub, you can run the queue_script.sh with the shell (Be careful, all the threads avaiable will be used):
```
sh queue_script.sh
```

## Visualisation
- Krona:
  - Open the dada_chart.html in your favorite browser

- Phinch:
  - Only available on Chrome browser
  - Go to http://phinch.org/
  - Load your dada_biom.biom file

- Ampvis:
  - Interactive analysis:
    - Start R terminal 
    - Start shiny-ampvis (https://github.com/KasperSkytte/Amplicon-visualiser)
    - Load ampvis_tab.txt and your metadata file
  - Custom analysis:
    - Modify the plot_script.R as you wish
    - Open the pdf to view the results
