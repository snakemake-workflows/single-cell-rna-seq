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

seeds = [23213, 789789, 897354]

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
               seed=seeds),
        expand("plots/cellassign.{parent}.pdf",
               parent=markers["parent"].unique()),
        expand("plots/celltype-tsne.{parent}.seed={seed}.pdf",
               seed=seeds,
               parent=markers["parent"].unique()),
        expand("plots/gene-tsne/{gene}.tsne.seed={seed}.pdf",
               seed=seeds,
               gene=config["celltype"]["expression-plot-genes"]),
        expand(["tables/diffexp.{test}.tsv",
                "plots/diffexp.{test}.bcv.pdf",
                "plots/diffexp.{test}.md.pdf",
                "plots/diffexp.{test}.disp.pdf"],
               test=config["diffexp"]),
        [expand("plots/expression/{gene}.{test}.expression.pdf", test=name, gene=test["genes_of_interest"])
         for name, test in config["diffexp"].items()],
        expand("plots/celltype-expressions.{parent}.pdf", parent=markers["parent"].unique()),
        [expand("plots/gene-vs-gene/{x}-vs-{y}.{settings}.expressions.pdf", 
                x=entry["pairs"]["x"], y=y, settings=settings)
         for settings, entry in config["gene-vs-gene-plots"].items()
         for y in entry["pairs"]["y"]]


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
