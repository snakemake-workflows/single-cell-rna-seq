Size factors for normalization were calculated by pooling counts from many cells and then deconvolving the obtained pooled size factors for individual cells (`Lun et al (2016) <https://doi.org/10.1186/s13059-016-0947-7>`_).
In this plot, each point is a cell, showing the estimated size factor vs. the library size.
For spike-ins, size factors were calculated separately, as these should not be affected by library size.
Then, size factors have been used to normalize counts into log-transformed expressions where cell-specific biases are removed.
Thereby log-transformation provides a variance stabilization: high abundance genes no longer dominate downstream analysis.
See `Lun et al. (2016) <https://doi.org/10.12688/f1000research.9501.2>`_.
