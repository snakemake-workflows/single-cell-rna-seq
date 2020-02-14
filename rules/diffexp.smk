def get_fits(wildcards):
    celltypes = config["diffexp"][wildcards.test].get("celltypes", [])
    if celltypes:
        try:
            parents = markers.loc[celltypes, "parent"].unique()
        except KeyError:
            raise WorkflowError(
                "Given celltypes {} not defined in markers "
                "(see config).".format(celltypes)
            )
    else:
        parents = markers["parent"].unique()
    return expand("analysis/cellassign.{parent}.rds", parent=parents)


rule edger:
    input:
        sce="analysis/normalized.batch-removed.rds",
        cellassign_fits=get_fits
    output:
        table=report("tables/diffexp.{test}.tsv", caption="../report/diffexp-table.rst", category="Differential Expression Analysis"),
        bcv=report("plots/diffexp.{test}.bcv.pdf", caption="../report/diffexp-bcv.rst", category="Differential Expression Analysis"),
        md=report("plots/diffexp.{test}.md.pdf", caption="../report/diffexp-md.rst", category="Differential Expression Analysis"),
        disp="plots/diffexp.{test}.disp.pdf",
        edger_dge="edger/{test}.dge.rds"
    log:
        "logs/edger/{test}.log"
    params:
        design=lambda w: config["diffexp"][w.test]["design"],
        constrain_celltypes=lambda w: config["diffexp"][w.test].get("constrain-celltypes", None),
        coef=lambda w: config["diffexp"][w.test]["coef"],
        fdr=lambda w: config["diffexp"][w.test]["fdr"],
        min_gamma=config["celltype"]["min_gamma"]
    conda:
        "../envs/edger.yaml"
    script:
        "../scripts/diffexp.R"


rule plot_expression:
    input:
        diffexp="tables/diffexp.{test}.tsv",
        edger_dge="edger/{test}.dge.rds"
    output:
        report("plots/expression/{gene}.{test}.expression.pdf", caption="../report/goi.rst", category="Differential Expression Analysis")
    params:
        coef=lambda w: config["diffexp"][w.test]["coef"]
    conda:
        "../envs/edger.yaml"
    script:
        "../scripts/plot-differential-expression.R"
