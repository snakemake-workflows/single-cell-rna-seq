Marker definition used for typing cells with CellAssign_.
The first column shows the name of the cell type, the last column shows the list of marker genes that have to be expressed in the cell type.
An empty gene column instructs CellAssign_ to classify all cells that do not match the other defined types to this type.
The "parent" column allows to configure CellAssign_ to perform hierarchical classification.
First, types with no parent are classified.
Then, we recursively perform a subclassification for the subtypes under each parent.

.. _CellAssign: https://doi.org/10.1101/521914
