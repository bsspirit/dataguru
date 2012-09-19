source("MINE.r")
data<-read.csv("WHO.csv")
label<-read.csv("Who_zh.csv",header=FALSE)
names(label)<-c("英文","中文")

who<-function(x,y,mp=TRUE){
    print(paste(label[x,]$英文,label[x,]$中文));
    print(paste(label[y,]$英文,label[y,]$中文));
    title<-paste(label[y,]$中文,'~',label[x,]$中文)
    
    png(file=paste(label[y,]$中文,'.png',sep=""))
    data.lm<-lm(data[[y]]~data[[x]])
    print(summary(data.lm))
    plot(data[[y]]~data[[x]],main=title,
            xlab=label[x,]$中文,ylab=label[y,]$中文,
            xlim=c(0,max(data[[x]],na.rm=TRUE)*1.1),
            ylim=c(0,max(data[[y]],na.rm=TRUE)*1.1))
    abline(data.lm,col="gray")
    
    max_x<-which(data[[x]]==max(data[[x]],na.rm=TRUE))
    max_y<-which(data[[y]]==max(data[[y]],na.rm=TRUE))
    
    if(mp){
        #max_x
        name<-data[max_x,]$Country
        tx<-data[max_x,][x]
        ty<-data[max_x,][y]
        points(tx,ty,col="red",pch=19)
        text(tx,ty,name,col="blue",cex=0.8)
        
        #max_y
        name<-data[max_y,]$Country
        tx<-data[max_y,][x]
        ty<-data[max_y,][y]
        points(tx,ty,col="green",pch=19)
        text(tx,ty,name,col="orange",cex=0.8)
    }
    dev.off()
} 


who(61,62)#医师密度（每10万人口）~医药人才密度（每10万人口）
who(263,264,FALSE)#年青女性识字率~成人部识字率
who(326,327,FALSE)#小学女童完成~小学男童完成
who(350,320)#总人口~总收入
who(176,177)#武器进口~武器出口
who(320,318)#人口增长~总人口
