# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)
library(ggsci)
library(viridis)

seed <- as.integer(snakemake@wildcards[["seed"]])
gene <- snakemake@wildcards[["gene"]]

sce <- readRDS(snakemake@input[["sce"]])

colData(sce)[, gene] <- logcounts(sce)[gene, ]

style <- theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16))

# plot t-SNE
pdf(file=snakemake@output[[1]], width = 12)
set.seed(seed)
plotTSNE(sce, colour_by=gene) + scale_fill_viridis(alpha = 1.0) + scale_colour_viridis(alpha = 1.0) + style
dev.off()
