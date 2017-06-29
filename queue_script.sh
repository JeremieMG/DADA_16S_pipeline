#!/usr/bin/env bash
#$ -N jeremie_16S_pipe  #Name your job <name
#$ -M malengreau.jeremie@gmail.com   #your e-mail address
#$ -cwd  #Use the directory you're running from
#$ -l h_rt=6:0:0,h_vmem=10G   #Setting running time in hours:min:sec and the memory required for the job
#$ -j y   #Joining the output from standard out and standard error to one file
#$ -pe smp 10   #Setting the number of threads for the job to best fit for the system between 1 and N.
##### LOAD MODULE ####

#Modules are listed with the moduel avail command
module load r/3.4.0
module load qiime	
module load kronatools
######### Variables. These are just examples, please change as you see fit

## Run module

date

## Treatmnent of sequences
Rscript dada_script.R

## Conversion in adequate formats
awk -f label.awk final_seqtab.txt > results/ampvis_tab.txt

awk -f dada_to_qiime.awk results/ampvis_tab.txt > results/dada_tab.txt

## Creating BIOM and Krona chart
biom convert -i results/dada_tab.txt -o results/dada_biom.biom -m metadata.txt --to-json

./APP/app_otu_to_krona.pl -i results/dada_tab.txt -o results/dada_chart.html

## Ploting basics graphs
Rscript plot_script.R

date
