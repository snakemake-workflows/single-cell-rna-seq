# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)

sce <- readRDS(snakemake@input[[1]])

# pre-cluster in order to group similar cells
# this avoids a violation of the non-DE assumption
preclusters <- quickCluster(sce)

# compute size factors by pooling cells according to the clustering
sce <- computeSumFactors(sce, clusters=preclusters, min.mean=snakemake@params[["min_count"]])

pdf(file=snakemake@output[["scatter"]])
plot(sizeFactors(sce), sce$total_counts/1e6, log="xy",
     ylab="Library size (millions)", xlab="Size factor")
dev.off()

# use size factors to calculate normalized counts in log space (available under logcounts(sce)) 
sce <- normalize(sce)

saveRDS(sce, file=snakemake@output[["rds"]])
