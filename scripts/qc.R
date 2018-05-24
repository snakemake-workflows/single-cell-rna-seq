# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)

sce <- readRDS(snakemake@input[[1]])

# plot library sizes
svg(file=snakemake@output[["libsizes"]])
hist(sce$total_counts/1e6, xlab="Library sizes (millions)", main="",
     breaks=20, col="grey80", ylab="Number of cells")
dev.off()

# plot number of expressed genes
svg(file=snakemake@output[["expressed"]])
hist(sce$total_features, xlab="Number of expressed genes", main="",
     breaks=20, col="grey80", ylab="Number of cells")
dev.off()

# plot mitochondrial proportion
svg(file=snakemake@output[["mito_proportion"]])
hist(sce$pct_counts_Mt, xlab="Mitochondrial proportion (%)",
     ylab="Number of cells", breaks=20, main="", col="grey80")
dev.off()


# plot spike-in proportion
svg(file=snakemake@output[["spike_proportion"]])
hist(sce$pct_counts_Spike, xlab="ERCC proportion (%)",
     ylab="Number of cells", breaks=20, main="", col="grey80")
dev.off()
