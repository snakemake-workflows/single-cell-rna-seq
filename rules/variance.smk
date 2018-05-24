# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule hvg:
    input:
        "analysis/normalized.rds"
    output:
        var="analysis/variance.rds",
        hvg="tables/hvg.tsv",
        hvg_expr_dist="plots/hvg-expr-dists.svg",
        mean_vs_variance="plots/mean-vs-variance.svg"
    params:
        use_spikes=config["variance"]["use-spikes"]
    log:
        "logs/hvg.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg.R"


rule correlation:
    input:
        hvg="tables/hvg.tsv",
        rds="analysis/normalized.rds"
    output:
        corr="tables/hvg-correlations.tsv",
        graph="plots/hvg-clusters.svg",
        heatmap="plots/hvg-corr-heatmap.svg",
        pca="plots/hvg-corr-pca.svg"
    log:
        "logs/hvg-correlation.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-correlation.R"
