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

# determine cell cycle
species = snakemake@params[["species"]]
if (species == "mouse") {
    markers <- "mouse_cycle_markers.rds"
} else if (species == "human") {
    markers <- "human_cycle_markers.rds"
} else {
    stop("Unsupported species. Only mouse and human are supported.")
}

# read trained data
pairs <- readRDS(system.file("exdata", markers, package="scran"))

# obtain assignments
assignments <- cyclone(sce, pairs, gene.names=rowData(sce)$ensembl_gene_id)

# store assignments
saveRDS(assignments, file=snakemake@output[[1]])
