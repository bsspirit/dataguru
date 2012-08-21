#3.5
a1<-c(2,4,3,2,4,7,7,2,2,5,4)
a2<-c(5,6,8,5,10,7,12,12,6,6)
a3<-c(7,11,6,6,9,5,5,10,6,3,10)
f<-factor(c(rep(1,length(a1)),c(rep(2,length(a2))),c(rep(3,length(a3)))))

par(mfrow=c(1,2))
plot(f,c(a1,a2,a3),ylim=c(1,15),ylab="存活日数",xlab="菌型",main="PLOT图")
boxplot(a1,a2,a3,ylim=c(1,15),ylab="存活日数",xlab="菌型",main="BOXPLOT图")
axis(1,1:3,1:3)