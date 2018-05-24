# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule qc:
    input:
        "analysis/all.rds"
    output:
        libsizes="plots/library-size.svg",
        expressed="plots/expressed-genes.svg",
        mito_proportion="plots/mito-proportion.svg",
        spike_proportion="plots/spike-proportion.svg"
    log:
        "logs/qc.log"
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
    log:
        "logs/explained-variance.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/explained-variance.R"
