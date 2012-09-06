# install.packages("arules")
library(arules)

data<-read.csv("0905.txt",header=TRUE,encoding="utf-8")
d <- as(split(data[,"item"], data[,"id"]), "transactions")
fre=eclat(d,parameter=list(support=0.01,maxlen=17))
summary(fre)