#!/bin/bash

# Right now this is just a simple proof of concept. No quantitative eval is performed
# but instead the qualitative results are displayed.

# Make sure you set your data path. This will likely by your openbr/data directory.
if [ -z "$DATA" ]; then
    INRIA_PATH=../data/INRIAPerson
else
    INRIA_PATH=$DATA/INRIAPerson
fi

ALG="Open+Cvt(Gray)+BuildScales(Blur(2)+LBP(1,2)+SlidingWindow(Hist(59)+Cat+LDA(isBinary=true),windowWidth=10,takeLargestScale=false,threshold=2),windowWidth=10,takeLargestScale=false,minScale=4)+Discard"

# Josh's new algorithm (in progress)
# ALG="Open+Cvt(Gray)+Detector(Gradient+Bin(0,360,9,true)+Merge+Integral+IntegralSlidingWindow(RecursiveIntegralSampler(2,2,0,PCA(0.95))+Cat+LDA(0.95,isBinary=true)))"

#TEST=testSmall.xml
TEST=test.xml

br -useGui 0 \
   -algorithm "${ALG}" \
   -path $INRIA_PATH/img \
   -train $INRIA_PATH/sigset/train.xml pedModel \
   -enroll $INRIA_PATH/sigset/$TEST pedResults.xml

br -evalDetection pedResults.xml $INRIA_PATH/sigset/$TEST pedEvalResults.csv \
   -plotDetection pedEvalResults.csv pedPlots.pdf

#br -parallelism 0 -algorithm Open+Draw+Show -path $INRIA_PATH/img -enroll pedResults.xml
