#6.3
data<-data.frame(
c(1,1,1,1,2,2,2,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,8,9,11,12,12,12),
c(0.6,1.6,0.5,1.2,2.0,1.3,2.5,2.2,2.4,1.2,3.5,4.1,5.1,5.7,3.4,9.7,8.6,4.0,5.5,10.5,17.5,13.4,4.5,30.4,12.4,13.4,26.2,7.4))

names(data)<-c('x','y')
par(mfrow=c(3,3))
#1
plot(data,main="散点图y=3.0395+0.3481x")
data.lm<-lm(data)
print("回归直线方程:y=3.0395+0.3481x")
abline(data.lm)

#2
print(summary(data.lm))
print('通过t检验很显著,未通过F检验,Multiple R-squared: 0.5422值太低!')
 
#3
data.res<-resid(data.lm)
data.fit<-predict(data.lm)
plot(data.res~data.fit,main='普通残差')
 
data.rst<-rstandard(data.lm)
plot(data.rst~data.fit,,main='标准残差')


#4-1
data.new<-lm(y~x-1,data=data)
summary(data.new)
plot(data,main='修正模型y=1.3698x')
abline(data.new)
print('通过t检验很显著,未通过F检验,Multiple R-squared: 0.7595值太低!')

data.new.res<-resid(data.new)
data.new.fit<-predict(data.new)
plot(data.res~data.fit,main='普通残差')

data.new.rst<-rstandard(data.new)
plot(data.rst~data.fit,main='标准残差')


#4-2
data.new2<-update(data.new,sqrt(.)~.)
summary(data.new2)
print("回归直线方程:sqrt(y)=0.3906x")
print('通过t检验很显著,通过F检验,Multiple R-squared: 0.9096!')
plot(data,main='修正模型sqrt(y)=0.3906x')
abline(data.new)
 
data.new2.res<-resid(data.new2)
data.new2.fit<-predict(data.new2)
plot(data.new2.res~data.new2.fit,,main='普通残差')
 
data.new2.rst<-rstandard(data.new2)
plot(data.new2.rst~data.new2.fit,main='标准残差')


