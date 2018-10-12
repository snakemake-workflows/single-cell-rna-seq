Genes/transcripts identified as highly variable (HVGs).

We identify HVGs to focus on the genes that are driving heterogeneity across the
population of cells. This requires estimation of the variance in expression for
each gene, followed by decomposition of the variance into biological and
technical components. HVGs are then identified as those genes with the largest
biological components. This avoids prioritizing genes that are highly variable
due to technical factors such as sampling noise during RNA capture and library
preparation. See
`Lun et al. (2016) <https://doi.org/10.12688/f1000research.9501.2>`_.

{% if snakemake.params.use_spikes -%}
Variance was estimated by fitting a mean-variance trend to spike-in transcript
expressions.
{% else -%}
Variance was estimated by fitting a mean-variance trend to endogenous features,
assuming that most of them do not vary across cells.
{%- endif %}
Then, we considered all genes with a minimum average difference in
true (biological) log2 expression of {{ snakemake.params.min_bio_comp }} between any two cells and an associated FDR of
{{ snakemake.params.fdr }}.
