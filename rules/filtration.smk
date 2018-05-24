rule filter_cells:
    input:
        "analysis/all.rds"
    output:
        rds="analysis/filtered-cells.rds",
        stats="tables/cell-filtering.tsv"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter-cells.R"


rule filter_genes:
    input:
        "analysis/filtered-cells.rds"
    output:
        rds="analysis/filtered.rds",
        hist="plots/avg-counts.svg",
        top_genes="plots/50-highest-genes.svg"
    params:
        threshold=config["filtering"]["min-avg-count"]
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter-genes.R"
