# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)
library(ggsci)
library(ggpubr)
source(file.path(snakemake@scriptdir, "common.R"))

gene_a <- snakemake@wildcards[["gene_a"]]
gene_b <- snakemake@wildcards[["gene_b"]]

aes_name <- function(name) {
    paste0("`", name, "`")
}

sce <- readRDS(snakemake@input[["sce"]])
constrain_celltypes <- snakemake@params[["constrain_celltypes"]]

for(cellassign_fit in snakemake@input[["fits"]]) {
    cellassign_fit <- readRDS(cellassign_fit)
    sce <- assign_celltypes(cellassign_fit, sce, snakemake@params[["min_gamma"]], constrain_celltypes)
}

# handle constrain celltypes
if(!is.null(constrain_celltypes)) {
    celltypes <- constrain_celltypes
    print(celltypes)
    sce <- sce[, colData(sce)$celltype %in% celltypes]
}

pdf(file=snakemake@output[[1]], width = 4, height = 4)
data <- as.data.frame(t(logcounts(sce[c(gene_a, gene_b), ])))
vmin <- min(data)
vmax <- max(data)

regression <- snakemake@params[["regression"]]
correlation <- snakemake@params[["correlation"]]
dropout_threshold <- snakemake@params[["dropout_threshold"]]

data[, "dropout"] <- apply(data, 1, min) < dropout_threshold
non_dropout_data <- data[!data$dropout, ]

p <- ggplot(data, aes_string(x=aes_name(gene_a), y=aes_name(gene_b), color=aes_name("dropout"))) +
    geom_point(shape=1) + 
    scale_color_manual(values = c("#000000", "#666666")) +
    theme_classic() + 
    theme(legend.position = "none")

if(regression != FALSE) {
    regression <- as.formula(regression)
    p = p + geom_smooth(method="lm", color = "red", formula = formula, data = non_dropout_data) +
	    stat_regline_equation(data = non_dropout_data, label.x.npc = "left", label.y.npc = "top", formula = formula,
				  aes(label = paste(..eq.label.., ..rr.label.., ..adj.rr.label.., sep = "~~~~")))
}
if(correlation != FALSE) {
    p = p + stat_cor(method = correlation, data = non_dropout_data) + geom_smooth(method="lm", data = non_dropout_data, color = "red")
}

# pass plot to PDF
p

dev.off()
