This is a more complete version of the previous demo.

It deals with balancing the datasets (LIMIT1=405 is the number of
examples in the smaller dataset so we are limiting the larger dataset
to that size). We do this DRAWS times over.

We do cross-validation and also calculate the MCC on an independent
test set.

We try both 500 and 1000 trees.
