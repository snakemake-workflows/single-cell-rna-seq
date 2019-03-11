# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)

sce <- readRDS(snakemake@input[[1]])

# drop cells with too few counts or expressed features
libsize.drop <- isOutlier(sce$total_counts, nmads=3, type="lower", log=TRUE)
feature.drop <- isOutlier(sce$total_features_by_counts, nmads=3, type="lower", log=TRUE)

# drop cells with too high proportion of mito genes or spike-ins expressed
mito.drop <- isOutlier(sce$pct_counts_Mt, nmads=3, type="higher")
spike.drop <- isOutlier(sce$pct_counts_Spike, nmads=3, type="higher")

# write stats
stats <- data.frame(ByLibSize=sum(libsize.drop), ByFeature=sum(feature.drop),
     ByMito=sum(mito.drop), BySpike=sum(spike.drop), Remaining=ncol(sce))
write.table(stats, file=snakemake@output[["stats"]], sep='\t',
            row.names=FALSE, quote=FALSE)

# filter sce
sce <- sce[,!(libsize.drop | feature.drop | mito.drop | spike.drop)]

saveRDS(sce, file=snakemake@output[["rds"]])
