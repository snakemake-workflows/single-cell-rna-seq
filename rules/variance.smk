# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.


rule hvg:
    input:
        sce_norm="analysis/normalized.rds",
        sce_batch="analysis/normalized.batch-removed.rds",
        design_matrix="analysis/design-matrix.rds"
    output:
        var="analysis/variance.rds",
        hvg=report("tables/hvg.tsv",
                   caption="../report/hvg.rst",
                   category="Highly Variant Genes"),
        hvg_expr_dist=report("plots/hvg-expr-dists.svg",
                             caption="../report/hvg-expr-dists.rst",
                             category="Highly Variant Genes"),
        mean_vs_variance=report("plots/mean-vs-variance.svg",
                                caption="../report/mean-vs-variance.rst",
                                category="Highly Variant Genes")
    params:
        use_spikes=config["model"]["use-spikes"],
        min_bio_comp=config["model"]["min-bio-comp"],
        fdr=config["model"]["fdr"],
        show_n=config["model"]["show-n"]
    log:
        "logs/hvg.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg.R"


rule correlation:
    input:
        hvg="tables/hvg.tsv",
        sce="analysis/normalized.batch-removed.rds"
    output:
        corr=report("tables/hvg-correlations.tsv",
                    caption="../report/hvg-correlations.rst",
                    category="Highly Variant Genes"),
        graph=report("plots/hvg-clusters.svg",
                     caption="../report/hvg-clusters.rst",
                     category="Highly Variant Genes"),
        heatmap=report("plots/hvg-corr-heatmap.svg",
                       caption="../report/hvg-corr-heatmap.rst",
                       category="Highly Variant Genes"),
        pca=report("plots/hvg-corr-pca.svg",
                   caption="../report/hvg-corr-pca.rst",
                   category="Highly Variant Genes")
    params:
        fdr=config["model"]["fdr"]
    log:
        "logs/hvg-correlation.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-correlation.R"
