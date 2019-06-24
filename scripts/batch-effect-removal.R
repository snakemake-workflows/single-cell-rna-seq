# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(limma)

sce <- readRDS(snakemake@input[["sce"]])
cycle.assignments <- readRDS(snakemake@input[["cycles"]])
colData(sce)$G1 <- cycle.assignments$scores$G1
colData(sce)$G2M <- cycle.assignments$scores$G2M

# setup design matrix
model <- snakemake@params[["model"]]
design <- model.matrix(as.formula(model), data=colData(sce))

# store design matrix
saveRDS(design, file=snakemake@output[["design_matrix"]])

# remove batch effects based on variables
batch.removed <- removeBatchEffect(logcounts(sce), covariates=design)
logcounts(sce) <- batch.removed
saveRDS(sce, file=snakemake@output[["sce"]])
