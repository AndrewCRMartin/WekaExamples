This example shows the use of an ANN to predict phenotype (HCM or DCM)
based on analysis of mutations in cardiac beta myosin.

Edit the file `train_test.sh` to reflect the directory where Weka installed
and run by typing:

./train_test.sh

For this particular problem, the data are very unbalanced (many more
HCMs than DCMs). The script builds 10 models using all 60 DCMs and a
random selection of 60 HCMs.

Cross-validation is done within Weka and the MCC is averaged across
all models.

By changing the 'export CLASSIFIER' line, you can swap between an ANN
and a Random Forest classifier.

This example also demonstrates how csv2arff is able to reject data
lines in the CSV file that contain the wrong number of fields.
