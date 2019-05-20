# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)
library(RBGL)
library(Rgraphviz)
library(gplots)


fdr <- snakemake@params[["fdr"]]
sce <- readRDS(snakemake@input[["sce"]])
hvgs <- read.table(snakemake@input[["hvg"]], row.names=1)

topn <- min(nrow(hvgs), snakemake@params[["top_n"]])
hvgs <- hvgs[1:topn, ]

# find correlated pairs
set.seed(100)
var.cor <- correlatePairs(sce, subset.row=rownames(hvgs))
sig.cor <- var.cor$FDR <= fdr
write.table(file=snakemake@output[["corr"]], var.cor, sep="\t", quote=FALSE, row.names=FALSE)


# define graph with significant correlation as edges
g <- ftM2graphNEL(cbind(var.cor$gene1, var.cor$gene2)[sig.cor,],
     W=NULL, V=NULL, edgemode="undirected")
# find highly connected clusters
cl <- highlyConnSG(g)$clusters
cl <- cl[order(lengths(cl), decreasing=TRUE)]


# plot correlation graph
pdf(file=snakemake@output[["graph"]])
plot(g, "neato", attrs=list(node=list(fillcolor="lightblue", color="lightblue")))
dev.off()


# choose significantly correlated genes
chosen <- unique(c(var.cor$gene1[sig.cor], var.cor$gene2[sig.cor]))
# get normalized expressions
norm.exprs <- logcounts(sce)[chosen,,drop=FALSE]


# plot heatmap
pdf(file=snakemake@output[["heatmap"]])
# z-score
heat.vals <- norm.exprs - rowMeans(norm.exprs)
heat.out <- heatmap.2(heat.vals, col=bluered, symbreak=TRUE, trace="none", cexRow=0.6)
dev.off()
