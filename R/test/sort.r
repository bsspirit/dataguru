#实现排序算法
#http://f.dataguru.cn/thread-11609-1-1.html

## dataframe.sort=function(Data,Main,Alter=NULL,Order="Increase"){
##     if(is.data.frame(Data)==FALSE) Data <- as.data.frame(Data)
##     Width=length(Data);
##     Height=length(rownames(Data));
##     Ma=which(colnames(Data)==Main);
##     if(is.null(Alter) == FALSE)
##         Al=which(colnames(Data)==Alter)
##     else
##         Al=Ma;
##     if(Order=="Increase"){
##         for (I1 in 1:(Height-1)){
##             for(I2 in 1:(Height-I1)){
##                 if((Data[I2,Ma]>Data[I2+1,Ma])|((Data[I2,Ma]==Data[I2+1,Ma])&(Data[I2,Al]>Data[I2+1,Al])))
##                     Data<-dfc(Data,I2,I2+1,Width)
##             }
##         }
##     }
##     if(Order=="Decrease"){
##         for (I1 in 1:(Height-1)){
##             for(I2 in 1:(Height-I1)){
##                 if((Data[I2,Ma]<Data[I2+1,Ma])|((Data[I2,Ma]==Data[I2+1,Ma])&(Data[I2,Al]<Data[I2+1,Al])))
##                     Data<-dfc(Data,I2,I2+1,Width)
##             }
##         }
##     }
##     Data;
## }
## 
## dfc=function(data,i1,i2,j){
##     for(jj in 1:j) {
##         temp=data[i1,jj];
##         data[i1,jj]=data[i2,jj];
##         data[i2,jj]=temp;
##     }
##     temp=rownames(data)[i1];
##     rownames(data)[i1]=" ";
##     temp2=rownames(data)[i2]
##     rownames(data)[i2]=temp;
##     rownames(data)[i1]=temp2;
##     data;
## }
## 
## 
## result=dataframe.sort(swiss,"Education",Alter=NULL,Order="Increase");
## print(result)


data=swiss[order(swiss$Education, -swiss$Examination),]
print(data)