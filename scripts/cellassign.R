library(SingleCellExperiment)
library(cellassign)
library(ComplexHeatmap)

sce <- readRDS(snakemake@input[["sce"]])
parent <- snakemake@wildcards[["parent"]]

# get parent fit and filter sce to those cells
parent_fit <- snakemake@input[["fit"]]
if(!is.empty(parent_fit)) {
    parent_fit <- readRDS(parent_fit)
    parent_type <- rownames(parent_fit[parent_fit$cell_type == parent])
    sce <- sce[, parent_type]
}

markers <- read.table(snakemake@input[["markers"]])
markers <- markers[markers$parent == parent, ]

# convert markers into something cellAssign understands
marker_list <- list()
for(i in 1:nrows(markers)) {
    marker_list[[markers[i, "name"]]] = strsplit(markers[i, "genes"], ",")
}
marker_mat <- marker_list_to_mat(marker_list)

# apply cellAssign
sce <- sce[rownames(marker_mat)]
fit <- cellassign(exprs_obj = sce, marker_gene_info = marker_mat, s = sizeFactors(sce), learning_rate = 1e-2, shrinkage = TRUE)

saveRDS(fit, file = snakemake@output[[1]])
