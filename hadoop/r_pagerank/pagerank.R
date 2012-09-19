#求4个网页的Page Rank值
#公式：G=a*S + (1-a)*(1/n)*U

pagerank<-function(G,method='eigen',d=.85,niter=100){
  cvec <- apply(G,2,sum)
  cvec[cvec==0] <- 1
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
S0<-t(matrix(c(0,0,0,0,1,0,0,1,1,1,0,0,1,1,1,0),nrow=n));
pagerank(S0)



  
