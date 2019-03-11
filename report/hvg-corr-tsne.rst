t-SNE plot constructed from normalized log-expression values of correlated HVGs,
where each point represents a cell.

Cells were colored by {{ snakemake.wildcards.covariate }}.
T-SNE visualizations can be misleading, due to parameter choices and the fact
that it is non-deterministic. We therefore run t-SNE for different random seeds.
This plot shows results for seed={{ snakemake.wildcards.seed }}.
T-SNE results will only be usable for you if clustering is similar for different seeds.
See `here <https://distill.pub/2016/misread-tsne/>`_ for additional details.
