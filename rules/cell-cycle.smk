# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule cell_cycle:
    input:
        rds="analysis/filtered-cells.rds",
        cells="cells.tsv"
    output:
        plt=expand("plots/cycle-scores.{col}.svg", col=cells.columns[1:]),
        assignments="analysis/cell-cycle-assignments.rds"
    params:
        species=config["species"],
        condition=config["condition"]
    log:
        "logs/cell-cycle.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/cell-cycle.R"
