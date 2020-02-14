library(tidyverse)
library(edgeR)

gene_of_interest <- snakemake@wildcards[["gene"]]
coef <- snakemake@params[["coef"]]

diffexp <- read_tsv(snakemake@input[["diffexp"]])
y <- readRDS(snakemake@input[["edger_dge"]])

log_cpm <- as_tibble(cpm(y, log=TRUE), rownames="gene") %>% gather(key = "cell", value = "cpm", -gene) %>% filter(gene == gene_of_interest)

if (nrow(log_cpm) == 0) {
    stop(paste("Error: gene not found:", gene_of_interest))
}

log_cpm <- log_cpm %>% mutate(condition = as.factor(y$design[, coef]))

diffexp <- diffexp %>% filter(gene == gene_of_interest)

fmt_float <- function(x) {
    formatC(x, digits=2, format="g")
}
coef_name <- colnames(y$design)[coef]
pdf(file = snakemake@output[[1]])
ggplot(log_cpm, aes(x = condition, y = cpm, fill = condition)) + geom_violin() + geom_jitter(alpha = 0.5, size = 1) + labs(fill = coef_name, title = gene_of_interest, subtitle = paste("p =", fmt_float(diffexp$PValue), ", FDR =",  fmt_float(diffexp$FDR), ", log2fc =", fmt_float(diffexp$logFC))) + theme_classic()
dev.off()
