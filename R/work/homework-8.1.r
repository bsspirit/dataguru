#8.1
x1<-c(-1.9,-6.9,5.2,5.0,7.3,6.8,0.9,-12.5,1.5,3.8)
x2<-c(3.2,10.4,2.0,2.5,0,12.7,-15.4,-2.5,1.3,6.8)
d1<-data.frame(x1,x2)

x1<-c(0.2,-0.1,0.4,2.7,2.1,-4.6,-1.7,-2.6,2.6,-2.8)
x2<-c(0.2,7.5,14.6,8.3,0.8,4.3,10.9,13.1,12.8,10.0)
d2<-data.frame(x1,x2)

x1<-c(8.1)
x2<-c(2.0)
d3<-data.frame(x1,x2)
source("../discriminiant.distance.R")
discriminiant.distance(d1,d2)

source("../discriminiant.bayes.R")
discriminiant.bayes(as.matrix(d1),as.matrix(d2),rate=1,var.equal=TRUE)
discriminiant.bayes(as.matrix(d1),as.matrix(d2),rate=1,var.equal=FALSE)

source("../discriminiant.fisher.R")
discriminiant.fisher(d1,d2)
