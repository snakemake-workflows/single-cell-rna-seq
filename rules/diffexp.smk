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
        table="tables/diffexp.{test}.tsv",
        bcv="plots/diffexp.{test}.bcv.pdf",
        md="plots/diffexp.{test}.md.pdf",
        disp="plots/diffexp.{test}.disp.pdf"
    params:
        design=lambda w: config["diffexp"][w.test]["design"],
        celltypes=lambda w: config["diffexp"][w.test]["celltypes"],
        coef=lambda w: config["diffexp"][w.test]["coef"]
    conda:
        "../envs/edger.yaml"
    script:
        "../scripts/diffexp.R"
