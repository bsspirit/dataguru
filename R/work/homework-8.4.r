#8.4
data<-read.table(file="applicant.data")
d<-1-cor(data)
dis<-as.dist(d)
#dim(d)<-c(15,15)

com<-hclust(dis,"complete")
ave<-hclust(dis,"average")
cen<-hclust(dis,"centroid")
ward<-hclust(dis,"ward")

par(mfrow=c(2,2))
plclust(com,hang=-1,main="最长短离法",xlab=NULL,ylab=NULL)
com.rect<-rect.hclust(com,k=5,border=4)
print(com.rect)

plclust(ave,hang=-1,main="均值法",xlab=NULL,ylab=NULL)
ave.rect<-rect.hclust(ave,k=5,border=4)
print(ave.rect)

plclust(cen,hang=-1,main="重心法",xlab=NULL,ylab=NULL)
cen.rect<-rect.hclust(cen,k=5,border=4)
print(cen.rect)

plclust(ward,hang=-1,main="Ward法",xlab=NULL,ylab=NULL)
ward.rect<-rect.hclust(ward,k=5,border=4)
print(ward.rect)