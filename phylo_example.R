library(phyloseq)
library(ampvis)
library(ggplot2)

#Loading data
otutable <- read.delim(file = "ampvis_tab.txt", sep = "\t", header = T, check.names = F, row.names = 1)
metadata <- read.delim(file = "m_metadata.txt", header = T, sep = "\t")
set <- amp_load(otutable = otutable, metadata = metadata)

#Plot ordination (OTUs)
ps <- prune_samples(sample_names(set) != "Mock", set)
ps1 = transform_sample_counts(ps, function(x) 1E6 * x/sum(x))
phylum.sum = tapply(taxa_sums(ps1), tax_table(ps1)[, "Phylum"], sum, na.rm=TRUE)
top5phyla = names(sort(phylum.sum, TRUE))[1:5]
ps1 = prune_taxa((tax_table(ps1)[, "Phylum"] %in% top5phyla), ps1)
plant = get_variable(ps1, "Plant") %in% c("Aalborg W", "Aalborg E","Other")
sample_data(ps1)$plant <- factor(plant)
ps.ord <- ordinate(ps1, "NMDS", "bray")
p1 = plot_ordination(ps1, ps.ord, type="taxa", color="Phylum", title="taxa")
print(p1)
p1 + facet_wrap(~Phylum, 3)
p2 = plot_ordination(ps1, ps.ord, type="sites", color="Plant", shape="test")
p2 + geom_polygon(aes(fill=Plant)) + geom_point(size=5) + ggtitle("Plant")

#Plot diversity
plot_richness(set)
p <-plot_richness(GP, x="test", color="Plant", measures=c("Chao1", "Shannon"))
p + geom_point(size=5, alpha=0.7)

#Plot
sample_data(ps)$Plant <- get_variable(ps, "Plant") %in% c("Aalborg W", "Aalborg E", "Other")
ps <- subset_taxa(ps, Phylum=="Bacteroidetes")
gpca <- ordinate(ps, "CCA")
p1 = plot_ordination(ps, gpca, "species", color="Genus")
p0 = ggplot(p1$data, p1$mapping) + geom_density2d() + facet_wrap(~Genus)
p1 = p1 + geom_density2d() + facet_wrap(~Genus)

#BarPlot
set.te = subset_taxa(set, Phylum == "Ternicutes")
plot_bar(set.te)
plot_bar(set.te, x="Plant", fill="Genus")

#Heatmap
plot_heatmap(set)
plot_heatmap(set, "RDA")

#Network
plot_net(set, point_label="X.SampleID")
plot_net(set, maxdist=0.3, point_label="X.SampleID")
plot_net(set, maxdist=0.3, point_label="X.SampleID", color="Plant")
