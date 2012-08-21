#3.1
data<-c(74.3,78.8,68.8,78.8,70.4,80.5,80.5,69.7,71.2,73.5,
        79.5,75.6,75.0,78.8,72.0,72.0,72.0,74.3,71.2,72.0,
        75.0,73.5,78.8,74.3,75.8,65.0,74.3,71.2,69.7,68.0,
        73.5,75.0,72.0,64.3,75.8,80.3,69.7,74.3,73.5,73.5,
        75.8,75.8,68.8,76.5,70.4,71.2,81.2,75.0,70.4,68.0,
        70.4,72.0,76.5,74.3,76.5,77.6,67.3,72.0,75.0,74.3,
        73.5,79.5,73.5,74.7,65.0,76.5,81.6,75.4,72.7,72.7,
        67.2,76.5,72.7,70.4,77.2,68.8,67.3,67.3,67.3,72.7,
        75.8,73.5,75.0,73.5,73.5,73.5,72.7,81.6,70.3,74.3,
        73.5,79.5,70.4,76.5,72.7,77.2,84.3,75.0,76.5,70.4)

outline <- function(data){
    n<-length(data)
    data.mean<-mean(data)
    data.var<-var(data)
    data.sd<-sd(data)
    data.r<-max(data)-min(data)
    data.cv<-data.sd/data.mean*100
    data.skewness<-n/((n-1)*(n-2)*data.sd^3)*sum(data-data.mean)^3
    data.kurtosis<-(n*(n+1)*sum(data-data.mean)^4)/((n-1)*(n-2)*(n-3)*data.sd^4)-3*(n-1)^2/((n-2)*(n-3))
    data.frame(N=n,Mean=data.mean,Var=data.var,Sd=data.sd,R=data.r,CV=data.cv,Skewness=data.skewness,kurtosis=data.kurtosis)
}

print(outline(data))
