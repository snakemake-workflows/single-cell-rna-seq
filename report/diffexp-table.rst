{% set diffexp = snakemake.config["diffexp"][snakemake.wildcards.test] %}

Table of differentially expressed genes, calculated with edgeR_, as advised for single cell sequencing by `Soneson and Robinson 2018 <https://www.nature.com/articles/nmeth.4612>`_.
Analysis was conducted on {{ diffexp["celltypes"]|join(", ") }}, using the formula ``{{ diffexp["design"] }}`` to describe the covariate to consider. Differential expression was then tested for coefficient {{ diffexp["coef"] }}.


.. _edgeR: https://bioconductor.org/packages/release/bioc/html/edgeR.html
