#6.1
x<-c(5.1,3.5,7.1,6.2,8.8,7.8,4.5,5.6,8.0,6.4)
y<-c(1907,1287,2700,2373,3260,3000,1947,2273,3113,2493)
data<-data.frame(x,y)

#1
plot(data)
data.lm<-lm(data$y~data$x)
abline(data.lm)
print(summary(data.lm))

#2
print("一元回归方程:　y=140.95+364.18x")

#3
data.lm2<-lm(y~x+0)
abline(data.lm2,col="red")
print(summary(data.lm2))
print("修正的一元回归方程:　y=385.227x")

#4
newdata<-data.frame(x=7)
data.pred<-predict(data.lm2,newdata,interval="prediction",level=0.95)
data.pred
print(paste("预测值:","2696.58"))
