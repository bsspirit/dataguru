#DataManipulationR.pdf
download.file("http://databank.worldbank.org/databank/download/Gender_Stats_csv.zip","Gender.zip")
unzip("Gender.zip")
genderstats <- read.csv("Gender_Stats_Data.csv")
head(genderstats)

mode(genderstats)
class(genderstats)
names(genderstats)

table(genderstats$Country_Name)
levels(genderstats$Country_Name)

gscountry <- subset(genderstats, 
  Country_Name == "Brazil" | 
  Country_Name == "China" | 
  Country_Name == "India" | 
  Country_Name == "Indonesia" | 
  Country_Name == "United States")

row.names(gscountry)

mygender <- subset(gscountry, 
    Indicator_Name == "GNI per capita, Atlas method (current US$)" |
    Indicator_Name == "Expected years of schooling, female" |
    Indicator_Name == "Expected years of schooling, male" | 
    Indicator_Name == "Labor force, female (% of total labor force)" | 
    Indicator_Name == "Adolescent fertility rate (births per 1,000 women ages 15-19)" |
    Indicator_Name == "Fertility rate, total (births per woman)",
    select = c(Country_Name, Indicator_Name, X2000:X2008))

#install.packages("reshape")
library(reshape)
myChanges <- c(Country_Name = "Country.Name", Indicator_Name = "Series.Name")
mygender <- rename(mygender, myChanges)
names(mygender)

#mydata<-merge(mygender,myMDI, all=TRUE)
x <- data.frame(k1=c(NA,NA,3,4,5), k2=c(1,NA,NA,4,5), data=1:5)
y <- data.frame(k1=c(NA,2,NA,4,5), k2=c(NA,NA,3,4,5), data=1:5)
merge(x, y, by=c("k1","k2")) # NA's match
merge(x, y, by=c("k1","k2"), incomparables=NA)
merge(x, y, by="k1") # NA's match, so 6 rows
merge(x, y, by="k2", incomparables=NA) # 2 rows


# mysplit <- split(mydata, mydata$Country.Name, drop = TRUE)
# mysplit$Brazil
ma <- cbind(x = 1:10, y = (-4:5)^2)
split(ma, col(ma))
split(1:15, 1:3,drop=TRUE)


# years<-paste("X", 2000:2008, sep = "")
# mylongdata<-reshape(mydata, varying = years, direction = "long",sep = "")

summary(Indometh)
wide<-reshape(Indometh,v.names="conc",idvar="Subject",timevar="time", direction = "wide")
long<-reshape(wide, direction = "long")
reshape(wide, idvar = "Subject", varying = list(2:12),v.names = "conc", direction = "long")


df <- data.frame(id = rep(1:4, rep(2,4)),visit = I(rep(c("Before","After"), 4)),x = rnorm(4), y = runif(4))
reshape(df, timevar = "visit", idvar = "id", direction = "wide")
reshape(df, timevar = "visit", idvar = "id", direction = "wide", v.names = "x")
df2 <- df[1:7, ]
reshape(df2, timevar = "visit", idvar = "id", direction = "wide")

library(reshape)
head(melt(tips))
names(airquality) <- tolower(names(airquality))
melt(airquality, id=c("month", "day"))
names(ChickWeight) <- tolower(names(ChickWeight))
melt(ChickWeight, id=2:4)


names(airquality) <- tolower(names(airquality))
aqm <- melt(airquality, id=c("month", "day"), na.rm=TRUE)

cast(aqm, day ~ month ~ variable)
cast(aqm, month ~ variable, mean)
cast(aqm, month ~ . | variable, mean)
cast(aqm, month ~ variable, mean, margins=c("grand_row", "grand_col"))
cast(aqm, day ~ month, mean, subset=variable=="ozone")
cast(aqm, month ~ variable, range)
cast(aqm, month ~ variable + result_variable, range)
cast(aqm, variable ~ month ~ result_variable,range)

str(1:12)
str(ls)


# download.file("http://databank.worldbank.org/databank/download/MDG_csv.zip","MDI.zip")
# unzip("MDI.zip")
# MDstats <- read.csv("MDG_Data.csv")
# head(MDstats)