#nerve方法

read.sms<-function(file){
  data<-read.csv(file,header=FALSE,sep=" ",skip=1)
  data<-data[,-ncol(data)]
  names(data)<-c("num", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "Y")
  data
}
sms<-read.sms("20120821.txt")[,-c(5,6,7,8)]

source("distinguish.distance.R")
distinguish.distance(X, G, var.equal = TRUE)


# library(AMORE)
# 
# net <- newff(n.neurons=c(4,2,1), learning.rate.global=0.1, momentum.global=0.00004,
#              error.criterium="LMS", Stao=NA, hidden.layer="tansig", 
#              output.layer="purelin", method="ADAPTgdwm")
# 
# result=train(net,sms[,c(2,4,6,8)],as.matrix(as.numeric(sms[,9])),
#              error.criterium="LMS",report=TRUE,show.step=100,n.shows=5)


# sms0821=read.table("20120821.txt",header=T)
# sms0822=read.table("20120822.txt",header=T)
# sms0823=read.table("20120823.txt",header=T)
# sms0824=read.table("20120824.txt",header=T)
# sms0825=read.table("20120825.txt",header=T)
# sms0826=read.table("20120826.txt",header=T)
# sms0827=read.table("20120827.txt",header=T)
#sms=rbind(sms0821,sms0822,sms0823,sms0824,sms0825,sms0826)
library(AMORE)
#c(2,5,1)说明输入节点个数为2，5个隐藏层，输出节点个数为1
net <- newff(n.neurons=c(4,2,1), learning.rate.global=0.1, momentum.global=0.00004,
             error.criterium="LMS", Stao=NA, hidden.layer="tansig", 
             output.layer="purelin", method="ADAPTgdwm")
result=train(net,sms[,c(2,4,6,8)],as.matrix(as.numeric(sms[,9])),error.criterium="LMS",report=TRUE,show.step=100,n.shows=5)
y <- sim(result$net, sms0827[,c(2,4,6,8)])