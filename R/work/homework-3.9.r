#3.9
num<-seq(1,19)
name<-c("Alice","Becka","Gail","Karen","Kathy","Mary","Sandy","Sharon","Tammy","Alfred","Duke","Guido","James","Jeffrey","John","Philip","Robert","Thomas","William")
gender<-c(rep('F',9),rep('M',10))
age<-c(13,13,14,12,12,15,11,15,14,14,14,15,12,13,12,16,12,11,15)
height<-c(56.5,65.3,64.3,56.3,59.8,66.5,51.3,62.5,52.8,69.0,63.5,67.0,57.3,62.5,59.0,72.0,64.8,57.5,66.5)
weight<-c(84.0,98.0,90.0,77.0,84.5,112.0,50.5,112.5,102.5,112.5,102.5,133.0,83.0,84.0,99.5,150.0,128.0,85.0,112.0)
students<-data.frame(num,name,gender,age,height,weight)
names(students)<-c("学号","姓名","性别","年龄","身高","体重")

print(cor.test(~身高 + 体重, data=students)) 
print("p-value = 4.402e-05 < 0.05,拒绝原假设,身高和体重相关")