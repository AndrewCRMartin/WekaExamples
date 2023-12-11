

A very simple example that just converts a CSV file to ARFF and then
runs a default Random Forest (or MLP) and extracts the results of
internal cross-validation performed by Weka.

The example is for prediction of silent (SNP) vs pathogenic (PD)
mutations in proteins using structural effects calculated from the
humvar dataset.

Edit `train_test.sh` to ensure the WEKA environment variable points to
where you have installed WEKA and CLASSPATH to the weka.jar file.

Run the script by typing:
   ./train_test.sh

By default this will run a 10-fold cross-validation using a Random
Forest and extracts and prints the MCC.

Edit `train_test.sh` to comment out the RandomForest CLASSIFIER and
remove the comment in front of the MultilayerPerceptron CLASSIFIER to
try a neural network instead.

