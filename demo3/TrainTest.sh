DATA=humVar_withNoErrorsNoMissing_PD50pctSNP50pct.key.header.csv
export WEKA=${HOME}/weka-3-8-3/
export CLASSPATH="$WEKA/weka.jar"

# Select a training option
#export CLASSIFIER=weka.classifiers.functions.MultilayerPerceptron
#export CLASSIFIER="weka.classifiers.trees.RandomForest -I 1000 -K 10"
export CLASSIFIER="weka.classifiers.trees.RandomForest"

# Cleanup
rm -f train_*.csv train_*.arff test_*.csv test_*.arff *.out

NFOLDS=20

# Split the dataset up for manual N-fold cross-validation
echo "Generating training and testing sets for cross-validation"
./xvalidate.pl -fold=$NFOLDS pd snp $DATA

for ((fold=0;fold<NFOLDS;fold++)); do
    echo -n "Running train/test fold $fold..."

    # Create the ARFF files for train and test
    csv2arff -norm inputs.dat dataset train_${fold}.csv >train_${fold}.arff
    csv2arff -norm inputs.dat dataset test_${fold}.csv  >test_${fold}.arff

    # Run the classifier
    # -t training data
    # -T testing data
    java $CLASSIFIER -t train_${fold}.arff -T test_${fold}.arff >HumVar_Fold_${fold}.out

    echo "done"
done

# Print the detailed performance information
echo "                 TP Rate  FP Rate  Precision  Recall   F-Measure  MCC      ROC Area  PRC Area"
for file in *.out; do grep -A 20 Detailed $file | tail -20 | grep Weighted; done

# Now calculate the average MCC (we make all values positive when doing this!)
(for file in *.out; do grep -A 20 Detailed $file | tail -20 | grep Weighted; done) | awk 'BEGIN {sum=0; fold=0} {d=$8; sum+=(d>0)?d:-d; fold++} END {print "Mean MCC: " sum/fold}'

# Cleanup again, but leave the .out files
rm -f train_* test_*
