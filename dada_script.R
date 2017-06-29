library("dada2")
library("tidyverse")

pathF <- "evaluation_forward"
pathR <- "evaluation_reverse"

filtpathF <- file.path(pathF, "filtered")
filtpathR <- file.path(pathR, "filtered")

fastqFs <- sort(list.files(pathF, pattern="fastq.gz"))
fastqRs <- sort(list.files(pathR, pattern="fastq.gz"))

if(length(fastqFs) != length(fastqRs)) stop("Forward and reverse files do not match.")

# Filtering: THESE PARAMETERS ARENT OPTIMAL FOR ALL DATASETS
filterAndTrim(fwd=file.path(pathF, fastqFs), filt=file.path(filtpathF, fastqFs),
              rev=file.path(pathR, fastqRs), filt.rev=file.path(filtpathR, fastqRs),
              truncLen=c(240,200), maxEE=2, truncQ=11, maxN=0, rm.phix=TRUE,
              compress=TRUE, verbose=TRUE, multithread=TRUE)

filtFs <- list.files(filtpathF, pattern="fastq.gz", full.names = TRUE)
filtRs <- list.files(filtpathR, pattern="fastq.gz", full.names = TRUE)

sample.names <- sapply(strsplit(basename(filtFs), "_"), `[`, 1)
sample.namesR <- sapply(strsplit(basename(filtRs), "_"), `[`, 1)

if(!identical(sample.names, sample.namesR)) stop("Forward and reverse files do not match.")

names(filtFs) <- sample.names
names(filtRs) <- sample.names
set.seed(100)

errF <- learnErrors(filtFs, nread=2e6, multithread=TRUE)
errR <- learnErrors(filtRs, nread=2e6, multithread=TRUE)

mergers <- vector("list", length(sample.names))
names(mergers) <- sample.names

for(sam in sample.names) {
  cat("Processing:", sam, "\n")
    derepF <- derepFastq(filtFs[[sam]])
    ddF <- dada(derepF, err=errF, multithread=TRUE)
    derepR <- derepFastq(filtRs[[sam]])
    ddR <- dada(derepR, err=errR, multithread=TRUE)
    merger <- mergePairs(ddF, derepF, ddR, derepR)
    mergers[[sam]] <- merger
}

rm(derepF); rm(derepR)

seqtab <- makeSequenceTable(mergers)

seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)

tax <- assignTaxonomy(seqtab.nochim, "data/rdp_train_set_16.fa.gz", multithread=TRUE)

taxa <- addSpecies(tax, "data/rdp_species_assignment_16.fa.gz")

as.tibble(taxa) -> taxe

row.names(taxa) -> row

mutate(taxe, OTU= row) -> taxe

colnames(taxa) -> col

taxe[c("OTU",col)] -> taxo

seqtab <- t(seqtab.nochim)

as.tibble(seqtab) -> sv_table

row.names(seqtab) -> row

mutate(sv_table, OTU= row) -> sv_table

colnames(seqtab) -> col

sv_table[c("OTU",col)] -> final_seqtab

otutable <- merge(final_seqtab, taxo)

write_tsv(otutable, "final_seqtab.txt")
