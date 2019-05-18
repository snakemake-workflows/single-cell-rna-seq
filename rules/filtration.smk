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
                     caption="../report/filtering.rst",
                     category="Filtration")
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
        hist=report("plots/avg-counts.pdf",
                    caption="../report/avg-counts.rst",
                    category="Filtration"),
        top_genes=report("plots/50-highest-genes.pdf",
                         caption="../report/50-highest-genes.rst",
                         category="Filtration")
    params:
        threshold=config["filtering"]["min-avg-count"]
    log:
        "logs/filter-genes.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter-genes.R"
