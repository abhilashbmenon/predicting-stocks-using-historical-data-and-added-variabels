snpData=read.csv(file="SNPzScorerf.csv",header=T)
library(randomForest)
library(e1071)
library(caret)
library(reprtree)

#Setup the data 85% training 15% testing
sampleChoices=sample(c(0,1),length(snpData[[1]]),replace=T,prob=c(0.85,0.15))
trainSet=snpData[sampleChoices==0,]
testSet=snpData[sampleChoices==1,]

#Run the random Forest with importance selected
randomForestModel=randomForest(DiscreteProfit~High+Low+Volume+Close+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,trainSet,ntree=3000,importance=T)

#determine best attributes
attributeValue=data.frame(importance(randomForestModel,type=1))
attributeValue 	#Print MeanDecreaseAccuracy

#Predicting trainingSet 
trainSet$prediction=predict(randomForestModel,trainSet)

#predicting testingSet
testSet$prediction=predict(randomForestModel,testSet)
confusionMatrix(data=testSet$prediction,reference=testSet$DiscreteProfit)

#Print out the tree
reprtree:::plot.getTree(randomForestModel)

