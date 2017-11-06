setwd("C://PhD//CPSC8650//Project//Data")
library("neuralnet")
set.seed(1516)
snpData=read.csv(file="SNPzScore.csv",header=TRUE)

lengthy=length(snpData[[1]])
start=1
predictions=NULL	#vector for predicted values
actualProfit=NULL	#vector for actual continuous values

#Sliding window for-loop
for(i in 1:50)#(lengthy-30))
{
	#Setup the training and testing sets
	trainingSet=snpData[start:(start+29),]
	testingSet=snpData[start+30,]
	start=start+1

	#Build the Neural Network	
	snpNet=neuralnet(Close~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,trainSet,hidden=c(28),lifesign="minimal",threshold=0.1,algorithm='backprop',learningrate=0.001,act.fct="tanh")

	#Apply neuralNet to testingSet
	tempTestSet=subset(testingSet,select=c("High","Low","Volume","Open","X5SMA","X30SMA","X200SMA","CornClose","OilPrices","Volatility","MACD","adjUSDollarIndex","AvgTrueRange"))

	#Compute & show what results produced
	snpNetPredictions=compute(snpNet,tempTestSet)
	predictedValues=data.frame(real=testingSet$Close,predicted=snpNetPredictions$net.result)

	#Fill vectors for comparison outside of the for-loop
	predictions[i]=predictedValues$predicted
	actualProfit[i]=predictedValues$real
}


plot(snpNet,rep="best",show.weights=FALSE)
x11()

#un-normalize values for price visualization
dollarPredictions=((predictions*207.4315)+1961.128)
dollarActual=((actualProfit*207.4315)+1961.128)
plot(dollarPredictions,type='l',col='#0000FF60',lty=2)
lines(dollarActual,type='l')

mean(dollarPredictions-dollarActual)
sd(dollarPredictions-dollarActual)

