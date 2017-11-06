library("neuralnet")
set.seed(1516)
snpData=read.csv(file="SNPzScore.csv",header=T)
head(snpData)

lengthy=length(snpData[[1]])
start=1
predictions=NULL
actualProfit=NULL
for(i in 1:(lengthy-30))
{
	#Setup the training and testing sets
	trainSet=snpData[start:(start+29),]
	testSet=snpData[start+30,]
	start=start+1

	#Build the Neural Network
#	snpNet=neuralnet(DiscreteProfit~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,trainSet,hidden=c(8,5),lifesign="minimal",linear.output=TRUE,threshold=0.1,act.fct='tanh',err.fct='sse',learningrate=0.001)
	snpNet=neuralnet(Close~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,trainSet,hidden=c(8,5),lifesign="minimal",linear.output=TRUE,threshold=0.1,act.fct='tanh')#,err.fct='sse')#,learningrate=0.001)

#	snpNet=neuralnet(DiscreteProfit~Volatility+Open+Volume+AvgTrueRange+OilPrices,trainSet,hidden=c(8,5),lifesign="minimal",linear.output=TRUE,threshold=0.3,act.fct='tanh',err.fct='sse',learningrate=0.001)
#	snpNet=neuralnet(Close~Volatility+Open+Volume+AvgTrueRange+OilPrices,trainSet,hidden=c(8,5),lifesign="minimal",linear.output=TRUE,threshold=0.3,act.fct='tanh',err.fct='sse',learningrate=0.001)

	
	#visualize
	#plot(snpNet,rep="best")
	
	#apply neuralNet to test set

	temp_test=subset(testSet,select=c("High","Low","Volume","Open","X5SMA","X30SMA","X200SMA","CornClose","OilPrices","Volatility","MACD","adjUSDollarIndex","AvgTrueRange"))
#	temp_test=subset(testSet,select=c("Volatility","Open","Volume","AvgTrueRange","OilPrices"))




	snpNet.results=compute(snpNet,temp_test)
#	head(temp_test)

	#Show what the neuralNet produced:
	results=data.frame(actual=testSet$Close,prediction=snpNet.results$net.result)
#	results=data.frame(actual=testSet$DiscreteProfit,prediction=snpNet.results$net.result)
#	results$prediction=round(results$prediction)
	#results[0:50,]

	predictions[i]=results$prediction
	actualProfit[i]=results$actual
}
sum(predictions==actualProfit)/length(predictions)
plot(snpNet,rep="best")
x11()
dollarPredictions=((predictions*207.4315)+1961.128)
dollarActual=((actualProfit*207.4315)+1961.128)
plot(dollarPredictions,type='l')
lines(dollarActual,type='l',col='red')

model1=glm(Close~High+Low+Volume+Open+X5SMA+X30SMA+X200SMA+CornClose+OilPrices+Volatility+MACD+adjUSDollarIndex+AvgTrueRange,data=snpData)
mean(abs(dollarPredictions-dollarActual))
sd(abs(dollarPredictions-dollarActual))