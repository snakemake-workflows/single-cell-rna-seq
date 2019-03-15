# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.
from snakemake.utils import validate
import pandas as pd


########## load config an cell sheet ############

configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

cells = pd.read_csv(config["cells"], sep="\t").set_index("id", drop=False)
validate(cells, schema="schemas/cells.schema.yaml")

markers = None
if "markers" in config.get("celltype", {}):
    markers = pd.read_csv(config["celltype"]["markers"], sep="\t").set_index("name", drop=False)
    markers.loc[:, "parent"].fillna("root", inplace=True)


targets_qc = [
    "plots/library-size.pdf",
    "plots/expressed-genes.pdf",
    "plots/mito-proportion.pdf",
    "plots/spike-proportion.pdf",
    "plots/explained-variance.pdf"
]


######## target rules ##############

rule all:
    input:
        targets_qc,
        "plots/hvg-expr-dists.pdf",
        "plots/mean-vs-variance.pdf",
        "tables/hvg.tsv",
        "tables/hvg-correlations.tsv",
        "plots/hvg-clusters.pdf",
        "plots/hvg-corr-heatmap.pdf",
        expand("plots/cycle-scores.{covariate}.pdf",
               covariate=cells.columns[1:]),
        expand("plots/hvg-pca.{covariate}.pdf",
               covariate=cells.columns[1:]),
        expand("plots/hvg-tsne.{covariate}.seed={seed}.pdf",
               covariate=cells.columns[1:],
               seed=[23213, 789789, 897354]),
        expand("plots/cellassign.{parent}.pdf",
               parent=markers["parent"].unique()),
        expand("plots/celltype-tsne.seed={seed}.pdf",
               seed=[23213, 789789, 897354]),
        expand(["tables/diffexp.{test}.tsv",
                "plots/diffexp.{test}.bcv.pdf",
                "plots/diffexp.{test}.md.pdf",
                "plots/diffexp.{test}.disp.pdf"],
               test=config["diffexp"])


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
include: "rules/cell-type.smk"
include: "rules/diffexp.smk"
