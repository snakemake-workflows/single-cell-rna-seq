rule normalize:
    input:
        "analysis/filtered.rds"
    output:
        rds="analysis/normalized.rds",
        scatter="plots/size-factors-vs-libsize.svg"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/normalize.R"
