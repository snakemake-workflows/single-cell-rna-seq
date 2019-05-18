Single cell data analysis was performed as outlined by `Lun et al. (2016)`_, using Scran_ and Scater_.
After cell and gene filtration (see Filtration_), raw counts were normalized with `Scater` using a linear scaling approach.
In the following, the covariates {{ snakemake.config["model"]["variables"]|join(', ') }} were considered to cause technical variation.
Per-gene biological variance was estimated by fitting a mean-variance trend model using above covariates as design matrix (see hvg.tsv_).
Subsequently, the covariates were used to remove batch effects from normalized expressions.
Next, highly variable genes/transcripts (HVGs) were extracted from the trend model and their pairwise correlation was analyzed (see Results_ for details).

{% if snakemake.config["diffexp"] %}
Differential expression analysis was performed with edgeR_, as advised by `Soneson and Robinson 2018 <https://www.nature.com/articles/nmeth.4612>`_.
{% endif %}
{% if snakemake.config["celltype"] %}
Cell types were assigned to each cell via CellAssign_, using predefined marker genes.
{% endif %}

.. _CellAssign: https://doi.org/10.1101/521914
.. _edgeR: https://bioconductor.org/packages/release/bioc/html/edgeR.html
.. _Scater: https://bioconductor.org/packages/release/bioc/html/scater.html
.. _Scran: https://bioconductor.org/packages/release/bioc/html/scran.html
.. _Lun et al. (2016): https://doi.org/10.12688/f1000research.9501.2
