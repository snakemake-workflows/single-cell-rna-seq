# this is needed to make tensorflow happy
Sys.setenv(MKL_THREADING_LAYER = "GNU")

library(SingleCellExperiment)
library(cellassign)

sce <- readRDS(snakemake@input[["sce"]])
parent <- snakemake@wildcards[["parent"]]

# get parent fit and filter sce to those cells
parent_fit <- snakemake@input[["fit"]]
if(length(parent_fit) > 0) {
    parent_fit <- readRDS(parent_fit)
    parent_type <- rownames(parent_fit[parent_fit$cell_type == parent])
    sce <- sce[, parent_type]
}

markers <- read.table(snakemake@input[["markers"]], row.names = NULL, header = TRUE, sep="\t", stringsAsFactors = FALSE, na.strings = "")
markers[is.na(markers$parent), "parent"] <- "root"
markers <- markers[markers$parent == parent, ]

# convert markers into something cellAssign understands
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
marker_list <- list()
for(i in 1:nrow(markers)) {
    marker_list[[markers[i, "name"]]] = sapply(strsplit(markers[i, "genes"], ","), trim)
}
marker_mat <- marker_list_to_mat(marker_list)
marker_mat <- marker_mat[rownames(marker_mat) %in% rownames(sce), ]


# apply cellAssign
sce <- sce[rownames(marker_mat), ]
fit <- cellassign(exprs_obj = sce, marker_gene_info = marker_mat, s = sizeFactors(sce), learning_rate = 1e-2, shrinkage = TRUE)

saveRDS(fit, file = snakemake@output[[1]])
