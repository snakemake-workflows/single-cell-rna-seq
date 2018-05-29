# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)

fdr <- snakemake@params[["fdr"]]
covariate <- gsub("-", ".", snakemake@wildcards[["covariate"]])
sce <- readRDS(snakemake@input[["sce"]])
var.cor <- read.table(snakemake@input[["var_cor"]], header=TRUE)
sig.cor <- var.cor$FDR <= fdr

# choose significantly correlated genes
chosen <- unique(c(var.cor$gene1[sig.cor], var.cor$gene2[sig.cor]))

style <- theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16))

# plot PCA
svg(file=snakemake@output[[1]])
plotPCA(sce, colour_by=covariate,
        feature_set=chosen, ncomponents=3) + style
dev.off()
