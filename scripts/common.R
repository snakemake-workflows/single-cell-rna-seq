assign_celltypes <- function(cellassign_fit, sce) {
    cellassign_fit <- cellassign_fit$cell_type
    # assign determined cell types
    colData(sce)[rownames(cellassign_fit), "celltype"] <- sapply(cellassign_fit$cell_type, as.character)

    sce
}
