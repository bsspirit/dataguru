Oracle 第十周作业 - 张丹(15)
========================================================

阅读作业 《让Oracle跑得更快1》第8.7章 直接加载。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.比较sql*loader使用conventional 和direct方式加载的性能差异。
2.比较直接加载使用conventional 和direct方式产生的redo大小（可以通过/*+ append */模拟直接加载）。
3.比较direct方式使用并行和非并行选项的性能差异。
4.直接加载对约束性索引和非约束型索引的影响。

互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

***

## 1. 建表，准备数据，准备sqlldr脚本

create table t10_1 
  as select object_id as id, object_name as name from dba_objects where rownum<10000;

到出t10_1到T10_1.csv

    "ID","NAME"
    "20","ICOL$"
    "46","I_USER1"
    "28","CON$"
    "15","UNDO$"
    "29","C_COBJ#"
    "3","I_OBJ#"
    "25","PROXY_ROLE_DATA$"
    "41","I_IND1"
    "54","I_CDEF2"
    "40","I_OBJ5"
    "26","I_PROXY_ROLE_DATA$_1"
    "17","FILE$"
    "13","UET$"
    "9","I_FILE#_BLOCK#"
    "43","I_FILE1"
    ...

清除数据
truncate table t10_1;

创建sqlldr脚本t10.ctl, 

    load data
    infile 'E:\tookit\oracle\11.2.0\sqlloader\T10_1.csv'
    into table t10_1
    Fields terminated by ","
    Optionally enclosed by '"'
    (ID ,
    NAME)

### 执行sqlldr,以direct=FALSE
sqlldr "'sys/sys123 as sysdba' DIRECT=FALSE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_1_false.out"

    达到提交点 - 逻辑记录计数 64
    达到提交点 - 逻辑记录计数 128
    达到提交点 - 逻辑记录计数 192
    达到提交点 - 逻辑记录计数 256
    达到提交点 - 逻辑记录计数 320
    达到提交点 - 逻辑记录计数 384
    达到提交点 - 逻辑记录计数 448
    达到提交点 - 逻辑记录计数 512
    达到提交点 - 逻辑记录计数 576
    达到提交点 - 逻辑记录计数 640
    达到提交点 - 逻辑记录计数 704
    达到提交点 - 逻辑记录计数 768
    达到提交点 - 逻辑记录计数 832

t10_1_false.out 文件

    表 T10_1,已加载从每个逻辑记录
    插入选项对此表 INSERT 生效
    
       列名                        位置      长度  中止 包装数据类型
    ------------------------------ ---------- ----- ---- ---- ---------------------
    ID                                  FIRST     *   ,  O (") CHARACTER            
    NAME                                 NEXT     *   ,  O (") CHARACTER            
    
    记录 1: 被拒绝 - 表 T10_1 的列 ID 出现错误。
    ORA-01722: 无效数字
    
    
    表 T10_1:
      9999 行 加载成功。
      由于数据错误, 1 行 没有加载。
      由于所有 WHEN 子句失败, 0 行 没有加载。
      由于所有字段都为空的, 0 行 没有加载。
    
    
    为绑定数组分配的空间:                 33024 字节 (64 行)
    读取   缓冲区字节数: 1048576
    
    跳过的逻辑记录总数:          0
    读取的逻辑记录总数:         10000
    拒绝的逻辑记录总数:          1
    废弃的逻辑记录总数:        0
    
    从 星期一 9月  03 15:58:17 2012 开始运行
    在 星期一 9月  03 15:58:18 2012 处运行结束
    
    经过时间为: 00: 00: 00.28
    CPU 时间为: 00: 00: 00.06

### 执行sqlldr,以direct=TRUE
sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_1_true.out"

    加载完成 - 逻辑记录计数 10000。
    
t10_1_true.out 文件

    表 T10_1,已加载从每个逻辑记录
    插入选项对此表 INSERT 生效
    
       列名                        位置      长度  中止 包装数据类型
    ------------------------------ ---------- ----- ---- ---- ---------------------
    ID                                  FIRST     *   ,  O (") CHARACTER            
    NAME                                 NEXT     *   ,  O (") CHARACTER            
    
    记录 1: 被拒绝 - 表 T10_1 的列 ID 出现错误。
    ORA-01722: 无效数字
    
    
    表 T10_1:
      9999 行 加载成功。
      由于数据错误, 1 行 没有加载。
      由于所有 WHEN 子句失败, 0 行 没有加载。
      由于所有字段都为空的, 0 行 没有加载。
    
    在直接路径中没有使用绑定数组大小。
    列数组  行数:    5000
    流缓冲区字节数:  256000
    读取   缓冲区字节数: 1048576
    
    跳过的逻辑记录总数:          0
    读取的逻辑记录总数:         10000
    拒绝的逻辑记录总数:          1
    废弃的逻辑记录总数:        0
    由 SQL*Loader 主线程加载的流缓冲区总数:        2
    由 SQL*Loader 加载线程加载的流缓冲区总数:        0
    
    从 星期一 9月  03 15:58:28 2012 开始运行
    在 星期一 9月  03 15:58:29 2012 处运行结束
    
    经过时间为: 00: 00: 01.53
    CPU 时间为: 00: 00: 00.05

### 从性能上比较，direct=TRUE时要执行速度要明显优于direct=FALSE

***

## 2. 建表及清空数据
create table t10_1 as select object_id as id, object_name as name from dba_objects where rownum<10000;
truncate table t10_1;

### 1)以传统的方式插入数据
SQL> set autotrace trace stat;
SQL> insert into t10_1 select object_id as id, object_name as name from dba_objects where rownum<10000;

    已创建9999行。

    统计信息
    ----------------------------------------------------------
            301  recursive calls
            298  db block gets
            506  consistent gets
              0  physical reads
         348708  redo size
            682  bytes sent via SQL*Net to client
            672  bytes received via SQL*Net from client
              3  SQL*Net roundtrips to/from client
              2  sorts (memory)
              0  sorts (disk)
           9999  rows processed

### 2)以append的方式插入数据

SQL> rollback;

    回退已完成。


SQL> insert /*+ append */ into t10_1 select object_id as id, object_name as name from dba_objects where rownum<10000;

    已创建9999行。

    统计信息
    ----------------------------------------------------------
            180  recursive calls
            105  db block gets
            383  consistent gets
              0  physical reads
           8500  redo size
            666  bytes sent via SQL*Net to client
            686  bytes received via SQL*Net from client
              3  SQL*Net roundtrips to/from client
              1  sorts (memory)
              0  sorts (disk)
           9999  rows processed

### 以append方式插入数据的redo size要明显小于传统方式的redo size!!

***

## 3. 原打算用 sqlldr实现并行测试，但提示不支持。
sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE PARALLEL=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_3_true_parallel.out"

    SQL*Loader: Release 11.2.0.1.0 - Production on 星期一 9月 3 16:12:00 2012
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    SQL*Loader-279:  在指定并行加载时只允许 APPEND 方式。

### 修改sqlldr脚本t10.ctl，第三行增加APPEND，解决上面的问题！！

    load data
    infile 'E:\tookit\oracle\11.2.0\sqlloader\T10_1.csv'
    APPEND
    into table t10_1
    Fields terminated by ","
    Optionally enclosed by '"'
    (ID ,
    NAME)
    
    
### 1)非并行的情况
sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE PARALLEL=FALSE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_3_true.out"

#### 所用路径:       直接

    要加载的数: ALL
    要跳过的数: 0
    允许的错误: 50
    继续:    未作指定
    所用路径:       直接
    
    表 T10_1,已加载从每个逻辑记录
    插入选项对此表 APPEND 生效
    
       列名                        位置      长度  中止 包装数据类型
    ------------------------------ ---------- ----- ---- ---- ---------------------
    ID                                  FIRST     *   ,  O (") CHARACTER            
    NAME                                 NEXT     *   ,  O (") CHARACTER            
    
    记录 1: 被拒绝 - 表 T10_1 的列 ID 出现错误。
    ORA-01722: 无效数字
    
    
    表 T10_1:
      9999 行 加载成功。
      由于数据错误, 1 行 没有加载。
      由于所有 WHEN 子句失败, 0 行 没有加载。
      由于所有字段都为空的, 0 行 没有加载。
    
    在直接路径中没有使用绑定数组大小。
    列数组  行数:    5000
    流缓冲区字节数:  256000
    读取   缓冲区字节数: 1048576
    
    跳过的逻辑记录总数:          0
    读取的逻辑记录总数:         10000
    拒绝的逻辑记录总数:          1
    废弃的逻辑记录总数:        0
    由 SQL*Loader 主线程加载的流缓冲区总数:        2
    由 SQL*Loader 加载线程加载的流缓冲区总数:        0
    
    从 星期一 9月  03 16:48:12 2012 开始运行
    在 星期一 9月  03 16:48:12 2012 处运行结束
    
    经过时间为: 00: 00: 00.20
    CPU 时间为: 00: 00: 00.01要加载的数: ALL
    要跳过的数: 0
    允许的错误: 50
    继续:    未作指定
    所用路径:       直接
    
    表 T10_1,已加载从每个逻辑记录
    插入选项对此表 APPEND 生效
    
       列名                        位置      长度  中止 包装数据类型
    ------------------------------ ---------- ----- ---- ---- ---------------------
    ID                                  FIRST     *   ,  O (") CHARACTER            
    NAME                                 NEXT     *   ,  O (") CHARACTER            
    
    记录 1: 被拒绝 - 表 T10_1 的列 ID 出现错误。
    ORA-01722: 无效数字
    
    
    表 T10_1:
      9999 行 加载成功。
      由于数据错误, 1 行 没有加载。
      由于所有 WHEN 子句失败, 0 行 没有加载。
      由于所有字段都为空的, 0 行 没有加载。
    
    在直接路径中没有使用绑定数组大小。
    列数组  行数:    5000
    流缓冲区字节数:  256000
    读取   缓冲区字节数: 1048576
    
    跳过的逻辑记录总数:          0
    读取的逻辑记录总数:         10000
    拒绝的逻辑记录总数:          1
    废弃的逻辑记录总数:        0
    由 SQL*Loader 主线程加载的流缓冲区总数:        2
    由 SQL*Loader 加载线程加载的流缓冲区总数:        0
    
    从 星期一 9月  03 16:48:12 2012 开始运行
    在 星期一 9月  03 16:48:12 2012 处运行结束
    
    经过时间为: 00: 00: 00.20
    CPU 时间为: 00: 00: 00.01
    
### 2)并行的情况
sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE PARALLEL=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_3_true_parallel.out"

#### 所用路径:       直接- 具有并行选项。

    要加载的数: ALL
    要跳过的数: 0
    允许的错误: 50
    继续:    未作指定
    所用路径:       直接- 具有并行选项。
    
    表 T10_1,已加载从每个逻辑记录
    插入选项对此表 APPEND 生效
    
       列名                        位置      长度  中止 包装数据类型
    ------------------------------ ---------- ----- ---- ---- ---------------------
    ID                                  FIRST     *   ,  O (") CHARACTER            
    NAME                                 NEXT     *   ,  O (") CHARACTER            
    
    记录 1: 被拒绝 - 表 T10_1 的列 ID 出现错误。
    ORA-01722: 无效数字
    
    
    表 T10_1:
      9999 行 加载成功。
      由于数据错误, 1 行 没有加载。
      由于所有 WHEN 子句失败, 0 行 没有加载。
      由于所有字段都为空的, 0 行 没有加载。
    
    在直接路径中没有使用绑定数组大小。
    列数组  行数:    5000
    流缓冲区字节数:  256000
    读取   缓冲区字节数: 1048576
    
    跳过的逻辑记录总数:          0
    读取的逻辑记录总数:         10000
    拒绝的逻辑记录总数:          1
    废弃的逻辑记录总数:        0
    由 SQL*Loader 主线程加载的流缓冲区总数:        2
    由 SQL*Loader 加载线程加载的流缓冲区总数:        0
    
    从 星期一 9月  03 16:47:52 2012 开始运行
    在 星期一 9月  03 16:47:52 2012 处运行结束
    
    经过时间为: 00: 00: 00.22
    CPU 时间为: 00: 00: 00.03

### 从运行结果来看，非并行要稍好于并行的结果。

***

## 4.建表及清空数据

create table t10_1 as select object_id as id, object_name as name from dba_objects where rownum<10000;
truncate table t10_1;

### 1)主键约束索引
ALTER TABLE t10_1 ADD CONSTRAINT cpk PRIMARY KEY (id)

SQL> select index_name,status from user_indexes where table_name='T10_1';

    INDEX_NAME                                                   STATUS
    ------------------------------------------------------------ ----------------
    CPK                                                          VALID

SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
             0

sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_4_true.out"

    SQL*Loader: Release 11.2.0.1.0 - Production on 星期一 9月 3 16:58:18 2012
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    加载完成 - 逻辑记录计数 10000。
    
SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
          9999

SQL> select index_name,status from user_indexes where table_name='T10_1';

    INDEX_NAME                                                   STATUS
    ------------------------------------------------------------ ----------------
    CPK                                                          VALID
    
### 此时约束索引依然有效，再进行sqlldr插入

sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_4_true.out"

    SQL*Loader: Release 11.2.0.1.0 - Production on 星期一 9月 3 16:59:29 2012
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    加载完成 - 逻辑记录计数 10000。
    
SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
         19998

SQL> select index_name,status from user_indexes where table_name='T10_1';

    INDEX_NAME                                                   STATUS
    ------------------------------------------------------------ ----------------
    CPK                                                          UNUSABLE

### 此时约束索引失效

### 2)普通索引
CREATE INDEX ind_t10_1_id on t10_1(id);

SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
             0

sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_4_tru.out"

    SQL*Loader: Release 11.2.0.1.0 - Production on 星期一 9月 3 17:02:54 2012
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    加载完成 - 逻辑记录计数 10000。

SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
          9999

SQL> select index_name,status from user_indexes where table_name='T10_1';

    INDEX_NAME                                                   STATUS
    ------------------------------------------------------------ ----------------
    IND_T10_1_ID                                                 VALID

### 此时普通约束索引依然有效，再进行sqlldr插入

sqlldr "'sys/sys123 as sysdba' DIRECT=TRUE control=../../sqlloader/t10.ctl log=../../sqlloader/t10_4_true.out"

    SQL*Loader: Release 11.2.0.1.0 - Production on 星期一 9月 3 17:04:08 2012
    
    Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
    
    加载完成 - 逻辑记录计数 10000。
    
SQL> select count(*) from t10_1;

      COUNT(*)
    ----------
         19998

SQL> select index_name,status from user_indexes where table_name='T10_1';

    INDEX_NAME                                                   STATUS
    ------------------------------------------------------------ ----------------
    IND_T10_1_ID                                                 VALID    
    
### 此时普通约束索引依然有效，因此非约束索引，不会因为sqlldr的插入而失效。
