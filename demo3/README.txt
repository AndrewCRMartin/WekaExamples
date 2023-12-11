This example is for prediction of silent (SNP) vs pathogenic (PD)
mutations in proteins using structural effects calculated from the
humvar dataset.

It's based on a very early and limited version of our final predictor
for SAAPpred (which performs much better than this!). For a start,
there are 1111 SNPs and 2260 PDs in the dataset so it is rather
imbalanced and we had to sort that out for proper training. We also
have mappings of each mutation to multiple structures for the real
thing (here we just have one structure for each mutation).

The first column in the CSV file is a mutation identifier of the form
   pdbcode:chain:resnum:mutation

Each mutation only occurs once, but there may be multiple different
mutations in the same PDB file. This can artificially advantage the
predictions, so we do manual cross-validation outside Weka: we want to
ensure that we don't have the same PDB file in train and test rather
than just ensuring we don't have the same mutation (in the same
protein). The real version ensures that we don't have the same uniprot
code rather than the same PDB file.




