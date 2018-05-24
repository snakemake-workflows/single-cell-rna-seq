library(scater)
library(scran)

all.counts <- as.matrix(read.table(snakemake@input[["counts"]], row.names=1, header=TRUE))
all.annotation <- read.table(snakemake@input[["cells"]], row.names=1, header=TRUE)
sce <- SingleCellExperiment(
  assays = list(counts = all.counts),
  colData = all.annotation
)

# TODO use proper annotation for this
is.mito <- grepl("^mt-", rownames(sce))

# annotate spike-ins
is.spike <- grepl(snakemake@params[["spike_pattern"]], rownames(sce))
isSpike(sce, "Spike") <- is.spike

# calculate metrics
sce <- calculateQCMetrics(sce, feature_controls=list(Spike=is.spike, Mt=is.mito))

saveRDS(sce, file=snakemake@output[[1]])
