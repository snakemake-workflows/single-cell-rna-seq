library(ComplexHeatmap)
library(viridis)

fit <- readRDS(snakemake@input[[1]])

svg(file = snakemake@output[[1]])
Heatmap(fit$gamma, col = viridis(100))
dev.off()
