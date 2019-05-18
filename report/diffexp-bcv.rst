We distinguish biological and technical variation, summarized by 

.. math::

    \text{total CV}^2 = \text{technical CV}^2 + \text{biological CV}^2.

The technical CV decreases as the size of the counts increases. 
Biological CV (BCV) on the other hand does not.
BCV is therefore likely to be the dominant source of uncertainty for high-count genes.
This plot shows the biological coefficient of variation (BCV) as estimated by edgeR_.
For details, see the edgeR-manual_.

.. _edgeR: https://bioconductor.org/packages/release/bioc/html/edgeR.html
.. _edgeR-manual: https://www.bioconductor.org/packages/devel/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf
