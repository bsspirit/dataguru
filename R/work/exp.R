#指数分布
x<-seq(0,5,0.01)

plot(x,pexp(x),type='o',col='red',ylim=c(0,1))
points(x,pexp(x,0.5),col="green")
points(x,pexp(x,1.5),col="blue")

lines(x,dexp(x),col='red')
lines(x,dexp(x,0.5),col='green')
lines(x,dexp(x,1.5),col='blue')
