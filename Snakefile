# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: "config.yaml"


rule all:
    input:
        "tables/filtering.tsv",
        "plots/library-size.svg",
        "plots/expressed-genes.svg",
        "plots/mito-proportion.svg",
        "plots/spike-proportion.svg",
        "plots/cycle-scores.svg"
        # The first rule should define the default target files
        # Subsequent target rules can be specified below. They should start with all_*.


include: "rules/qc.smk"
include: "rules/filtration.smk"
include: "rules/cell-cycle.smk"
include: "rules/normalization.smk"
include: "rules/variance.smk"
