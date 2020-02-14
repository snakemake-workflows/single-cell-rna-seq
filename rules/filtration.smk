# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule filter_cells:
    input:
        "analysis/all.rds"
    output:
        rds="analysis/filtered.rds",
        stats=report("tables/cell-filtering.tsv",
                     caption="../report/filtering.rst",
                     category="Filtration")
    log:
        "logs/filter-cells.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter-cells.R"


