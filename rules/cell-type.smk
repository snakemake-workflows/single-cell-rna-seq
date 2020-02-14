def get_parent_fit(wildcards):
    if wildcards.parent != "root":
        parent = markers.loc[wildcards.parent, "parent"]
        return f"analysis/cellassign.{parent}.rds"
    else:
        return []


rule cellassign:
    input:
        sce="analysis/normalized.batch-removed.rds",
        markers=report(config["celltype"]["markers"], caption="../report/markers.rst", category="Cell Type Classification"),
        fit=get_parent_fit,
        design_matrix="analysis/design-matrix.rds"
    output:
        fit="analysis/cellassign.{parent}.rds",
        heatmap=report("plots/celltype-markers.{parent}.pdf", caption="../report/celltype-markers.rst", category="Cell Type Classification")
    params:
        min_gamma=config["celltype"]["min_gamma"]
    log:
        "logs/cellassign/{parent}.log"
    conda:
        "../envs/cellassign.yaml"
    threads:
        1000 # cellassign always uses the entire CPU
    script:
        "../scripts/cellassign.R"


rule plot_cellassign:
    input:
        "analysis/cellassign.{parent}.rds"
    output:
        report("plots/cellassign.{parent}.pdf", caption="../report/cellassign.rst", category="Cell Type Classification")
    log:
        "logs/cellassign/{parent}.plot.log"
    conda:
        "../envs/heatmap.yaml"
    script:
        "../scripts/plot-cellassign.R"


rule celltype_tsne:
    input:
        sce="analysis/normalized.batch-removed.rds",
        fits=expand("analysis/cellassign.{parent}.rds", parent=markers["parent"].unique())
    output:
        report("plots/celltype-tsne.{parent}.seed={seed}.pdf",
                   caption="../report/celltype-tsne.rst",
                   category="Dimension Reduction")
    params:
        min_gamma=config["celltype"]["min_gamma"],
        parents=markers["parent"].unique()
    log:
        "logs/celltype-tsne/{parent}.seed={seed}.log"
    conda:
        "../envs/eval.yaml"
    wildcard_constraints:
        seed="[0-9]+"
    script:
        "../scripts/celltype-tsne.R"


rule plot_celltype_expressions:
    input:
        sce="analysis/normalized.batch-removed.rds",
        fit="analysis/cellassign.{parent}.rds"
    output:
        report("plots/celltype-expressions.{parent}.pdf", caption="../report/celltype-expressions.rst", category="Cell Type Classification")
    params:
        min_gamma=config["celltype"]["min_gamma"],
        genes=config["celltype"]["expression-plot-genes"],
        feature="celltype"
    log:
        "logs/plot-celltype-expressions/{parent}.log"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/plot-gene-expression.R"
