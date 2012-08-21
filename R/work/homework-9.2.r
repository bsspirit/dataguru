#9.2
data<-data.frame(
  x1=c(82.9,88.0,99.9,105.3,117.7,131.0,148.2,161.8,174.2,184.7),  
  x2=c(92,93,96,94,100,101,105,112,112,112),
  x3=c(17.1,21.3,25.1,29.0,34.0,40.0,44.0,49.0,51.0,53.0),
  x4=c(94,96,97,97,100,101,104,109,111,111),
  y=c(8.4,9.6,10.4,11.4,12.2,14.2,15.8,17.9,19.6,20.8)
)

lm1<-lm(y~x1+x2+x3+x4,data=data)
summary(lm1)

pr<-princomp(~x1+x2+x3+x4,data=data,cor=TRUE)
summary(pr,loadings=TRUE)

pre<-predict(pr)
data$z1<-pre[,1]
# data$z2<-pre[,2]

lm<-lm(y~z1,data=data)
summary(lm)

# y=14.0300+2.06119*z1

beta<-coef(lm)
A<-loadings(pr)
x.bar<-pr$center
x.sd<-pr$scale

coef<-(beta[2]*A[,1])/x.sd
beta0<-beta[1]-sum(x.bar*coef)

c(beta0,coef)

# y=-13.23361749+0.03984128*x1+0.17746181*x2+0.11173275*x3+0.16965187*x4

