#6.2
x1<-c(0.4,0.4,3.1,0.6,4.7,1.7,9.4,10.1,11.6,12.6,10.9,23.1,23.1,21.6,23.1,1.9,26.8,29.9)
x2<-c(52,23,19,34,24,65,44,31,29,58,37,46,50,44,56,36,58,51)
x3<-c(158,163,37,157,59,123,46,117,173,112,111,114,134,73,168,143,202,124)
y<-c(64,60,71,61,54,77,81,93,93,51,76,96,77,93,95,54,168,99)

#1
lm1<-lm(y~x1+x2+x3)
print(summary(lm1))
lm1.co<-coefficients(lm1)
print(paste('回归方程:y=',lm1.co['(Intercept)'],'+(',lm1.co['x1'],')*x1+(',lm1.co['x2'],')*x2+(',lm1.co['x3'],')*x3'))
#2
lm2<-update(lm1,.~.-x2-x3)
print(summary(lm2))
lm2.co<-coefficients(lm2)
print(paste('通过显著性检验的回归方程:y=',lm2.co['(Intercept)'],'+(',lm2.co['x1'],')*x1'))

par(mfrow=c(2,2))
plot(y~x1)
abline(lm(y~x1))

plot(y~x2)
abline(lm(y~x2))

plot(y~x3)
abline(lm(y~x3))

#3
lm.step<-step(lm1)
print(summary(lm.step))
print(drop1(lm.step))
lm.opt<-lm(y~x1)
print(summary(lm.opt))
lm3.co<-coefficients(lm.opt)
print(paste('逐步回归分析:y=',lm3.co['(Intercept)'],'+(',lm3.co['x1'],')*x1'))