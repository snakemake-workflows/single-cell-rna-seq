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
                   category="Highly Variable Genes"),
        hvg_expr_dist=report("plots/hvg-expr-dists.pdf",
                             caption="../report/hvg-expr-dists.rst",
                             category="Highly Variable Genes"),
        mean_vs_variance=report("plots/mean-vs-variance.pdf",
                                caption="../report/mean-vs-variance.rst",
                                category="Highly Variable Genes")
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
                    category="Highly Variable Genes"),
        graph=report("plots/hvg-clusters.pdf",
                     caption="../report/hvg-clusters.rst",
                     category="Highly Variable Genes"),
        heatmap=report("plots/hvg-corr-heatmap.pdf",
                       caption="../report/hvg-corr-heatmap.rst",
                       category="Highly Variable Genes")
    params:
        fdr=config["model"]["fdr"],
        top_n=config["model"]["top-n"]
    log:
        "logs/hvg-correlation.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-correlation.R"


rule hvg_pca:
    input:
        sce="analysis/normalized.batch-removed.rds",
        var_cor="tables/hvg-correlations.tsv"
    output:
        report("plots/hvg-pca.{covariate}.pdf",
                   caption="../report/hvg-corr-pca.rst",
                   category="Dimension Reduction")
    params:
        fdr=config["model"]["fdr"]
    log:
        "logs/hvg-pca.{covariate}.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-pca.R"


rule hvg_tsne:
    input:
        sce="analysis/normalized.batch-removed.rds",
        var_cor="tables/hvg-correlations.tsv"
    output:
        report("plots/hvg-tsne.{covariate}.seed={seed}.pdf",
                   caption="../report/hvg-corr-tsne.rst",
                   category="Dimension Reduction")
    params:
        fdr=config["model"]["fdr"]
    log:
        "logs/hvg-tsne.{covariate}.seed={seed}.log"
    conda:
        "../envs/eval.yaml"
    wildcard_constraints:
        seed="[0-9]+"
    script:
        "../scripts/hvg-tsne.R"
