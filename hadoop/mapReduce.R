#MapReduce对PageRank进行实现
# n<-4
# a<-0.85
# S0<-t(matrix(c(0,0,0,0,1,0,0,1,1,1,0,0,1,1,1,0),nrow=n));
# S<-matrix(c(0,1/3,1/3,1/3,0,0,1/2,1/2,0,0,0,1,0,1,0,0),nrow=n)
# q<-matrix(rep(1),4)
# U<-matrix(rep(1,16),nrow=n)
# 
# A<-S[,1:2]
# B<-S[,3:4]
# 
# Ga<-a*A+(1-a)/n*U[,1:2]
# Gb<-a*B+(1-a)/n*U[,3:4]
# 
# for(i in 1:100){
#   qa<-as.matrix(q[1:2,])
#   qb<-as.matrix(q[3:4,])
#   q<-Ga%*%qa+Gb%*%qb
# }
# 
# print(q/sum(q));


map<-function(S0,node='a'){
  S<-apply(S0,2, function(x) x/sum(x))
  if(node=='a') S[,1:2] else S[,3:4]
}

reduce<-function(A,B,a=0.85,niter=100){
  n<-nrow(A)
  q<-rep(1,n)
  Ga<-a*A+(1-a)/n*(A*0+1)
  Gb<-a*B+(1-a)/n*(B*0+1)
  for(i in 1:niter){
    qa<-as.matrix(q[1:ncol(A)])
    qb<-as.matrix(q[(ncol(A)+1):n])
    q<-Ga%*%qa+Gb%*%qb
  }
  as.vector(q/sum(q))
}

S0<-t(matrix(c(0,0,0,0,1,0,0,1,1,1,0,0,1,1,1,0),nrow=4));
A<-map(S0,'a');
B<-map(S0,'b');
reduce(A,B)

