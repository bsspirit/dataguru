#  a b c
#a 0 1 1
#b 1 0 1
#c 0 0 0


fn<-function(m){
  n=nrow(m)
  result<-rep(0,n)
  lm<-matrix(rep(0,n^2),nrow=n)
  
  lm[which(lower.tri(m))]<-m[which(lower.tri(m))]
  um<-t(lm)
  
  num<-which(upper.tri(m))
  node<-num[which(m[num] == um[num] &  um[num] == 1)]
  
  col<-ceiling(node/n)
  row<-node %% n
  
  for(i in 1:length(col)) result[col[i]]<-result[col[i]]+1  
  for(i in 1:length(row)) result[row[i]]<-result[row[i]]+1
  result
}


m<-matrix(c(0,1,1,1,0,1,0,0,0),byrow=TRUE,nrow=3);m
fn(m)

m<-matrix(c(0,1,1,1,0,1,1,0,0),byrow=TRUE,nrow=3);m
fn(m)

m<-matrix(c(1,1,0,1,1,0,0,0,0,1,1,0,1,1,0,0),byrow=TRUE,nrow=4);m
fn(m)

