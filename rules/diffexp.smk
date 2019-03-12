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
        fits=get_fits
    output:
        "tables/diffexp.{test}.tsv"
    params:
        design=lambda w: config["diffexp"][w.test]["design"]
    conda:
        "../envs/edger.yaml"
    script:
        "../scripts/diffexp.R"
