# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule qc:
    input:
        "analysis/all.rds"
    output:
        libsizes=report("plots/library-size.pdf",
                        caption="../report/library-size.rst",
                        category="Quality Control"),
        expressed=report("plots/expressed-genes.pdf",
                         caption="../report/expressed-genes.rst",
                         category="Quality Control"),
        mito_proportion=report("plots/mito-proportion.pdf",
                               caption="../report/mito-proportion.rst",
                               category="Quality Control"),
        spike_proportion=report("plots/spike-proportion.pdf",
                                caption="../report/spike-proportion.rst",
                                category="Quality Control")
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
        report("plots/explained-variance.pdf",
               caption="../report/explained-variance.rst",
               category="Quality Control")
    log:
        "logs/explained-variance.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/explained-variance.R"
