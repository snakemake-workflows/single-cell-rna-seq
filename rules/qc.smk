rule load_counts:
    input:
        counts="counts/all.tsv",
        cells="cells.tsv"
    output:
        "analysis/all.rds"
    params:
        spike_pattern=config["spike_pattern"]
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/load-counts.R"


rule qc:
    input:
        "analysis/all.rds"
    output:
        libsizes="plots/library-size.svg",
        expressed="plots/expressed-genes.svg",
        mito_proportion="plots/mito-proportion.svg",
        spike_proportion="plots/spike-proportion.svg"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/qc.R"



rule filter_cells:
    input:
        "analysis/all.rds"
    output:
        rds="analysis/filtered.rds",
        stats="tables/filtering.tsv"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/filter.R"


rule cell_cycle:
    input:
        "analysis/filtered.rds"
    output:
        plt="plots/cycle-scores.svg",
        assignments="analysis/cell-cycle-assignments.rds"
    params:
        species=config["species"]
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/cell-cycle.R"
