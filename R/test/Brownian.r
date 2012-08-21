#Brownian Motion follows cum. sums of Gaussian rv's
#布鎯运动
bm.mat = replicate(2, apply(matrix(rnorm(2000), 200, 10),
                     2, cumsum), simplify = FALSE)
#plot each step and pause for 0.05 secs
for (i in seq_len(200)) {
    plot(bm.mat[[1]][i, ], bm.mat[[2]][i, ],
                 xlim = range(bm.mat[[1]]),
                 ylim = range(bm.mat[[2]]),
                 pch = 19, ann = FALSE, axes = FALSE)
    Sys.sleep(0.001)
} 