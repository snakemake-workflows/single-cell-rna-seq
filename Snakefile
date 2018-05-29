# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.
from snakemake.utils import validate
import pandas as pd


########## load config an cell sheet ############

configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

cells = pd.read_table(config["cells"]).set_index("id", drop=False)
validate(cells, schema="schemas/cells.schema.yaml")


targets_qc = [
    "plots/library-size.svg",
    "plots/expressed-genes.svg",
    "plots/mito-proportion.svg",
    "plots/spike-proportion.svg",
    "plots/explained-variance.svg"
]


######## target rules ##############

rule all:
    input:
        targets_qc,
        "plots/hvg-expr-dists.svg",
        "plots/mean-vs-variance.svg",
        "tables/hvg.tsv",
        "tables/hvg-correlations.tsv",
        "plots/hvg-clusters.svg",
        "plots/hvg-corr-heatmap.svg",
        "plots/hvg-corr-pca.svg",
        expand("plots/cycle-scores.{covariate}.svg",
               covariate=cells.columns[1:]),
        expand("plots/hvg-pca.{covariate}.svg",
               covariate=cells.columns[1:])


rule all_qc:
    input:
        targets_qc


##### setup singularity #####

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"


##### setup report #####

report: "report/workflow.rst"


##### load rules #####

include: "rules/counts.smk"
include: "rules/qc.smk"
include: "rules/filtration.smk"
include: "rules/cell-cycle.smk"
include: "rules/normalization.smk"
include: "rules/variance.smk"
