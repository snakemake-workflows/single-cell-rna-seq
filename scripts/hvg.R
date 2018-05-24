# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)

use.spikes <- snakemake@params[["use_spikes"]]

sce <- readRDS(snakemake@input[[1]])

var.fit <- trendVar(sce, use.spikes=use.spikes)
var.out <- decomposeVar(sce, var.fit)

# plot mean vs. variance (spikes are red)
svg(file=snakemake@output[["mean_vs_variance"]])
plot(var.out$mean, var.out$total, pch=16, cex=0.6, xlab="Mean log-expression",
     ylab="Variance of log-expression")
o <- order(var.out$mean)
lines(var.out$mean[o], var.out$tech[o], col="dodgerblue", lwd=2)
cur.spike <- isSpike(sce)
points(var.out$mean[cur.spike], var.out$total[cur.spike], col="red", pch=16)
dev.off()

# determine HVGs (highly variable genes)
hvg.out <- var.out[which(var.out$FDR <= 0.05 & var.out$bio >= 0.5),]
# sort
hvg.out <- hvg.out[order(hvg.out$bio, decreasing=TRUE),]

# store HVGs in table on disk
write.table(file=snakemake@output[["hvg"]], hvg.out, sep="\t", quote=FALSE, col.names=NA)

# plot expression distributions
svg(file=snakemake@output[["hvg_expr_dist"]])
plotExpression(sce, rownames(hvg.out)[1:20]) + theme(
    axis.text=element_text(size=12),
    axis.title=element_text(size=16)
)
dev.off()

# store variance estimates
saveRDS(var.out, file=snakemake@output[["var"]])
