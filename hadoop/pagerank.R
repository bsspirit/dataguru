#求4个网页的Page Rank值
#公式：G=a*S + (1-a)*(1/n)*U

#http://florence.acadiau.ca/collab/hugh_public/index.php?title=R:pagerank
pagerank<-function(G,method='eigen',d=.85,niter=100){
  cvec <- apply(G,2,sum)
  cvec[cvec==0] <- 1 # nodes with indegree 0 will cause problems if we divide by 0.
  gvec <- apply(G,1,sum)
  n <- nrow(G)
  delta <- (1-d)/n
  A <- matrix(delta,nrow(G),ncol(G))
  for (i in 1:n) 
    A[i,] <- A[i,] + d*G[i,]/cvec
#   print(A)
  if (method=='power'){
    x <- rep(1,n)
    for (i in 1:niter) x <- A%*%x
  } else {
    x <- Re(eigen(A)$vector[,1])
  }
  x/sum(x)
}


n<-4
a<-0.85
#原始矩阵
S0<-t(matrix(c(0,0,0,0,1,0,0,1,1,1,0,0,1,1,1,0),nrow=n));
S<-matrix(c(0,1/3,1/3,1/3,0,0,1/2,1/2,0,0,0,1,0,1,0,0),nrow=n)
#1矩阵（4*4）
U<-matrix(rep(1,16),nrow=n)
G<-a*S+(1-a)*(1/n)*U
q<-rep(1,4)
for(i in 1:100){
  q<-G%*%q
}
result<-q/sum(q)



# q1<-q2<-q3<-q4<-0;
# 
# 
# q1<-(1-a)/n
# q2<-a*G[2,][1]*q1+a*G[2,][4]*q4+(1-a)/n
# q3<-a*G[3,][1]*q1+a*G[3,][4]*q2+(1-a)/n
# q4<-a*G[4,][1]*q1+a*G[4,][4]*q2+a*G[4,][3]*q3+(1-a)/n
# q1;q2;q3;q4
# 
# 
# S<-matrix(
#   c(0, 1, 1, 1, 1, 0, 1,
#   1, 0, 0, 0, 0, 0, 0,
#   1, 1, 0, 0, 0, 0, 0,
#   0, 1, 1, 0, 1, 0, 0,
#   1, 0, 1, 1, 0, 1, 0,
#   1, 0, 0, 0, 1, 0, 0,
#   0, 0, 0, 0, 1, 0, 0),nrow=7
# )


S<-matrix(c(0,1,1,0,0,1,1,0,0),nrow=3)
S<-matrix(c(0,1,1,0,0,0,1,1,0,0,0,1,0,0,0,0),byrow=TRUE,nrow=4)
pagerank(S,"eigen",0.85)



n<-4
a<-0.85
S0<-t(matrix(c(0,0,0,0,1,0,0,1,1,1,0,0,1,1,1,0),nrow=n));
S<-matrix(c(0,1/3,1/3,1/3,0,0,1/2,1/2,0,0,0,1,0,1,0,0),nrow=n)
U<-matrix(rep(1,16),nrow=n)
# G<-a*S+(1-a)*(1/n)*U

Ga<-a*S[,1:2]+(1-a)/n*S[,1:2]
Gb<-a*S[,3:4]+(1-a)/n*S[,3:4]
qa<-matrix(rep(1,2),nrow=1)
qb<-rep(1,2)
for(i in 1:100){
  qa<-Ga%*%qa
  qb<-Gb%*%qb
  d<-abs(sum(qa)-sum(qb))
  print(d)
}


rbind(Ga,rep(0,4),rep(0,4))

result<-q/sum(q)


Ga<-a*S[1:2,]+(1-a)/n*

