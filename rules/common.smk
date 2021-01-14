def get_parent_cellassign_fit(wildcards):
    if wildcards.parent != "root":
        parent = markers.loc[wildcards.parent, "parent"]
        return f"analysis/cellassign.{parent}.rds"
    else:
        return []


def get_cellassign_fits(wildcards):
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


def get_gene_vs_gene_config(wildcards):
    return config["gene-vs-gene-plots"][wildcards.settings]


def get_constrain_celltypes(wildcards):
    return get_gene_vs_gene_config(wildcards).get("constrain-celltypes")


def get_gene_vs_gene_cellassign_fits(wildcards):
    constrain_celltypes = get_constrain_celltypes(wildcards)
    constrained_markers = markers
    if constrain_celltypes:
        constrained_markers = markers.loc[markers["name"].isin(constrain_celltypes)]
    return expand(
        "analysis/cellassign.{parent}.rds",
        parent=constrained_markers["parent"].unique(),
    )
