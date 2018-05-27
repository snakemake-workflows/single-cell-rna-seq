# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule qc:
    input:
        "analysis/all.rds"
    output:
        libsizes=report("plots/library-size.svg",
                        caption="../report/library-size.rst"),
        expressed=report("plots/expressed-genes.svg",
                         caption="../report/expressed-genes.svg"),
        mito_proportion=report("plots/mito-proportion.svg",
                               caption="../report/mito-proportion.svg"),
        spike_proportion=report("plots/spike-proportion.svg",
                                caption="../report/spike-proportion.svg")
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
        report("plots/explained-variance.svg",
               caption="../report/explained-variance.rst")
    log:
        "logs/explained-variance.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/explained-variance.R"
