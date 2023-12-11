export WEKA=${HOME}/weka-3-8-3/
export CLASSPATH="$WEKA/weka.jar"

BASEPATH=$(pwd)
INPUTS=${BASEPATH}/data/inputs.dat
CSV=${BASEPATH}/data/pdsnp.csv
#CLASSIFIER=weka.classifiers.functions.MultilayerPerceptron
CLASSIFIER="weka.classifiers.trees.RandomForest"

csv2arff -v -norm -ni -skip $INPUTS dataset $CSV > pdsnp.arff

# Train and test using 10-fold cross-validation
java $CLASSIFIER -x 10 -t pdsnp.arff >pdsnp.out

echo -n "MCC = "
grep Weighted pdsnp.out | tail -1 | awk '{print $8}'
