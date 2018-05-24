# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule normalize:
    input:
        "analysis/filtered.rds"
    output:
        rds="analysis/normalized.rds",
        scatter="plots/size-factors-vs-libsize.svg"
    log:
        "logs/normalize.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/normalize.R"
