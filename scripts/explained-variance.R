# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)

sce <- readRDS(snakemake@input[["rds"]])
annotation <- read.table(snakemake@input[["cells"]], row.names=1, header=TRUE)

pdf(file=snakemake@output[[1]])
plotExplanatoryVariables(sce,
    variables=c("total_counts_Spike",
                "log10_total_counts_Spike",
                colnames(annotation))) + theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16)
)
dev.off()
