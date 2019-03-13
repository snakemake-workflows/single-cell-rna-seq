def get_parent_fit(wildcards):
    if wildcards.parent != "root":
        parent = markers.loc[wildcards.parent, "parent"]
        return f"analysis/cellassign.{parent}.rds"
    else:
        return []


rule cellassign:
    input:
        sce="analysis/normalized.batch-removed.rds",
        markers=config["celltype"]["markers"],
        fit=get_parent_fit
    output:
        "analysis/cellassign.{parent}.rds"
    conda:
        "../envs/cellassign.yaml"
    threads:
        1000 # cellassign always uses the entire CPU
    script:
        "../scripts/cellassign.R"


rule annotate_cellassign_fit:
    input:
        sce="analysis/normalized.batch-removed.rds",
        fit="analysis/cellassign.{parent}.rds"
    output:
        "analysis/cellassign.{parent}.annotated.rds"
    conda:
        "../envs/cellassign.yaml"
    script:
        "../scripts/annotate-cellassign.R"


rule plot_cellassign:
    input:
        "analysis/cellassign.{parent}.rds"
    output:
        "plots/cellassign.{parent}.svg"
    conda:
        "../envs/heatmap.yaml"
    script:
        "../scripts/plot-cellassign.R"

