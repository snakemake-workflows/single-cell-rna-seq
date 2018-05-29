Single cell data analysis was performed as outlined by `Lun et al. (2016)`_, using Scran_ and Scater_.
After cell and gene filtration (see Filtration_), raw counts were normalized with `Scater` using a linear scaling approach.
In the following, the covariates {{ snakemake.config["model"]["variables"]|join(', ') }} were considered to cause technical variation.
Per-gene biological variance was estimated by fitting a mean-variance trend model using above covariates as design matrix (see hvg.tsv_).
Subsequently, the covariates were used to remove batch effects from normalized expressions.
Finally, highly variable genes/transcripts (HVGs) were extracted from the trend model and their pairwise correlation was analyzed (see Results_ for details).



.. _Scater: https://bioconductor.org/packages/release/bioc/html/scater.html
.. _Scran: https://bioconductor.org/packages/release/bioc/html/scran.html
.. _Lun et al. (2016): https://dx.doi.org/10.12688/f1000research.9501.2
