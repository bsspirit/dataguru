#install.packages("RCurl")
#install.packages("libxml")
library(RCurl)
baseURL <- "http://www.theplantlist.org/tpl/record/kew-419248"
txt <- getURL(url=baseURL)
xmltext <- htmlParse(txt, asText=TRUE)
xmltable <- xpathApply(xmltext, "//table//tbody//tr")
t(sapply(xmltable, function(x)unname(xmlSApply(x, xmlValue))[c(1, 3, 5, 7)]))