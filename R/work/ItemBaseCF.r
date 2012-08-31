#协同过滤算法R实现

data <- read.table('data.dat', sep=',', header=TRUE)
user <- unique(data$user_id)
subject <- unique(data$subject)
uidx <- match(data$user, user)
iidx <- match(data$subject, subject)
M <- matrix(0, length(user), length(subject))
i <- cbind(uidx, iidx)
M[i] <- 1
mod <- colSums(M^2)^0.5
MM <- M %*% diag(1/mod)
S <- crossprod(MM)
R <- M %*% S
R <- apply(R, 1, FUN=sort, decreasing=TRUE, index.return=TRUE)
k <- 5
res <- lapply(R, FUN=function(r)return(subject[r$ix[1:k]]))
write.table(paste(user, res, sep=’:'), file=’result.dat’,quote=FALSE, row.name=FALSE, col.name=FALSE)