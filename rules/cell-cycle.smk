rule cell_cycle:
    input:
        "analysis/filtered-cells.rds"
    output:
        plt="plots/cycle-scores.svg",
        assignments="analysis/cell-cycle-assignments.rds"
    params:
        species=config["species"],
        condition=config["condition"]
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/cell-cycle.R"
