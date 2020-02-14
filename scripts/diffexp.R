log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)
library(SingleCellExperiment)
library(scran)
library(edgeR)
library(dplyr)

source(file.path(snakemake@scriptdir, "common.R"))

sce <- readRDS(snakemake@input[["sce"]])
for(cellassign_fit in snakemake@input[["cellassign_fits"]]) {
    cellassign_fit <- readRDS(cellassign_fit)
    sce <- assign_celltypes(cellassign_fit, sce, snakemake@params[["min_gamma"]])
}
# handle constrain celltypes
constrain_celltypes <- snakemake@params[["constrain_celltypes"]]
if(!is.null(constrain_celltypes)) {
    celltypes <- constrain_celltypes[["celltypes"]]
    common_var <- constrain_celltypes[["common"]]

    sce <- sce[, colData(sce)$celltype %in% celltypes]

    if(!is.null(common_var)) {
        if(!(common_var %in% colnames(colData(sce)))) {
            stop(paste("covariate", common_var, "not found in cell metadata"))
        }
        is_common_in_all <- apply(table(colData(sce)[, c(common_var, "celltype")]) > 0, 1, all)
	common_in_all <- names(is_common_in_all)[is_common_in_all]
	sce <- sce[, colData(sce)[, common_var] %in% common_in_all]
        colData(sce) <- droplevels(colData(sce))
    }
}
# only keep the requested cells
if(length(snakemake@params[["celltypes"]]) > 0) {
    sce <- sce[, colData(sce)$celltype %in% snakemake@params[["celltypes"]]]
}
colData(sce)$celltype <- factor(colData(sce)$celltype)
colData(sce)$detection_rate <- cut(colData(sce)$detection_rate, 10)


# convert to edgeR input
y <- convertTo(sce, type = "edgeR", col.fields = colnames(colData(sce)))

# obtain design matrix
design <- model.matrix(as.formula(snakemake@params[["design"]]), data=y$samples)

y <- calcNormFactors(y)
y <- estimateDisp(y, design)
fit <- glmQLFit(y, design)
qlf <- glmQLFTest(fit, coef = snakemake@params[["coef"]])

saveRDS(y, file = snakemake@output[["edger_dge"]])

write_tsv(rownames_to_column(topTags(qlf, n = 100000)$table, var = "gene"), snakemake@output[["table"]])

pdf(file = snakemake@output[["bcv"]])
plotBCV(y)
dev.off()

pdf(file = snakemake@output[["md"]])
plotMD(qlf)
abline(h = c(-1,1), col = "grey")
dev.off()

pdf(file = snakemake@output[["disp"]])
plotQLDisp(fit)
dev.off()
