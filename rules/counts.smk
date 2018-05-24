rule load_counts:
    input:
        counts="counts/all.tsv",
        cells="cells.tsv"
    output:
        "analysis/all.rds"
    params:
        spike_pattern=config["spike-ins"]["pattern"],
        species=config["species"]
    log:
        "logs/load-counts.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/load-counts.R"
