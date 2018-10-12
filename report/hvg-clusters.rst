Larger sets of correlated features were assembled by treating features as nodes
in a graph and each pair of features with significantly large
(:math:`FDR \geq {{snakemake.params.fdr}}`) correlations as an edge.
Clusters in this graph represent a set of correlated features.
See `Lun et al. (2016) <https://doi.org/10.12688/f1000research.9501.2>`_.
