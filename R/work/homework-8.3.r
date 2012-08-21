#8.3
X<-data.frame(
DXBZ=c(9.30,4.67,0.96,1.38,1.48,2.60,2.15,2.14,6.53,1.47,1.17,0.88,1.23,0.99,0.98,0.85,1.57,1.14,1.34,0.79,1.24,0.96,0.78,0.81,0.57,1.67,1.10,1.49,1.61,1.85),
CZBZ=c(30.55,29.38,24.69,29.24,25.47,32.32,26.31,28.46,31.59,26.43,23.74,19.97,16.87,18.84,25.18,26.55,23.16,22.57,23.04,19.14,22.53,21.65,14.65,13.85,3.85,24.36,16.85,17.76,20.27,20.66),
WMBZ=c(8.70,8.92,15.21,11.30,15.39,8.81,10.49,10.87,11.04,17.23,17.46,24.43,15.63,16.22,16.87,16.15,15.79,12.10,10.45,10.61,13.97,16.24,24.27,25.44,44.43,17.62,27.93,27.70,22.06,12.75),
row.names = c("北京", "天津", "河北", "山西", "内蒙古", "辽宁", "吉林",
              "黑龙江", "上海", "江苏", "浙江", "安徽", "福建", "江西",    
              "山东",  "河南", "湖北", "湖南", "广东", "广西", "海南",
              "四川", "贵州", "云南", "西藏", "陕西", "甘肃",
              "青海", "宁夏", "新疆")
)


d<-dist(scale(X),method="euclidean")
# 
# com<-hclust(d,"complete")
# ave<-hclust(d,"average")
# cen<-hclust(d,"centroid")
# ward<-hclust(d,"ward")
# 
# plclust(com,hang=-1,main="最长短离法",xlab=NULL,ylab=NULL)
# com.rect<-rect.hclust(com,k=4,border=4)
# print(com.rect)
# 
# plclust(ave,hang=-1,main="均值法",xlab=NULL,ylab=NULL)
# ave.rect<-rect.hclust(ave,k=4,border=4)
# print(ave.rect)
# 
# plclust(cen,hang=-1,main="重心法",xlab=NULL,ylab=NULL)
# cen.rect<-rect.hclust(cen,k=4,border=4)
# print(cen.rect)
# 
# plclust(ward,hang=-1,main="Ward法",xlab=NULL,ylab=NULL)
# ward.rect<-rect.hclust(ward,k=4,border=4)
# print(ward.rect)


library(scatterplot3d)
k<-kmeans(d,4,nstart=20)
scatterplot3d(X,color=k$cluster)
print(sort(k$cluster))


