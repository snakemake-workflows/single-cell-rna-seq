library(SingleCellExperiment)
library(edgeR)
library(dplyr)

sce <- readRDS(snakemake@input[["sce"]])

for(cellassign_fit in snakemake@input[["cellassign_fits"]]) {
    cellassign_fit <- readRDS(cellassign_fit)
    # assign determined cell types
    colData(sce)[rownames(cellassign_fit), "celltype"] <- cellassign_fit$cell_type
}
# only keep the requested cells
sce <- sce[, colData(sce)$celltype %in% snakemake@params[["celltypes"]]]

# convert ot edgeR input
y <- convertTo(sce, type="edgeR")

design <- model.matrix(eval(snakemake@params[["design"]]))
y <- estimateDisp(y, design)
fit <- glmQLFit(y, design)
qlf <- glmQLFTest(fit, coef=2) # TODO what number to use here in general?

write.table(qlf, file=snakemake@output[[1]])
