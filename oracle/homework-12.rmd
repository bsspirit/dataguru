Oracle 第十二周作业 - 张丹(15)
========================================================

阅读作业 《让Oracle跑得更快2》第12章RAC以及第14章 Data guard。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.演示通过在实例上创建不同的服务，对RAC进行业务分割，并贴出客户端连接不同实例的tnsnames.ora文件中的相关部分
2.演示通过配置参数，分别达到使并行分布到不同实例和限制在同一个实例上运行的效果
3.模拟最高保护模式下，当redo数据无法及时写入standby数据库时，primary db将发生什么情况。
4.设置data guard为最大可用模式，观察当redo无法到达standby数据库时，data guard保护模式的改变。

互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

***

### 由于本身环境所限,没有找到第二台Oracle备机,没办法完成进行实际操作的输出,只能从我的理解进行描述。

***
## 1. 通过客户端对RAC进行业务分割。
假设有4个RAC实例i1,i2,i3,i4，RAC_B1和RAC_B2是两种独立的业务，划分i1,i2到RAC_B1，i3,i4到RAC_B2
tnsname.ora

    RAC_B1=
    (DESCRIPTION=
      (ADDRESS=(PROTOCOL=TCP)(HOST=i1)(PORT=1521))
      (ADDRESS=(PROTOCOL=TCP)(HOST=i2)(PORT=1521))
      (LOAD_BALANCE=YES)
      (FAILOVER=ON)
      (CONNECT_DATA=
        (SERVER=DEDICATED)
        (SERVICE_NAME=RAC_B1)
      )
    )
    
    RAC_B2=
    (DESCRIPTION=
      (ADDRESS=(PROTOCOL=TCP)(HOST=i3)(PORT=1521))
      (ADDRESS=(PROTOCOL=TCP)(HOST=i4)(PORT=1521))
      (LOAD_BALANCE=YES)
      (FAILOVER=ON)
      (CONNECT_DATA=
        (SERVER=DEDICATED)
        (SERVICE_NAME=RAC_B2)
      )
    )

客户端连接：
sqlplus test/test@RAC_B1

       INSTANCE_NAME : i1

sqlplus test/test@RAC_B1

       INSTANCE_NAME : i2

sqlplus test/test@RAC_B2

       INSTANCE_NAME : i3
  
sqlplus test/test@RAC_B2

       INSTANCE_NAME : i4

***
## 2.通过instance-group和parallel_instance_group设置RAC的并行

###并行分布到不同实例效果 
在默认情况下，instance-group和parallel_instance_group的两个参数都是空的，并行将在所有实例上面执行。
创建一个新表t0，并行度10
create table t0 parallel 10 as select * from dba_objects;
全表查询
select * from t0
从执行计划将会发现查询使用了并行。

### 并行限制在同一个实例上运行的效果
设置instance-group和parallel_instance_group映射到RAC_B1和RAC_B2的实例上面，就可以使用并行只在配置的实例上执行了。


***
## 3. 在DG最高保护模式下，当standby的redo数据无法写入，会造成主库被强制ShutDown。

***
## 4. 在DG的最大可用模式下，当redo无法写入到standby数据库时，DG的保护模式将改变为最高性能模式。
