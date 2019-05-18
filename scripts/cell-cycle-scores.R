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
covariate <- gsub("-", ".", snakemake@wildcards[["covariate"]])
covariate.values <- unique(annotation[, covariate])
n <- length(covariate.values)

# plot
pdf(file=snakemake@output[[1]])
# set color palette
palette(brewer.pal(n=n, name="Dark2"))
plot(assignments$score$G1, assignments$score$G2M,
     xlab="G1 score", ylab="G2/M score", pch=16,
     col=annotation[, covariate])
legend("topright", legend=covariate.values, col=palette()[covariate.values], pch=16)
dev.off()
