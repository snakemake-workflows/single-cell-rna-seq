log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(ComplexHeatmap)
library(viridis)

set.seed(562374)

fit <- readRDS(snakemake@input[[1]])

pdf(file = snakemake@output[[1]])
Heatmap(fit$mle_params$gamma, col = viridis(100), clustering_distance_rows = "canberra", use_raster = TRUE, show_row_dend = FALSE, show_column_dend = FALSE, show_row_names = FALSE)
dev.off()
