#install.packages("fpc")

#data<-cbind(runif(10, 0, 10)+rnorm(n, sd=0.2), runif(10, 0, 10)+rnorm(n,sd=0.2))
#colnames(x)<-c("x","y")
#write.csv(x,file="fpc.csv",fileEncoding="utf-8",row.names=FALSE)
#library(fpc)

data<-read.csv(file="fpc.csv",header=TRUE);

#euclidean distance
euclidean.dis<-function(p1,p2){
  p<-rbind(p1,p2)
  dis<-dist(p)
  dis
}

#init list
lists<-function(data){
  rows<-nrow(data)
  l<-list()
  for(i in 1:rows){
    l[[i]]<-list(id=i,points=c())
  }
  l
}

#assemble list
lists.data<-function(data,r=0.2){
  x<-data#head(data,n=100)
  rows<-nrow(x)
  l<-lists(x)
  
  for(i in 1:rows){
    for(j in 1+i:rows-1){
      if(i==j) next
      #print(paste(i,",",j))
      #print(euclidean.dis(x[i,],x[j,]))
      
      dis<-euclidean.dis(x[i,],x[j,])
      if(dis<=r){
        #print(paste("dis<r => ",dis,"<",r))
        l[[i]]$points<-c(l[[i]]$points,c(j))
        l[[j]]$points<-c(l[[j]]$points,c(i))
      }
    }
  }
  l
}

# #kernal and merge
# kernal<-funciton(l,m=5){
#     
# }
# 
# my.dbscan<-function(){
#   
# }

m=5
l<-lists.data(data)

result<-list()
for(i in 1:length(l)){
  if(length(l[[i]]$points)>=m){#kernal
    len<-length(result)
    print(paste("result len:",len))
    
    if(len==0){
      result[[i]]=c(i,l[[i]]$points)
      next
    }
    
    merge=0
    for(j in 1:len){
      print(paste("merge:",merge))
      if(length(intersect(c(i,l[[i]]$points),result[[j]]))>0){
        if(merge==0){
          result[[j]]<-union(result[[j]],c(i,l[[i]]$points))
          merge=j  
        } else {
          result[[merge]]<-union(result[[merge]],result[[j]])
          result<-result[-j]
          print(paste("result[-j]:",j))
        }
      }
    }
    
    #print(paste("merge:",merge))
    if(merge==0){
      result[[len+1]]=result[[i]]=c(i,l[[i]]$points)
    }
  }
}


# plot.result<-function(){
#   
# }
# png(file="mydbscan.png")
plot(data[result[[1]],],col="red",xlim=c(0,10),ylim=c(0,10))
points(data[result[[2]],],col="blue")
points(data[result[[3]],],col="green")
points(data[result[[4]],],col="yellow")
points(data[result[[5]],],col="gray")
points(data[result[[6]],],col="orange")
points(data[result[[7]],],col="black")
points(data[result[[8]],],col="pink")
points(data[result[[9]],],col="chocolate")
points(data[result[[10]],],col="brown")
points(data[result[[11]],],col="maroon")
# dev.off()

# png(file="dbscan.png")
# plot(ds,data)
# dev.off()