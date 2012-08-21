#3.8
x<-seq(-2,3,0.05)
y<-seq(-1,7,0.05)
f<-function(x,y) x^4-2*x^2*y+x^2-2*x*y+2*y^2+9/2*x-4*y+4
z<-outer(x,y,f)

lines<-c(0,1,2,3,4,5,10,15,20,30,40,50,60,80,100)
contour(x,y,z,col="blue",xlim=c(-2,3),ylim=c(-1,7),levels = lines)

persp(x,y,z,theta=90,phi=0,expand=1)