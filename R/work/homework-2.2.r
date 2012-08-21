#2.2
A<-matrix(1:16,4,4)
B<-matrix(1:16,4,4,byrow=T)
C<-A+B
D<-A%*%B
E<-A*B
F<-A[1:3,1:3]
G<-B[,-3]

