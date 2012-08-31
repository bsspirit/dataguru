#The Split-Apply-Combine Strategy for Data Analysis.pdf

one<-ozone[1,1,]
month <- ordered(rep(1:12, length = 72))
model <- glm(one ~ month - 1)
deseas <- resid(model)
deseasf <- function(value) glm(value ~ month - 1)
models <- aaply(ozone, 1:2, deseasf)
deseas <- aaply(models, 1:2, resid)
