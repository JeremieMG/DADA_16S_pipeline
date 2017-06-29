library(ampvis)

otutable <- read.delim(file = "results/ampvis_tab.txt", sep = "\t", header = T, check.names = F, row.names = 1)
metadata <- read.delim(file = "metadata.txt", header = T, sep = "\t")

d <- amp_load(otutable = otutable, 
              metadata = metadata)

heatmap = amp_heatmap(data = d, 
            group = c("Plant", "Year"))
ordinate = amp_ordinate(data = d, 
             plot.color = "Plant")
core = amp_core(data=d, 
         plot.type = "core", 
         abund.treshold = 0.1,
         scale.seq = 100)
rabund = amp_rabund(data = d,
           tax.aggregate = "Genus",
           tax.add = "Phylum", 
           scale.seq = 100,
           tax.show = 10,
           group = "Plant")

pdf("results/dada_plots.pdf")

plot(heatmap)
plot(ordinate)
plot(core)
plot(rabund)

dev.off()
