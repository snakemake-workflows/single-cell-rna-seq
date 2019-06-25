log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(SingleCellExperiment)
library(scran)
library(edgeR)

sce <- readRDS(snakemake@input[["sce"]])
for(cellassign_fit in snakemake@input[["cellassign_fits"]]) {
    cellassign_fit <- readRDS(cellassign_fit)$cell_type
    # assign determined cell types
    colData(sce)[rownames(cellassign_fit), "celltype"] <- sapply(cellassign_fit$cell_type, as.character)
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

write.table(topTags(qlf, n = 10000, p.value = snakemake@params[["fdr"]]), file = snakemake@output[["table"]], sep = "\t", col.names = NA, row.names = TRUE)

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
