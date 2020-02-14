# this is needed to make tensorflow happy
Sys.setenv(MKL_THREADING_LAYER = "GNU")

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(SingleCellExperiment)
library(tensorflow)
library(cellassign)
library(ComplexHeatmap)
library(viridis)
library(ggsci)

is.float <- function(x) {
    (typeof(x) == "double") && (x %% 1 != 0)
}

sce <- readRDS(snakemake@input[["sce"]])
parent <- snakemake@wildcards[["parent"]]

# get parent fit and filter sce to those cells
parent_fit <- snakemake@input[["fit"]]
if(length(parent_fit) > 0) {
    parent_fit <- readRDS(parent_fit)$cell_type
    is_parent_type <- rownames(parent_fit)[parent_fit$cell_type == parent]
    sce <- sce[, is_parent_type]
}

markers <- read.table(snakemake@input[["markers"]], row.names = NULL, header = TRUE, sep="\t", stringsAsFactors = FALSE, na.strings = "")
markers[is.na(markers$parent), "parent"] <- "root"
markers <- markers[markers$parent == parent, ]

# convert markers into something cellAssign understands
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
get_genes <- function (x) {
    if(is.na(x)) {
        vector()
    } else {
        sapply(strsplit(x, ","), trim)
    }
}
genes <- vector()
for(g in markers$genes) {
    genes <- c(genes, get_genes(g))
}
genes <- sort(unique(genes))

if(length(genes) < 1) {
    stop("Markers have to contain at least two different genes in union.")
}

marker_mat <- matrix(0, nrow = nrow(markers), ncol = length(genes))
colnames(marker_mat) <- genes
rownames(marker_mat) <- markers$name
for(i in 1:nrow(markers)) {
    cell_type <- markers[i, "name"]
    marker_mat[cell_type, ] <- genes %in% get_genes(markers[i, "genes"])
}
marker_mat <- t(marker_mat)
marker_mat <- marker_mat[rownames(marker_mat) %in% rownames(sce),, drop=FALSE]


# apply cellAssign
sce <- sce[rownames(marker_mat), ]
# remove genes with 0 counts in all cells and cells with 0 counts in all genes
sce <- sce[rowSums(counts(sce)) != 0, colSums(counts(sce)) != 0]
# obtain batch effect model
model <- readRDS(snakemake@input[["design_matrix"]])
# constrain to selected cells and remove intercept (not allowed for cellassign)
model <- model[colnames(sce), colnames(model) != "(Intercept)"]
# normalize float columns (as recommended in cellassign manual)
float_cols <- apply(model, 2, is.float)
model[, float_cols] <- apply(model[, float_cols], 2, scale)
if(nrow(sce) == 0) {
    stop("Markers do not match any gene names in the count matrix.")
}
# fit
fit <- cellassign(exprs_obj = sce, marker_gene_info = marker_mat, s = sizeFactors(sce), learning_rate = 1e-2, B = 20, shrinkage = TRUE, X = model)

# add cell names to results
cells <- colnames(sce)
rownames(fit$mle_params$gamma) <- cells
fit$cell_type <- data.frame(cell_type = fit$cell_type)
rownames(fit$cell_type) <- cells

saveRDS(fit, file = snakemake@output[["fit"]])

save.image()
# plot heatmap
source(file.path(snakemake@scriptdir, "common.R"))
sce <- assign_celltypes(fit, sce, snakemake@params[["min_gamma"]])

pdf(file = snakemake@output[["heatmap"]])
pal <- pal_d3("category20")(ncol(marker_mat))
names(pal) <- colnames(marker_mat)
celltype <- HeatmapAnnotation(df = data.frame(celltype = colData(sce)$celltype), col = list(celltype = pal))
Heatmap(logcounts(sce), col = viridis(100), clustering_distance_columns = "canberra", clustering_distance_rows = "canberra", use_raster = TRUE, show_row_dend = FALSE, show_column_dend = FALSE, show_column_names = FALSE, top_annotation = celltype, name = "logcounts")
dev.off()
