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


rule explained_variance:
    input:
        rds="analysis/normalized.rds",
        cells="cells.tsv"
    output:
        "plots/explained-variance.svg"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/explained-variance.R"
