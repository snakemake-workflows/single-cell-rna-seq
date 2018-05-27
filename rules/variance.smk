# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule hvg:
    input:
        "analysis/normalized.rds"
    output:
        var="analysis/variance.rds",
        hvg=report("tables/hvg.tsv", caption="report/hvg.rst")
        hvg_expr_dist=report("plots/hvg-expr-dists.svg",
                             caption="../report/hvg-expr-dists.rst"),
        mean_vs_variance=report("plots/mean-vs-variance.svg",
                                caption="../report/mean-vs-variance.rst")
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
        corr=report("tables/hvg-correlations.tsv",
                    caption="../report/hvg-correlations.rst"),
        graph=report("plots/hvg-clusters.svg",
                     caption="../report/hvg-clusters.rst")
        heatmap=report("plots/hvg-corr-heatmap.svg",
                       caption="../report/hvg-corr-heatmap.rst"),
        pca=report("plots/hvg-corr-pca.svg",
                   caption="../report/hvg-corr-pca.rst")
    log:
        "logs/hvg-correlation.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-correlation.R"
