x<-c(5.1,3.5,7.1,6.2,8.8,7.8,4.5,5.6,8.0,6.4)
y<-c(1907,1287,2700,2373,3260,3000,1947,2273,3113,2493)

png(file="test.png")
plot(x,y,xlim=c(0,15),ylim=c(0,4000))

#abline(lm(y~x),col="blue")
#abline(lm(y~x+0),col="red")
points(0,0, col = "black",pch=19)


abline(lm(y~x),col="blue")
abline(lm(y~1+x),col="black")
abline(lm(y~x+1),col="yellow")

abline(lm(y~x+0),col="red")
abline(lm(y~0+x),col="green")
abline(lm(y~x-1),col="gray")
abline(lm(y~-1+x),col="orange")

dev.off();
