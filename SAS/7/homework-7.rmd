数据分析与SAS 第七周作业 - 张丹(11)
========================================================

阅读作业 
继续阅读薛毅的书或其它关于概率统计的教材，下周将讲方差分析，需要一些基本的概率统计概念 

书面作业 
董大均书p255 3、4、6、7 

互动作业 
本周的互动继续以SAS编程和数学讨论为主。可以围绕第7周课程有关知识展开。SAS的问题可以在SAS中国用户组板块讨论，数学问题可以在数据分析与数据挖掘技术板块讨论 
要求每位同学至少发2篇主题，至少参与5个上述主题的讨论（回帖）。 
注意在Dataguru课程平台上，新增加“互动”功能标签，大家进入后可以看到本周的互动要求（板块，时间段，数量等），以及你现在的完成进度情况。 
本周的书面作业和互动作业都纳入罚扣考核范围，请大家注意按时按质完成！

***

## 3. 假设减肥前后没有明显变化，计算减肥前后的差值d.

```{sas}
libname homework "D:\dataguru\SAS\7";

DATA q3;
INPUT x1 x2 @@;
  d=x1-x2;

CARDS;
68 66 80 75 79 79 90 87 77 78 99 89
75 76 82 81 89 88 92 90 79 80 82 84
;
RUN;

PROC MEANS MEAN STD STDERR T PRT;
	VAR d;
RUN;
```


          SAS 系统          2012年09月12日 星期三 下午09时30分07秒   3
        
                                  MEANS PROCEDURE
        
                                    分析变量: d
        
                均值          标准差        标准误差       t 值    Pr > |t|
        -------------------------------------------------------------------
           1.5833333       3.3154825       0.9570974       1.65      0.1263
        -------------------------------------------------------------------


### 因为t=1.65, p=0.1263>0.05，不能拒绝原假设。
### 结论：减肥前后没有显著变化，这种治疗无效。

***


## 4.假设中毒者与正常人没有显著差
```{sas}
libname homework "D:\dataguru\SAS\7";

DATA q4;
INPUT x @@;
  x=x-72;

CARDS;
54 67 68 78 70 66 68 71 66 69
;
RUN;

PROC MEANS T PRT;
RUN;
```
         SAS 系统   2012年09月12日 星期三 下午09时30分07秒  
        
                  MEANS PROCEDURE
        
                    分析变量: x
        
                   t 值    Pr > |t|
                -------------------
                  -2.29      0.0480
                -------------------



### 因为，t=-2.29, p=0.048<0.05，则拒绝原假设
### 结论：减肥前后有显著变化，中毒者与正常人有区别。

***

## 6.假设某药物对大白鼠没有显著差异。

```{sas}
libname homework "D:\dataguru\SAS\7";

DATA q3;
INPUT x @@;
  IF _N_>10 THEN a=2;
	ELSE a=1;
CARDS;
56 55 54 53 56 52 57 54 52 56
50 48 49 49 50 50 60 55 43 52 56 57
;
RUN;

PROC TTEST;
	CLASS a;
	VAR x;
RUN;
```


                                              The TTEST Procedure

                                                 Variable:  x

                 a               N        Mean     Std Dev     Std Err     Minimum     Maximum

                 1              10     54.5000      1.7795      0.5627     52.0000     57.0000
                 2              12     51.5833      4.6604      1.3454     43.0000     60.0000
                 Diff (1-2)             2.9167      3.6566      1.5657

         a             Method               Mean       95% CL Mean        Std Dev      95% CL Std Dev

         1                               54.5000     53.2270  55.7730      1.7795      1.2240   3.2487
         2                               51.5833     48.6222  54.5444      4.6604      3.3014   7.9129
         Diff (1-2)    Pooled             2.9167     -0.3493   6.1826      3.6566      2.7975   5.2804
         Diff (1-2)    Satterthwaite      2.9167     -0.1983   6.0317

                          Method           Variances        DF    t Value    Pr > |t|

                          Pooled           Equal            20       1.86      0.0772
                          Satterthwaite    Unequal      14.638       2.00      0.0644

                                             Equality of Variances

                               Method      Num DF    Den DF    F Value    Pr > F

                               Folded F        11         9       6.86    0.0074


### 通过齐方差检验，F=6.868,RP>F为0.0074，齐方差检验成立。
### 取Equal项，t=1.86, p=0.0772>0.05，因此，没有显著性变化，不能拒绝原假设。
### 某药物对大白鼠肉瘤无影响。

***

## 7. 假设该药未引起血经蛋白变化

```{sas}
libname homework "D:\dataguru\SAS\7";

DATA q4;
INPUT x @@;
  IF _N_>10 THEN a=2;
	ELSE a=1;
CARDS;
11.3 14.0 15.0 13.8 15.0 14.0 13.5 13.5 12.8 13.5
10.0 12.0 11.0 14.7 12.0 11.4 13.0 13.8 12.3 12.0
;
RUN;

PROC NPAR1WAY WILCOXON;
	CLASS a;
	VAR x;
RUN;
```
        
         SAS 系统       2012年09月12日 星期三 下午09时30分07秒  14
        
                              The NPAR1WAY Procedure
        
                    Wilcoxon Scores (Rank Sums) for Variable x
                             Classified by Variable a
        
                          Sum of      Expected       Std Dev          Mean
         a       N        Scores      Under H0      Under H0         Score
         -----------------------------------------------------------------
         1      10        134.50         105.0     13.173938        13.450
         2      10         75.50         105.0     13.173938         7.550
        
                        Average scores were used for ties.
        
        
                             Wilcoxon Two-Sample Test
        
                          Statistic             134.5000
        
                          Normal Approximation
                          Z                       2.2013
                          One-Sided Pr >  Z       0.0139
                          Two-Sided Pr > |Z|      0.0277
        
                          t Approximation
                          One-Sided Pr >  Z       0.0201
                          Two-Sided Pr > |Z|      0.0403
        
                    Z includes a continuity correction of 0.5.
        
        
                               Kruskal-Wallis Test
        
                          Chi-Square              5.0143
                          DF                           1
                          Pr > Chi-Square         0.0251


### 由于Wilcoxon秩和检验的双边的p值都<0.05，因此，有显著性变化，拒绝原假设。
### 结论：该药引起血经蛋白变化！

