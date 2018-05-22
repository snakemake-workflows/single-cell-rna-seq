library(scater)
library(scran)

sce <- readRDS(snakemake@input[[1]])

# determine cell cycle
species = snakemake@params[["species"]]
if (species == "mouse") {
    markers <- "mouse_cycle_markers.rds"
} else if (species == "human") {
    markers <- "human_cycle_markers.rds"
}

pairs <- readRDS(system.file("exdata", markers, package="scran"))
assignments <- cyclone(sce, pairs, gene.names=rownames(sce))

svg(file=snakemake@output[["plt"]])
plot(assignments$score$G1, assignments$score$G2M,
     xlab="G1 score", ylab="G2/M score", pch=16)
dev.off()


saveRDS(assignments, file=snakemake@output[["assignments"]])
