#购物车,关联分析
#install.packages("arules")

library(arules)
## data(Groceries)
## 
## #查看数据
## inspect(Groceries)
## #频繁项集
## freq<-eclat(Groceries,parameter=list(support=0.05,maxlen=10))
## #查看数据
## inspect(sort(freq,by="support")[1:10])
## #关联规则
## rules<-apriori(Groceries,parameter=list(support=0.01,confidence=0.5))
## summary(rules)
## 
## inspect(rules)
## subs<-arules::subset(rules,lift>=3)
## inspect(sort(subs,by="support"))

cart <- list(
        c("orange", "coke"),
        c("milk", "orange", "cleaner"),
        c("orange", "detegent"),
        c("orange", "detegent","coke"),
        c("cleaner"))

trans <- as(cart, "transactions")
## cart<-read.table(file="cart.csv",header=FALSE, stringsAsFactors=FALSE)
inspect(trans)

#频繁项集
freq<-eclat(trans,parameter=list(support=0.4,maxlen=10))
#查看数据
inspect(sort(freq,by="support"))#[1:10])
#关联规则
rules<-apriori(trans,parameter=list(support=0.4,confidence=0.5))
summary(rules)
inspect(rules)
subs<-arules::subset(rules,lift>1)
inspect(sort(subs,by="support"))