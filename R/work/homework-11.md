第11周 数据分析与R语言  -- 张丹(24)
========================================================

书面作业 
1-2 薛毅书P557，9.1-9.2 

互动作业 
本周的互动仍以算法和R语言实现为主。 
要求每位同学至少发2篇主题，就算法理论以及在R上的有关用法进行探讨。发到R中国用户组或数据分析与数据挖掘版。 
另外要求每位同学至少参与5个上述主题的讨论（回帖）。

-------------------------------------------

9.1(1)
--------------------------------------------



```r
data <- data.frame(x1 = c(90342, 4903, 6735, 49454, 139190, 12215, 
    2372, 11062, 17111, 1206, 2150, 5251, 14341), x2 = c(52455, 1973, 21139, 
    36241, 203505, 16219, 6572, 23078, 23907, 3930, 5704, 6155, 13203), x3 = c(101091, 
    2035, 3767, 81557, 215898, 10351, 8103, 54935, 52108, 6126, 6200, 10383, 
    19396), x4 = c(19272, 10313, 1780, 22504, 10609, 6382, 12329, 23804, 21796, 
    15586, 10870, 16875, 14961), x5 = c(82, 34.2, 36.1, 98.1, 93.2, 62.5, 184.4, 
    370.4, 221.5, 330.4, 184.2, 146.4, 94.6), x6 = c(16.1, 7.1, 8.2, 25.9, 12.6, 
    8.7, 22.2, 41, 21.5, 29.5, 12, 27.5, 17.8), x7 = c(197435, 592077, 726396, 
    348226, 139572, 145818, 20921, 65486, 63806, 1840, 8913, 78796, 6354), x8 = c(0.172, 
    0.003, 0.003, 0.985, 0.628, 0.066, 0.152, 0.263, 0.276, 0.437, 0.274, 0.151, 
    1.574))
```




通过主成分析发现，Comp.1,Comp.2,Comp.3，的累积贡献率达到87％，因此使用这三个变量为主成分。



```r
prin <- princomp(data, cor = TRUE)
summary(prin, loadings = TRUE)
```

```
## Importance of components:
##                        Comp.1 Comp.2 Comp.3  Comp.4  Comp.5  Comp.6
## Standard deviation     1.7622 1.7025 0.9646 0.80063 0.55080 0.29425
## Proportion of Variance 0.3882 0.3623 0.1163 0.08013 0.03792 0.01082
## Cumulative Proportion  0.3882 0.7505 0.8668 0.94693 0.98485 0.99567
##                         Comp.7    Comp.8
## Standard deviation     0.17934 0.0496635
## Proportion of Variance 0.00402 0.0003083
## Cumulative Proportion  0.99969 1.0000000
## 
## Loadings:
##    Comp.1 Comp.2 Comp.3 Comp.4 Comp.5 Comp.6 Comp.7 Comp.8
## x1 -0.476 -0.297 -0.104         0.186         0.757  0.245
## x2 -0.472 -0.279 -0.166  0.171 -0.305        -0.519  0.527
## x3 -0.423 -0.379 -0.157                      -0.174 -0.780
## x4  0.214 -0.451        -0.514  0.540  0.288 -0.250  0.220
## x5  0.389 -0.329 -0.328  0.193 -0.448  0.583  0.232       
## x6  0.353 -0.401 -0.147 -0.283 -0.314 -0.713              
## x7 -0.216  0.377 -0.129 -0.762 -0.415  0.194              
## x8        -0.275  0.889        -0.330  0.119              
```

```r
screeplot(prin, type = "lines")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


主成分析Comp.1(x1-x7),Comp.2(x1-x8)，实在不懂怎么解释，参考论坛的解释。
--------------------------------------------
第1主成分是资产等数量与生产率等比率的差，生产率高，所需的人员等就可以少。反之相反。
第2主成分是标准燃料消耗量与其他值的差，标准燃料消耗量多了，其他值就少了。反之相反。
第3主成分能源利用效果与其他值的差，能源利用效果大了，其他值需要的就少了。反之相反



(2)对13行业数据进行分4类: hclust，ward方法与kmeans分类一致！
--------------------------------------------


```r
library(cluster)
library(fpc)
```

```
## Warning: package 'fpc' was built under R version 2.15.1
```

```
## Loading required package: MASS
```

```
## Warning: package 'MASS' was built under R version 2.15.1
```

```
## Loading required package: mclust
```

```
## Warning: package 'mclust' was built under R version 2.15.1
```

```
## by using mclust, invoked on its own or through another package, you accept
## the license agreement in the mclust LICENSE file and at
## http://www.stat.washington.edu/mclust/license.txt
```

```
## Loading required package: flexmix
```

```
## Warning: package 'flexmix' was built under R version 2.15.1
```

```
## Loading required package: lattice
```

```
## Loading required package: modeltools
```

```
## Loading required package: stats4
```

```
## Loading required package: multcomp
```

```
## Warning: package 'multcomp' was built under R version 2.15.1
```

```
## Loading required package: mvtnorm
```

```
## Loading required package: survival
```

```
## Loading required package: splines
```

```r

pre <- predict(prin)
h <- hclust(dist(pre[, 1:3]), "ward")
plot(h)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r

k <- kmeans(pre[, 1:3], 4)
library(cluster)
clusplot(pre, k$cluster, color = TRUE, shade = TRUE, labels = 2, 
    lines = 0)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 

```r

library(fpc)
plotcluster(pre, k$cluster)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-33.png) 


对13行业数据进行排序：根据３个主成分，分为排序的结果如下。
--------------------------------------------



```r
arr <- cbind(c(1:13), pre[, 1], pre[, 2], pre[, 3])
```



第一主成分Comp.1


```r
print(arr[order(-arr[, 2]), ][, 1])
```

```
##  [1]  8 10 12  7  9 11 13  6  4  2  3  1  5
```



第二主成分Comp.2


```r
print(arr[order(-arr[, 3]), ][, 1])
```

```
##  [1]  3  2  6 11  7 12 13  1 10  9  4  8  5
```



第三主成分Comp.3


```r
print(arr[order(-arr[, 4]), ][, 1])
```

```
##  [1] 13  4 11  6  2 10 12  7  9  3  5  1  8
```








9.2 
--------------------------------------------



```r
data <- data.frame(x1 = c(82.9, 88, 99.9, 105.3, 117.7, 131, 148.2, 
    161.8, 174.2, 184.7), x2 = c(92, 93, 96, 94, 100, 101, 105, 112, 112, 112), 
    x3 = c(17.1, 21.3, 25.1, 29, 34, 40, 44, 49, 51, 53), x4 = c(94, 96, 97, 
        97, 100, 101, 104, 109, 111, 111), y = c(8.4, 9.6, 10.4, 11.4, 12.2, 
        14.2, 15.8, 17.9, 19.6, 20.8))
```




首先对数据进行线性回归分析，t检验的效果不好！


```r
lm1 <- lm(y ~ x1 + x2 + x3 + x4, data = data)
summary(lm1)
```

```
## 
## Call:
## lm(formula = y ~ x1 + x2 + x3 + x4, data = data)
## 
## Residuals:
##        1        2        3        4        5        6        7        8 
##  0.02480  0.07948  0.01238 -0.00703 -0.28835  0.21609 -0.14209  0.15836 
##        9       10 
## -0.13596  0.08231 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept) -17.6677     5.9436   -2.97   0.0311 * 
## x1            0.0901     0.0210    4.30   0.0077 **
## x2           -0.2313     0.0713   -3.24   0.0229 * 
## x3            0.0181     0.0391    0.46   0.6633   
## x4            0.4207     0.1185    3.55   0.0164 * 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
## 
## Residual standard error: 0.204 on 5 degrees of freedom
## Multiple R-squared: 0.999,	Adjusted R-squared: 0.998 
## F-statistic: 1.02e+03 on 4 and 5 DF,  p-value: 1.83e-07 
## 
```




对数据进行主程分析，结果发现，第一个主成分贡献率已经高达0.986，因此选择comp1为主成分子。


```r
pr <- princomp(~x1 + x2 + x3 + x4, data = data, cor = TRUE)
summary(pr, loadings = TRUE)
```

```
## Importance of components:
##                        Comp.1   Comp.2   Comp.3    Comp.4
## Standard deviation      1.986 0.199907 0.112190 0.0603086
## Proportion of Variance  0.986 0.009991 0.003147 0.0009093
## Cumulative Proportion   0.986 0.995944 0.999091 1.0000000
## 
## Loadings:
##    Comp.1 Comp.2 Comp.3 Comp.4
## x1 -0.502 -0.237  0.579  0.598
## x2 -0.500  0.493 -0.610  0.367
## x3 -0.498 -0.707 -0.368 -0.342
## x4 -0.501  0.449  0.396 -0.626
```



对comp1进行回归分析，t检验和F检验，效果都很好！

基于主成comp1回归方程：y=14.0300+2.0612*z1



```r
pre <- predict(pr)
data$z1 <- pre[, 1]

lm <- lm(y ~ z1, data = data)
summary(lm)
```

```
## 
## Call:
## lm(formula = y ~ z1, data = data)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.7224 -0.2095  0.0515  0.2103  0.8186 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  14.0300     0.1662    84.4  4.3e-13 ***
## z1           -2.0612     0.0837   -24.6  7.9e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
## 
## Residual standard error: 0.525 on 8 degrees of freedom
## Multiple R-squared: 0.987,	Adjusted R-squared: 0.985 
## F-statistic:  607 on 1 and 8 DF,  p-value: 7.87e-09 
## 
```



转换comp1为原始变量x1,x2,x3,x4

基于原始变量的回归方程为：
y= -23.77772+0.02993 * x1 + 0.133658 * x2 + 0.08361 *x3 + 0.16965 *x4



```r
beta <- coef(lm)
A <- loadings(pr)
x.bar <- pr$center
x.sd <- pr$scale

coef <- (beta[2] * A[, 1])/x.sd
beta0 <- beta[1] - sum(x.bar * coef)

c(beta0, coef)
```

```
## (Intercept)          x1          x2          x3          x4 
##   -23.77772     0.02993     0.13365     0.08361     0.16965 
```



