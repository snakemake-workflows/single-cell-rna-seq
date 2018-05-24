# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule normalize:
    input:
        "analysis/filtered.rds"
    output:
        rds="analysis/normalized.rds",
        scatter=report("plots/size-factors-vs-libsize.svg",
                       caption="report/size-factors.rst")
    log:
        "logs/normalize.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/normalize.R"
