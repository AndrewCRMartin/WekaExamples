export WEKA=${HOME}/weka-3-8-3/
export CLASSPATH="$WEKA/weka.jar"

BASEPATH=$(pwd)
INPUTS=${BASEPATH}/data/inputs.dat
DATA=${BASEPATH}/data/xval_dataset
#CLASSIFIER=weka.classifiers.functions.MultilayerPerceptron
#CLASSIFIER="weka.classifiers.trees.RandomForest -I 1000 -K 0"
CLASSIFIER="weka.classifiers.trees.RandomForest"
LIMIT=405
DRAWS=20

for ((i=1;i<=DRAWS;i++)); do
   csv2arff -v -norm -ni -skip -limit=${LIMIT} $INPUTS dataset $DATA/train${i}.csv > myh7_${LIMIT}_${i}_train.arff
   csv2arff -v -norm -ni -skip                  $INPUTS dataset $DATA/test${i}.csv  > myh7_${LIMIT}_${i}_test.arff

   for NTREE in 500 1000
   do
       echo "*** Training on set $i using NTREE=$NTREE ***"
       # train
       java $CLASSIFIER -I $NTREE -attribute-importance -x 10 -t myh7_${LIMIT}_${i}_train.arff -d myh7_${LIMIT}_${i}_RF_${NTREE}.model >myh7_${LIMIT}_${i}_RF_${NTREE}_train.out
       # test
       java $CLASSIFIER -T myh7_${LIMIT}_${i}_test.arff -l myh7_${LIMIT}_${i}_RF_${NTREE}.model >myh7_${LIMIT}_${i}_RF_${NTREE}.out   
   done
done

for NTREE in 500 1000
do
    echo ""
    echo "Results using $NTREE trees"
    echo "-------------------"
    echo "       MCC"
    echo "   ------------"
    echo "XVal    Independent"
    echo "-------------------"
    for ((i=1;i<=DRAWS;i++)); do
        trainMCC=`grep Weighted myh7_${LIMIT}_${i}_RF_${NTREE}_train.out | tail -1 | awk '{print $8}'`
        testMCC=`grep  Weighted myh7_${LIMIT}_${i}_RF_${NTREE}.out | tail -1 | awk '{print $8}'`
        echo "$trainMCC   $testMCC"
    done
    echo "-------------------"
done

# To apply the predictor to one or more examples where you wish to
# make an actual prediction you create a .arff file containing the
# example(s) but with the output set to '?' and then run as in testing
# but add the flag -p 0
# i.e.
# java $CLASSIFIER -T myinputfile.arff -p 0 -l mytrained.model 
