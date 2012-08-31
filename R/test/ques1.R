#http://cos.name/cn/topic/107827
row<-nrow(mtcars)

for(i in 1:100){
  lines<-round(runif(100,1,row))
  rbind(dat,colSums(mtcars[lines,]))
}



#http://cos.name/cn/topic/107832