#6.8
data<-read.csv(file="data-6.8.csv",header=TRUE, sep = ",")[2:7]
data.y1<-data[which(data$y==1),]

#1
data.glm<-glm(y~x1+x2+x3+x4+x5,data=data,family=binomial)
summary(data.glm)
print(paste('y~x1+x2+x3+x4+x5','x1~x5综合影响 不显著'))
print('x1,x4是主要的影响因素,x1<0.05,x4<0.1')

#p<-exp(-7.01140+(0.09994*x1)+(0.01415*x2)+(0.01749*x3)+(-1.08297*x4)+(-0.61309*x5))/(1+exp(-7.01140+(0.09994*x1)+(0.01415*x2)+(0.01749*x3)+(-1.08297*x4)+(-0.61309*x5)))
pre<-predict(data.glm,data)
p1<-exp(pre)/(1+exp(pre))
d1<-cbind(data,p1)


#2
data.step<-step(data.glm)
data.new.glm<-glm(data.step,data=data,family=binomial)
summary(data.new.glm)
pre.new<-predict(data.new.glm,data)
p2<-exp(pre.new)/(1+exp(pre.new))
d2<-cbind(d1,p2)

plot(d2$y,xlab='序号',ylab='生存时间')
lines(c(1:40),d2$p1,col="red")
lines(c(1:40),d2$p2,col="blue")
