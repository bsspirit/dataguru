#6.4
Reg_Diag<-function(fm){
    n<-nrow(fm$model); df<-fm$df.residual
    p<-n-df-1; s<-rep(" ", n);  
    res<-residuals(fm); s1<-s; s1[abs(res)==max(abs(res))]<-"*"
    sta<-rstandard(fm); s2<-s; s2[abs(sta)>2]<-"*"
    stu<-rstudent(fm); s3<-s; s3[abs(sta)>2]<-"*"
    h<-hatvalues(fm); s4<-s; s4[h>2*(p+1)/n]<-"*"
    d<-dffits(fm); s5<-s; s5[abs(d)>2*sqrt((p+1)/n)]<-"*"
    c<-cooks.distance(fm); s6<-s; s6[c==max(c)]<-"*"
    co<-covratio(fm);   abs_co<-abs(co-1)
    s7<-s; s7[abs_co==max(abs_co)]<-"*"
    data.frame(residual=res, s1, standard=sta, s2, 
            student=stu, s3,  hat_matrix=h, s4, 
            DFFITS=d, s5,cooks_distance=c, s6, 
            COVRATIO=co, s7)
}


tp<-data.frame(
    X1=c(-0.05,0.25,0.60,0,0.25,0.20, 0.15,0.05,-0.15, 0.15,
        0.20, 0.10,0.40,0.45,0.35,0.30, 0.50,0.50, 0.40,-0.05,
        -0.05,-0.10,0.20,0.10,0.50,0.60,-0.05,0, 0.05, 0.55),
    X2=c( 5.50,6.75,7.25,5.50,7.00,6.50,6.75,5.25,5.25,6.00,
        6.50,6.25,7.00,6.90,6.80,6.80,7.10,7.00,6.80,6.50,
        6.25,6.00,6.50,7.00,6.80,6.80,6.50,5.75,5.80,6.80),
    Y=c( 7.38,8.51,9.52,7.50,9.33,8.28,8.75,7.87,7.10,8.00,
        7.89,8.15,9.10,8.86,8.90,8.87,9.26,9.00,8.75,7.95,
        7.65,7.27,8.00,8.50,8.75,9.21,8.27,7.67,7.93,9.26)
)
par(mfrow=c(2,3))
tp.lm<-lm(Y~X1+I(X2^2),data=tp)
summary(tp.lm)
plot(tp.lm,1);plot(tp.lm,3);plot(tp.lm,4)

Reg_Diag(tp.lm)
print('5号样本残差最大,且标准化残差和外学生化残差绝对值超过2')
print('8号样本hat,DFFITS,cooks超标,cook达到最大')
print('因此,5号样本对响应变量影响较大,8号样本对自变量影响较大')

tp2<-tp[-c(5,8),]#,11,23,22,27,7,25
tp2.lm<-lm(Y~X1+I(X2^2),data=tp2)
summary(tp2.lm)
plot(tp2.lm,1);plot(tp2.lm,3);plot(tp2.lm,4)

print('去掉5,8样本后,Multiple R-squared: 0.9232 比之前的0.8909有明显提高!')
Reg_Diag(tp2.lm)
