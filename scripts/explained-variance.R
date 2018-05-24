library(scater)
library(scran)

sce <- readRDS(snakemake@input[["rds"]])
annotation <- read.table(snakemake@input[["cells"]], row.names=1, header=TRUE)

svg(file=snakemake@output[[1]])
plotExplanatoryVariables(sce,
    variables=c("total_counts_Spike",
                "log10_total_counts_Spike",
                colnames(annotation))) + theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16)
)
dev.off()
