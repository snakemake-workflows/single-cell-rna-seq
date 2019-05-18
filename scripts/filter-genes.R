# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)

sce <- readRDS(snakemake@input[[1]])

threshold <- snakemake@params[["threshold"]]

ave.counts <- rowMeans(counts(sce))
keep <- ave.counts >= threshold


# plot hist of average counts and mark threshold
pdf(file=snakemake@output[["hist"]])
hist(log10(ave.counts), breaks=100, main="", col="grey80",
     xlab=expression(Log[10]~"average count"))
abline(v=log10(threshold), col="blue", lwd=2, lty=2)
dev.off()


# plot top genes
pdf(file=snakemake@output[["top_genes"]])
fontsize <- theme(axis.text=element_text(size=12), axis.title=element_text(size=16))
plotQC(sce, type="highest-expression", n=50) + theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16)
)
dev.off()

sce <- sce[keep, ]
saveRDS(sce, file=snakemake@output[["rds"]])
