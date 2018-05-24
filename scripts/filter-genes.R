library(scater)

sce <- readRDS(snakemake@input[[1]])

threshold <- snakemake@params[["threshold"]]

ave.counts <- rowMeans(counts(sce))
keep <- ave.counts >= threshold


# plot hist of average counts and mark threshold
svg(file=snakemake@output[["hist"]])
hist(log10(ave.counts), breaks=100, main="", col="grey80",
     xlab=expression(Log[10]~"average count"))
abline(v=log10(threshold), col="blue", lwd=2, lty=2)
dev.off()


# plot top genes
svg(file=snakemake@output[["top_genes"]])
fontsize <- theme(axis.text=element_text(size=12), axis.title=element_text(size=16))
plotQC(sce, type = "highest-expression", n=50) + theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16)
)
dev.off()

sce <- sce[keep,]
saveRDS(sce, file=snakemake@output[["rds"]])
