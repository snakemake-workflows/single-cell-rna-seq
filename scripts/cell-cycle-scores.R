# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")


library(RColorBrewer)

assignments <- readRDS(snakemake@input[["rds"]])
annotation <- read.table(snakemake@input[["cells"]], header=TRUE, row.names=1)
condition <- snakemake@wildcards[["condition"]]
condition.values <- unique(annotation[, condition])
n <- length(condition.values)

# plot
svg(file=snakemake@output[[1]])
# set color palette
palette(brewer.pal(n=n, name="Dark2"))
plot(assignments$score$G1, assignments$score$G2M,
     xlab="G1 score", ylab="G2/M score", pch=16,
     col=annotation[, condition])
legend("topright", legend=condition.values, col=palette()[condition.values], pch=16)
dev.off()
