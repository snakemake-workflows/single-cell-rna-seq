library(scater)
library(scran)
library(RColorBrewer)

sce <- readRDS(snakemake@input[[1]])

# determine cell cycle
species = snakemake@params[["species"]]
if (species == "mouse") {
    markers <- "mouse_cycle_markers.rds"
} else if (species == "human") {
    markers <- "human_cycle_markers.rds"
}

# condition to highlight in plot
condition = snakemake@params[["condition"]]

# read trained data
pairs <- readRDS(system.file("exdata", markers, package="scran"))
# obtain assignments
assignments <- cyclone(sce, pairs, gene.names=rownames(sce))

# load metadata
meta <- colData(sce)
conditions <- unique(meta[, condition])

# plot
svg(file=snakemake@output[["plt"]])
# set color palette
palette(brewer.pal(n=length(conditions), name="Dark2"))
plot(assignments$score$G1, assignments$score$G2M,
     xlab="G1 score", ylab="G2/M score", pch=16,
     col=meta[, condition])
legend("topright", legend=conditions, col=palette()[conditions], pch=16)
dev.off()

# store assignments
saveRDS(assignments, file=snakemake@output[["assignments"]])
