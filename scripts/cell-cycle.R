# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)
library(RColorBrewer)

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

annotation <- read.table(snakemake@input[["cells"]], row.names=1)

# read trained data
pairs <- readRDS(system.file("exdata", markers, package="scran"))
# obtain assignments
assignments <- cyclone(sce, pairs, gene.names=rownames(sce))
# store assignments
saveRDS(assignments, file=snakemake@output[["assignments"]])

for(i in 1:ncol(annotation)) {
    conditions <- annotation[, i]
    out <- snakemake@output[["plt"]][i]

    # plot
    svg(file=out)
    # set color palette
    palette(brewer.pal(n=length(conditions), name="Dark2"))
    plot(assignments$score$G1, assignments$score$G2M,
         xlab="G1 score", ylab="G2/M score", pch=16,
         col=meta[, condition])
    legend("topright", legend=conditions, col=palette()[conditions], pch=16)
    dev.off()
}
