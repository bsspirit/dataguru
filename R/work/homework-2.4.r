#2.4
n<-5
H<-array(0,dim=c(n,n))
for(i in 1:n){
  for(j in 1:n){
    H[i,j]<- 1/(i+j-1)
  }
}
solve(H)
eigen(H)

