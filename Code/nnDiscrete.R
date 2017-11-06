library("neuralnet")
set.seed(1516)
snpData=read.csv(file="SNPzScore.csv",header=TRUE)

lengthy=length(snpData[[1]])
start=1
predictions=NULL	#vector for predicted values
actualProfit=NULL	#vector for actual discrete values
ProbitVals=NULL	#vector for Probit regression values

#Sliding window for-loop
for(i in 1:(lengthy-30))
{
	#Setup the training and testing sets
	trainingSet=snpData[start:(start+29),]
	testingSet=snpData[start+30,]
	start=start+1

	#Build the Neural Network	
	snpNet=neuralnet(DiscreteProfit~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,trainingSet,hidden=c(28),lifesign="minimal",threshold=0.1,algorithm='backprop',learningrate=0.001,err.fct='sse')

	#Apply neuralNet to testingSet
	tempTestSet=subset(testingSet,select=c("High","Low","Volume","Open","X5SMA","X30SMA","X200SMA","CornClose","OilPrices","Volatility","MACD","adjUSDollarIndex","AvgTrueRange"))

	#Probit Regression
	probitModel=glm(DiscreteProfit~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,family=binomial(link="probit"),data=trainingSet)
	predictedProbit=predict(probitModel,testingSet,type="response")
	ProbitVals[i]=round(predictedProbit)	#vector to hold probit predictions

	#Compute & show what results produced
	snpNetPredictions=compute(snpNet,tempTestSet)
	predictedValues=data.frame(real=testingSet$DiscreteProfit,predicted=snpNetPredictions$net.result)
	predictedValues$predicted=round(predictedValues$predicted)

	#Fill vectors for comparison outside of the for-loop
	predictions[i]=predictedValues$predicted
	actualProfit[i]=predictedValues$real
}
sum(predictions==actualProfit)/length(predictions)
sum(ProbitVals==actualProfit)/length(ProbitVals)