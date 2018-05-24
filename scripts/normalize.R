library(scater)
library(scran)

sce <- readRDS(snakemake@input[[1]])

sce <- computeSumFactors(sce, sizes=c(20, 40, 60, 80))

svg(file=snakemake@output[["scatter"]])
plot(sizeFactors(sce), sce$total_counts/1e6, log="xy",
     ylab="Library size (millions)", xlab="Size factor")
dev.off()

sce <- computeSpikeFactors(sce, type="Spike", general.use=FALSE)
sce <- normalize(sce)

saveRDS(sce, file=snakemake@output[["rds"]])
