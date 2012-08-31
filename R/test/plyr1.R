#A quick introduction to plyr.pdf
library(plyr)

#e.g.1
dat = read.table(textConnection(
'ID value
1 4
1 7
2 8
2 3
2 3'), header = TRUE)
ddply(dat, "ID", transform, sum= sum(value))

#e.g.2
y<-c(1,2,3)
f<-function(x) x^2
sapply(y,f)
f(y)

#e.g.3
set.seed(1)
d<-data.frame(year=rep(2000:2002,each=3),count=round(runif(9,0,20)))
print(d)
ddply(d,"year",function(x){
  mean.count<-mean(x$count)
  sd.count<-sd(x$count)
  cv<-sd.count/mean.count
  data.frame(cv.count=cv)
})

#summarise，合并
ddply(d, "year", summarise, mean.count = mean(count))
#transform，不合并
ddply(d, "year", transform, total.count = sum(count))

#install.packages("foreach")
library(foreach)
system.time(ddply(d, "year", summarise, mean.count = mean(count)))
system.time(ddply(d, "year", summarise, mean.count = mean(count),.parallel=TRUE))


#e.g.4
f<-function(x) if(x==1) stop("ERROR!!") else 1
safe.f<-failwith(NA,f,quiet=TRUE)
llply(1:2,safe.f)

#e.g.5
x<-c(1:10)
wait<-function(i) Sys.sleep(0.1)
system.time(llply(x,wait))
system.time(sapply(x,wait))


#install.packages("doMC") for linux
#install.packages("doSMP") for windows
library(doMC)
registerDoMC(2)
system.time(llply(x, wait, .parallel = TRUE))









