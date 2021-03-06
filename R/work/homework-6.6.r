#6.6
#x1是否用抗生素(1用,0否)
#x2是否有危险因子(1是,0否)
#x3是否事先有计划(1是,0否)
#y1有感染
#y2无感染

x1<-c(rep(1,4),rep(0,4))
x2<-c(1:8)%%2
x3<-c(1,1,0,0,1,1,0,0)
y1<-c(1,0,11,0,28,8,23,0)
y2<-c(17,2,87,0,30,32,3,9)

data<-data.frame(x1,x2,x3)
data$y<-cbind(y1,y2)

data.glm<-glm(y~x1+x2+x3,family=binomial,data=data)
summary(data.glm)

p=exp(-0.8207 + (-3.2544*x1)+(2.0299*x2)+(-1.0720*x3))/(1+exp(-0.8207 + (-3.2544*x1)+(2.0299*x2)+(-1.0720*x3)))
print(paste('logistic回归模型:','y=exp(-0.8207 + (-3.2544*x1)+(2.0299*x2)+(-1.0720*x3))/(1+exp(-0.8207 + (-3.2544*x1)+(2.0299*x2)+(-1.0720*x3)))'))

data.new.glm<-step(data.glm)
print('模型正确!')


