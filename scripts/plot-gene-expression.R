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

cellassign_fit <- snakemake@input[["fit"]]
cellassign_fit <- readRDS(cellassign_fit)
sce <- assign_celltypes(cellassign_fit, sce, snakemake@params[["min_gamma"]])


# plot gene expression
pdf(file=snakemake@output[[1]], width = 12, height = 12)
plotExpression(sce, snakemake@params[["genes"]], snakemake@params[["feature"]])
dev.off()
