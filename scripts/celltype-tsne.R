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
source(file.path(snakemake@scriptdir, "common.R"))

seed <- as.integer(snakemake@wildcards[["seed"]])

sce <- readRDS(snakemake@input[["sce"]])

for(cellassign_fit in snakemake@input[["fits"]]) {
    cellassign_fit <- readRDS(cellassign_fit)
    sce <- assign_celltypes(cellassign_fit, sce)
}

style <- theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16))

# plot t-SNE
pdf(file=snakemake@output[[1]], width = 12)
set.seed(seed)
plotTSNE(sce, colour_by="celltype") + scale_fill_d3(alpha = 1.0) + scale_colour_d3(alpha = 1.0) + style
dev.off()
