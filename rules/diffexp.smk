def get_fits(wildcards):
    celltypes = config["diffexp"][wildcards.test].get("celltypes", [])
    if celltypes:
        parents = markers.loc[celltypes, "parent"].unique()
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
        disp="plots/diffexp.{test}.disp.pdf"
    log:
        "logs/edger/{test}.log"
    params:
        design=lambda w: config["diffexp"][w.test]["design"],
        celltypes=lambda w: config["diffexp"][w.test]["celltypes"],
        coef=lambda w: config["diffexp"][w.test]["coef"],
        fdr=lambda w: config["diffexp"][w.test]["fdr"],
        exclude_coef=lambda w: config["diffexp"][w.test]["exclude-coefficients"]
    conda:
        "../envs/edger.yaml"
    script:
        "../scripts/diffexp.R"
