#user-cf算法

FILE<-"testCF.csv"
NEIGHBORHOOD_NUM<-2
RECOMMENDER_NUM<-3


# #欧氏距离
# d<-dist(M,method="euclidean")
# #相似度矩阵
# simi<-1/(1+d)
# 
# #找到近邻
# nuser<-length(user)
# simi_mat<-as.matrix(simi)


FileDataModel<-function(file){
  data<-read.csv(file,header=FALSE)
  names(data)<-c("uid","iid","pref")
  
  print(data)
  
  user <- unique(data$uid)
  item <- unique(sort(data$iid))
  uidx <- match(data$uid, user)
  iidx <- match(data$iid, item)
  M <- matrix(0, length(user), length(item))
  i <- cbind(uidx, iidx, pref=data$pref)
  for(n in 1:nrow(i)){
    M[i[n,][1],i[n,][2]]<-i[n,][3]  
  }
  dimnames(M)[[2]]<-item
  M
}



EuclideanDistanceSimilarity<-function(M){
  row<-nrow(M)
  s<-matrix(0, row, row)
  for(z1 in 1:row){
    for(z2 in 1:row){
      if(z1<z2){
        num<-intersect(which(M[z1,]!=0),which(M[z2,]!=0)) #可计算的列
        
        sum<-0
        for(z3 in num){
          sum<-sum+(M[z1,][z3]-M[z2,][z3])^2
        }
        
        s[z2,z1]<-length(num)/(1+sqrt(sum))
        
        if(s[z2,z1]>1) s[z2,z1]<-1 #标准化
        if(s[z2,z1]< -1) s[z2,z1]<- -1 #标准化
        
        #print(paste(z1,z2));print(num);print(sum)
      }
    }
  }
  #补全三角矩阵
  ts<-t(s)
  w<-which(upper.tri(ts))
  s[w]<-ts[w]
  s
}

NearestNUserNeighborhood<-function(S,n){
  row<-nrow(S)
  neighbor<-matrix(0, row, n)
  for(z1 in 1:row){
    for(z2 in 1:n){
      m<-which.max(S[,z1])
#       print(paste(z1,z2,m,'\n'))
      neighbor[z1,][z2]<-m
      S[,z1][m]=0
    }
  }
  neighbor
}

UserBasedRecommender<-function(uid,n,M,S,N){
  row<-ncol(N)
  col<-ncol(M)
  r<-matrix(0, row, col)
  N1<-N[uid,]
  for(z1 in 1:length(N1)){
    num<-intersect(which(M[uid,]==0),which(M[N1[z1],]!=0)) #可计算的列
#     print(num)
    
    for(z2 in num){
#       print(paste("for:",z1,N1[z1],z2,M[N1[z1],z2],S[uid,N1[z1]]))
      r[z1,z2]=M[N1[z1],z2]*S[uid,N1[z1]]
    }
  }
  
  sum<-colSums(r)
  s2<-matrix(0, 2, col)
  for(z1 in 1:length(N1)){
    num<-intersect(which(colSums(r)!=0),which(M[N1[z1],]!=0))
    for(z2 in num){
      s2[1,][z2]<-s2[1,][z2]+S[uid,N1[z1]]
      s2[2,][z2]<-s2[2,][z2]+1
    }
  }
  
  s2[,which(s2[2,]==1)]=10000
  s2<-s2[-2,]
  
  r2<-matrix(0, n, 2)
  rr<-sum/s2
  item <-dimnames(M)[[2]]
  for(z1 in 1:n){
    w<-which.max(rr)
    if(rr[w]>0.5){
      r2[z1,1]<-item[which.max(rr)]
      r2[z1,2]<-as.double(rr[w])
      rr[w]=0
    }
  }
  r2
}


M<-FileDataModel(FILE)
S<-EuclideanDistanceSimilarity(M)
N<-NearestNUserNeighborhood(S,2)
R1<-UserBasedRecommender(1,3,M,S,N)




# topN<-data.frame(x1=NA,x2=NA,x3=NA)
# topN<-data.frame(x1=NA,x2=NA)
# for(i in 1:row){
#   neighborhood<-sort(S[,i],decreasing =TRUE)[1:NEIGHBORHOOD_NUM]
#   for(x in 1:NEIGHBORHOOD_NUM){
# #     topN<-rbind(topN,c(x1=i,x2=names(neighborhood)[x], x3=neighborhood[x]))
#     topN<-rbind(topN,c(x1=i,x2=names(neighborhood)[x]))
#   }
# }
# topN<-topN[-1,]

#推荐矩阵
R <- matrix(0, length(user), length(item))

#没有评价过的item
a1<-which(M[1,]==0)

#找到其他人
o<-topN[which(topN$x1==1),]

#其他人的评价列表
a2<-which(M[2,]!=0)
a4<-which(M[4,]!=0)

#需要评价的列表
a<-intersect(a2,a1)
aa<-intersect(a4,a1)

#计算推荐列表
result2<-as.double(o[1,]$x3)*M[2,a]
result4<-as.double(o[2,]$x3)*M[4,aa]

#归一化
item4<-(result2[1]*as.double(o[1,]$x3)+result4[1]*as.double(o[2,]$x3))/(as.double(o[1,]$x3)+as.double(o[2,]$x3))
item6<-(0+result4[2])/(as.double(o[2,]$x3))









# mod <- colSums(M^2)^0.5
# MM <- M %*% diag(1/mod)
# S <- crossprod(MM)
# R <- M %*% S
# R <- apply(R, 1, FUN=sort, decreasing=TRUE, index.return=TRUE)
# k <- 5
# res <- lapply(R, FUN=function(r)return(item[r$ix[1:k]]))
# write.table(paste(user, res, sep=’:'), file=’result.dat’,quote=FALSE, row.name=FALSE, col.name=FALSE)