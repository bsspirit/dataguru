第1周 Hadoop数据分析平台  -- 张丹(12)
========================================================

书面作业 

根据幻灯片中第9页所给出的“4网页模型” 
1）计算每个网页的pagerank，手算、编程计算或利用数据分析工具（例如R）等各种方法均可，拷贝或抓图完整的计算过程和结果 
2）按照map-reduce的思想，现在假设有物理节点A，B参与计算，其中网页1、2保存于A，网页3、4保存于B，试述完整的pagerank计算过程 

互动作业 

本周的互动内容自由，可以围绕着课程幻灯片涉及的内容展开。 例如pagerank的计算，分布式存储和map-reduce的基本思想，hadoop的发展历史和现状，产品家族等。 
要求每位同学至少发2篇主题（Hadoop版：http://f.dataguru.cn/forum-59-1.html），至少参与5个上述主题的讨论（回帖）。 
注意在Dataguru课程平台上的“互动”功能标签，大家进入后可以看到本周的互动要求（板块，时间段，数量等），以及你现在的完成进度情况。 
本周的书面作业和互动作业都纳入罚扣考核范围，请大家注意按时按质完成

## 1. 计算Page-Rank的两种方法


    


```r
pagerank <- function(G, method = "eigen", d = 0.85, niter = 100) {
    cvec <- apply(G, 2, sum)
    cvec[cvec == 0] <- 1  # nodes with indegree 0 will cause problems if we divide by 0.
    gvec <- apply(G, 1, sum)
    n <- nrow(G)
    delta <- (1 - d)/n
    A <- matrix(delta, nrow(G), ncol(G))
    for (i in 1:n) A[i, ] <- A[i, ] + d * G[i, ]/cvec
    # print(A)
    if (method == "power") {
        x <- rep(1, n)
        for (i in 1:niter) x <- A %*% x
    } else {
        x <- Re(eigen(A)$vector[, 1])
    }
    as.vector(x/sum(x))
}
S0 <- t(matrix(c(0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0), 
    nrow = 4))
```



### 1). 矩阵相乘 (power)


```r
pagerank(S0, "power", 0.85)
```

```
## [1] 0.0375 0.3732 0.2068 0.3825
```




### 2). 特征矩阵(eigen)


```r
pagerank(S0, "eigen", 0.85)
```

```
## [1] 0.0375 0.3732 0.2068 0.3825
```





## 2. 通过MapReduce计算PageRank
### Map过程，从网页中提取链接矩阵
### Reduce过程，计算链接矩阵，获得链接RP得分



```r
map <- function(S0, node = "a") {
    S <- apply(S0, 2, function(x) x/sum(x))
    if (node == "a") 
        S[, 1:2] else S[, 3:4]
}

reduce <- function(A, B, a = 0.85, niter = 100) {
    n <- nrow(A)
    q <- rep(1, n)
    Ga <- a * A + (1 - a)/n * (A[A != 1] = 1)
    Gb <- a * B + (1 - a)/n * (B[B != 1] = 1)
    for (i in 1:niter) {
        qa <- as.matrix(q[1:ncol(A)])
        qb <- as.matrix(q[(ncol(A) + 1):n])
        q <- Ga %*% qa + Gb %*% qb
    }
    as.vector(q/sum(q))
}

S0 <- t(matrix(c(0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0), 
    nrow = 4))
A <- map(S0, "a")
B <- map(S0, "b")
reduce(A, B)
```

```
## [1] 0.0375 0.3732 0.2068 0.3825
```



