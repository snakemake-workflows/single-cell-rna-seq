assign_celltypes <- function(cellassign_fit, sce, min_gamma, constrain_celltypes=NULL) {
    max_gamma <- apply(cellassign_fit$mle_params$gamma, 1, max)
    # only consider cases where we are certain
    cell_type <- cellassign_fit$cell_type[max_gamma >= min_gamma,, drop=FALSE]

    if(!is.null(constrain_celltypes)) {
      
      matching_cells <- sapply(cell_type, as.character) %in% constrain_celltypes
      
      if(sum(matching_cells) == 0) {
        warning("Zero cells matching constrain_celltypes. May break sce object colData. Check or adjust constrain-celltypes in config.")
      }
      
      cell_type <- cell_type[matching_cells,, drop=FALSE]
    }

    # assign determined cell types
    colData(sce)[rownames(cell_type), "celltype"] <- sapply(cell_type, as.character)

    sce
}
