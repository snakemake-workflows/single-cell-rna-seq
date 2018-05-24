# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule filter_cells:
    input:
        "analysis/all.rds"
    output:
        rds="analysis/filtered-cells.rds",
        stats=report("tables/cell-filtering.tsv",
                     caption="report/filtering.rst")
    log:
        "logs/filter-cells.log"
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
    log:
        "logs/filter-genes.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter-genes.R"
