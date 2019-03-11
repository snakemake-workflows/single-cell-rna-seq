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
model.vars <- colData(sce)
model.vars$G1 <- cycle.assignments$scores$G1
model.vars$G2M <- cycle.assignments$scores$G2M

# setup design matrix
model <- ~ 1
for (variable in snakemake@params[["model_variables"]]) {
    model <- update(model, ~ . + model.vars[, variable])
}
design <- model.matrix(model)
colnames(design) <- snakemake@params[["model_variables"]]

# store design matrix
saveRDS(design, file=snakemake@output[["design_matrix"]])

# remove batch effects based on variables
batch.removed <- removeBatchEffect(normcounts(sce), covariates=model.vars[, snakemake@params[["model_variables"]]])
normcounts(sce) <- batch.removed
saveRDS(sce, file=snakemake@output[["sce"]])
