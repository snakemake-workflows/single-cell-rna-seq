# Copyright 2018 Johannes Köster.
# Licensed under the MIT license (http://opensource.org/licenses/MIT)
# This file may not be copied, modified, or distributed
# except according to those terms.
from snakemake.utils import validate
import pandas as pd


configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

cells = pd.read_table("cells.tsv").set_index("id", drop=False)
validate(cells, schema="schemas/cells.schema.yaml")


rule all:
    input:
        "plots/library-size.svg",
        "plots/expressed-genes.svg",
        "plots/mito-proportion.svg",
        "plots/spike-proportion.svg",
        "plots/hvg-expr-dists.svg",
        "plots/mean-vs-variance.svg",
        "tables/hvg.tsv",
        "tables/hvg-correlations.tsv",
        "plots/hvg-clusters.svg",
        "plots/hvg-corr-heatmap.svg",
        "plots/hvg-corr-pca.svg",
        expand("plots/cycle-scores.{condition}.svg",
               condition=cells.columns[1:])


include: "rules/counts.smk"
include: "rules/qc.smk"
include: "rules/filtration.smk"
include: "rules/cell-cycle.smk"
include: "rules/normalization.smk"
include: "rules/variance.smk"
