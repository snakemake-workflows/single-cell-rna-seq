# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(scater)
library(scran)

##### taken from scater 1.8.0                    #####
##### TODO remove once switching to scater 1.8.0 #####
uniquifyFeatureNames <- function(ID, names) {
    if (length(ID)!=length(names)) {
        stop("lengths of 'ID' and 'names' must be equal")
    }
    missing.name <- is.na(names)
    names[missing.name] <- ID[missing.name]
    dup.name <- names %in% names[duplicated(names)]
    names[dup.name] <- paste0(names[dup.name], "_", ID[dup.name])
    return(names)
}
######################################################


all.counts <- as.matrix(read.table(snakemake@input[["counts"]], row.names=1, header=TRUE))
all.annotation <- read.table(snakemake@input[["cells"]], row.names=1, header=TRUE)
sce <- SingleCellExperiment(
  assays = list(counts = all.counts),
  colData = all.annotation
)

# get feature annotation
species = snakemake@params[["species"]]
if (species == "mouse") {
    dataset <- "mmusculus_gene_ensembl"
    symbol <- "mgi_symbol"
} else if (species == "human") {
    dataset <- "hsapiens_gene_ensembl"
    symbol <- "hgnc_symbol"
} else {
    stop("Unsupported species. Only mouse and human are supported.")
}

sce <- getBMFeatureAnnos(sce, filters=c("ensembl_gene_id"), attributes = c("ensembl_gene_id", symbol, "chromosome_name", "gene_biotype", "start_position", "end_position"), dataset=dataset)
rowData(sce)[, "gene_symbol"] <- rowData(sce)[, symbol]
rownames(sce) <- uniquifyFeatureNames(rownames(sce), rowData(sce)$gene_symbol)

# get mitochondrial genes
is.mito <- colData(sce)$chromosome_name == "MT"

# annotate spike-ins
is.spike <- grepl(snakemake@params[["spike_pattern"]], rownames(sce))
isSpike(sce, "Spike") <- is.spike

# calculate metrics
sce <- calculateQCMetrics(sce, feature_controls=list(Spike=is.spike, Mt=is.mito))

saveRDS(sce, file=snakemake@output[[1]])
