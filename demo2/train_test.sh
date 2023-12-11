export WEKA=${HOME}/weka-3-8-3
export CLASSPATH="$WEKA/weka.jar"
export CLASSIFIER=weka.classifiers.functions.MultilayerPerceptron
#export CLASSIFIER="weka.classifiers.trees.RandomForest -I 100 -K 10"

# clean up from previous run
rm -f *.out *.arff *.model

# For each of 10 models (which we call n1...n10)
for model in n1 n2 n3 n4 n5 n6 n7 n8 n9 n10
do
    echo ""
    echo "Running model $model"
    echo "================="

    # -class - only keep records with output class HCM or DCM
    # -auto  - reject attributes that are the same for all instances
    # -limit - only keep 60 examples from each class
    csv2arff -class=HCM,DCM -auto -limit=60 -norm inputs.txt phenotype phenotype.csv >${model}.arff
    java $CLASSIFIER -d ${model}.model -t ${model}.arff  >${model}.out
done

echo "                 TP Rate  FP Rate  Precision  Recall   F-Measure  MCC      ROC Area  PRC Area"
cat *.out | grep -A 20 Stratified | grep Weighted
cat *.out | grep -A 20 Stratified | grep Weighted | awk 'BEGIN {sum=0; fold=0} {sum+=$8; fold++} END {print "Mean MCC: " sum/fold}'
