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


def get_gene_vs_gene_config(wildcards):
    return config["gene-vs-gene-plots"][wildcards.settings]

def get_constrain_celltypes(wildcards):
    return get_gene_vs_gene_config(wildcards).get("constrain-celltypes")


def get_gene_vs_gene_fits(wildcards):
    constrain_celltypes = get_constrain_celltypes(wildcards)
    constrained_markers = markers
    if constrain_celltypes:
        constrained_markers = markers.loc[markers["name"].isin(constrain_celltypes)]
    return expand("analysis/cellassign.{parent}.rds", parent=constrained_markers["parent"].unique())
    


rule gene_vs_gene:
    input:
        sce="analysis/normalized.batch-removed.rds",
        fits=get_gene_vs_gene_fits
    output:
        report("plots/gene-vs-gene/{gene_a}-vs-{gene_b}.{settings}.expressions.pdf",
                   caption="../report/gene-vs-gene-plot.rst",
                   category="Gene vs Gene Comparisons")
    params:
        min_gamma=config["celltype"]["min_gamma"],
        constrain_celltypes=get_constrain_celltypes,
        regression=lambda w: get_gene_vs_gene_config(w).get("regression", False),
        correlation=lambda w: get_gene_vs_gene_config(w).get("correlation", False),
        dropout_threshold=config["model"]["dropout-threshold"]
    log:
        "logs/gene-vs-gene/{gene_a}-vs-{gene_b}.{settings}.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/plot-gene-gene-expression.R"


rule gene_tsne:
    input:
        sce="analysis/normalized.batch-removed.rds"
    output:
        report("plots/gene-tsne/{gene}.tsne.seed={seed}.pdf",
               caption="../report/gene-tsne.rst",
               category="Dimension Reduction")
    log:
        "logs/gene-tsne/{gene}.seed={seed}.log"
    conda:
        "../envs/eval.yaml"
    wildcard_constraints:
        seed="[0-9]+"
    script:
        "../scripts/gene-tsne.R"
