Oracle 第八周作业 - 张丹(15)
========================================================

阅读作业 本节课的内容是之前内容的一个实际应用,大家可以按照PPT上设计的章节选择阅读.。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.自己构造两条不同的SQL来完成相同的查询,注意结果集重用对SQL性能的影响
2.对于分区表， 当查询范围在一个分区以内以及跨分区查询时，比较本地索引和全局索引的性能差异。
3.对第一题和第二题分别用sql_trace和10046事件生成trace文件，并使用tkprof工具处理得到处理过的结果。
4.对第一题和第二题分别生成10053 trace文件，尝试解释oracle是如何生成一个执行计划的。

互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

1. 经过对比查询发现，重用结果集的执行效率要比未重用的，高很多！！
-----------------------------------------------------------------------------

create table t8_1 as select object_id as id,object_type as type from dba_objects;

SQL> set autotrace on;
SQL> select
  2    (select count(*) from t8_1 ) t_all,
  3    (select count(*) from t8_1 where type='INDEX')  t_index,
  4    (select count(*) from t8_1 where type='TABLE')  t_table,
  5    (select count(*) from t8_1 where type='CLUSTER')  t_cluster,
  6    (select count(*) from t8_1 where type='SEQUENCE') t_sequence,
  7    (select count(*) from t8_1 where type='EDITION')  t_edition,
  8    (select count(*) from t8_1 where type='LOB')  t_lob,
  9    (select count(*) from t8_1 where type='SYNONYM')  t_synonym
 10  from dual;

    --------------------------------------------------------------------------------------
    | T_ALL    T_INDEX    T_TABLE  T_CLUSTER T_SEQUENCE  T_EDITION      T_LOB  T_SYNONYM |
    --------------------------------------------------------------------------------------
    | 72696       3926       2904         10        228          1        911     27803  |
    --------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    | Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    ---------------------------------------------------------------------------
    |   0 | SELECT STATEMENT   |      |     1 |       |     2   (0)| 00:00:01 |
    |   1 |  SORT AGGREGATE    |      |     1 |       |            |          |
    |   2 |   TABLE ACCESS FULL| T8_1 | 77981 |       |    53   (2)| 00:00:01 |
    |   3 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |*  4 |   TABLE ACCESS FULL| T8_1 |  3227 | 35497 |    53   (2)| 00:00:01 |
    |   5 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |*  6 |   TABLE ACCESS FULL| T8_1 |  2264 | 24904 |    53   (2)| 00:00:01 |
    |   7 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |*  8 |   TABLE ACCESS FULL| T8_1 |     2 |    22 |    53   (2)| 00:00:01 |
    |   9 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |* 10 |   TABLE ACCESS FULL| T8_1 |   151 |  1661 |    53   (2)| 00:00:01 |
    |  11 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |* 12 |   TABLE ACCESS FULL| T8_1 |     2 |    22 |    53   (2)| 00:00:01 |
    |  13 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |* 14 |   TABLE ACCESS FULL| T8_1 |   644 |  7084 |    53   (2)| 00:00:01 |
    |  15 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |* 16 |   TABLE ACCESS FULL| T8_1 | 32506 |  349K |    53   (2)| 00:00:01 |
    |  17 |  FAST DUAL         |      |     1 |       |     2   (0)| 00:00:01 |
    ---------------------------------------------------------------------------

    Predicate Information (identified by operation id):
    ---------------------------------------------------
    
       4 - filter("TYPE"='INDEX')
       6 - filter("TYPE"='TABLE')
       8 - filter("TYPE"='CLUSTER')
      10 - filter("TYPE"='SEQUENCE')
      12 - filter("TYPE"='EDITION')
      14 - filter("TYPE"='LOB')
      16 - filter("TYPE"='SYNONYM')


    统计信息
    ----------------------------------------------------------
              0  recursive calls
              0  db block gets
           1520  consistent gets
              0  physical reads
              0  redo size
            890  bytes sent via SQL*Net to client
            419  bytes received via SQL*Net from client
              2  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
              1  rows processed

SQL> select
  2    count(*) t_all,
  3    count(decode(type,'INDEX',type,null)) t_index,
  4    count(decode(type,'TABLE',type,null)) t_table,
  5    count(decode(type,'CLUSTER',type,null)) t_cluster,
  6    count(decode(type,'SEQUENCE',type,null)) t_sequence,
  7    count(decode(type,'EDITION',type,null)) t_edition,
  8    count(decode(type,'LOB',type,null)) t_lob,
  9    count(decode(type,'SYNONYM',type,null)) t_synonym
 10  from t8_1;

    --------------------------------------------------------------------------------------
    | T_ALL    T_INDEX    T_TABLE  T_CLUSTER T_SEQUENCE  T_EDITION      T_LOB  T_SYNONYM |
    --------------------------------------------------------------------------------------
    | 72696       3926       2904         10        228          1        911     27803  |
    --------------------------------------------------------------------------------------
    
    ---------------------------------------------------------------------------
    | Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    ---------------------------------------------------------------------------
    |   0 | SELECT STATEMENT   |      |     1 |    11 |    53   (2)| 00:00:01 |
    |   1 |  SORT AGGREGATE    |      |     1 |    11 |            |          |
    |   2 |   TABLE ACCESS FULL| T8_1 | 77981 |   837K|    53   (2)| 00:00:01 |
    ---------------------------------------------------------------------------

    
    统计信息
    ----------------------------------------------------------
              0  recursive calls
              0  db block gets
            190  consistent gets
              0  physical reads
              0  redo size
            890  bytes sent via SQL*Net to client
            419  bytes received via SQL*Net from client
              2  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
              1  rows processed



2. 
-----------------------------------------------------------------------------
创建分区表t8_2，并插入数据集。

create table t8_2(
id int, type VARCHAR2(20)
)
PARTITION BY RANGE(id)
(
PARTITION id_1 VALUES LESS THAN(10000),
PARTITION id_2 VALUES LESS THAN(20000),
PARTITION id_3 VALUES LESS THAN(30000),
PARTITION id_4 VALUES LESS THAN(40000),
PARTITION id_5 VALUES LESS THAN(50000),
PARTITION id_6 VALUES LESS THAN(60000),
PARTITION id_7 VALUES LESS THAN(70000),
PARTITION id_other VALUES LESS THAN(maxvalue)
);

insert into t8_2 select object_id as id,object_type as type from dba_objects


不跨分区查询时，全局索引和分区索引执行效率几乎相同。
-----------------------------------------------------------------------------

使用分区索引：create index t8_2_local_index on t8_2(id) local;
SQL> select * from t8_2 where (id>9980 and id<9990) or (id>29990 and id<29999);

    ------------------------------------------------------------------------------------------------------------------------
    | Id  | Operation                           | Name             | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
    ------------------------------------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT                    |                  |    17 |   425 |     6   (0)| 00:00:01 |       |       |
    |   1 |  CONCATENATION                      |                  |       |       |            |          |       |       |
    |   2 |   PARTITION RANGE SINGLE            |                  |     8 |   200 |     3   (0)| 00:00:01 |     3 |     3 |
    |   3 |    TABLE ACCESS BY LOCAL INDEX ROWID| T8_2             |     8 |   200 |     3   (0)| 00:00:01 |     3 |     3 |
    |*  4 |     INDEX RANGE SCAN                | T8_2_LOCAL_INDEX |     3 |       |     2   (0)| 00:00:01 |     3 |     3 |
    |   5 |   PARTITION RANGE SINGLE            |                  |     9 |   225 |     3   (0)| 00:00:01 |     1 |     1 |
    |   6 |    TABLE ACCESS BY LOCAL INDEX ROWID| T8_2             |     9 |   225 |     3   (0)| 00:00:01 |     1 |     1 |
    |*  7 |     INDEX RANGE SCAN                | T8_2_LOCAL_INDEX |     2 |       |     2   (0)| 00:00:01 |     1 |     1 |
    ------------------------------------------------------------------------------------------------------------------------
    
    Predicate Information (identified by operation id):
    ---------------------------------------------------
    
       4 - access("ID">29990 AND "ID"<29999)
       7 - access("ID">9980 AND "ID"<9990)
           filter(LNNVL("ID">29990) OR LNNVL("ID"<29999))
    
    Note
    -----
       - dynamic sampling used for this statement (level=2)
    
    
    统计信息
    ----------------------------------------------------------
              0  recursive calls
              0  db block gets
             10  consistent gets
              0  physical reads
              0  redo size
            912  bytes sent via SQL*Net to client
            430  bytes received via SQL*Net from client
              3  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
             17  rows processed


使用全局索引：create index t8_2_global_index on t8_2(id) ;
SQL> select * from t8_2 where (id>9980 and id<9990) or (id>29990 and id<29999);

    -------------------------------------------------------------------------------------------------------------------------
    | Id  | Operation                           | Name              | Rows  | Bytes| Cost (%CPU)| Time     | Pstart| Pstop |
    ------------------------------------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT                    |                   |    41 |  1025|     6   (0)| 00:00:01 |       |       |
    |   1 |  CONCATENATION                      |                   |       |      |            |          |       |       |
    |   2 |   TABLE ACCESS BY GLOBAL INDEX ROWID| T8_2              |     8 |   200|     3   (0)| 00:00:01 |     3 |     3 |
    |*  3 |    INDEX RANGE SCAN                 | T8_2_GLOBAL_INDEX |    10 |      |     2   (0)| 00:00:01 |       |       |
    |   4 |   TABLE ACCESS BY GLOBAL INDEX ROWID| T8_2              |    33 |   825|     3   (0)| 00:00:01 |     1 |     1 |
    |*  5 |    INDEX RANGE SCAN                 | T8_2_GLOBAL_INDEX |     8 |      |     2   (0)| 00:00:01 |       |       |
    -------------------------------------------------------------------------------------------------------------------------
    
    
    Predicate Information (identified by operation id):
    ---------------------------------------------------
    
       3 - access("ID">29990 AND "ID"<29999)
       5 - access("ID">9980 AND "ID"<9990)
           filter(LNNVL("ID">29990) OR LNNVL("ID"<29999))
    
    Note
    -----
       - dynamic sampling used for this statement (level=2)
    
    
    统计信息
    ----------------------------------------------------------
              0  recursive calls
              0  db block gets
             10  consistent gets
              0  physical reads
              0  redo size
            912  bytes sent via SQL*Net to client
            430  bytes received via SQL*Net from client
              3  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
             17  rows processed



跨分区查询时，全局索引的效率要比分区索引高！
-----------------------------------------------------------------------------

使用分区索引：create index t8_2_local_index on t8_2(id) local;
SQL> select * from t8_2 where (id>9990 and id<10010) or (id>29990 and id<30010);

    ------------------------------------------------------------------------------------------------------------------------
    | Id  | Operation                           | Name             | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
    ------------------------------------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT                    |                  |    38 |   950 |     6   (0)| 00:00:01 |       |       |
    |   1 |  CONCATENATION                      |                  |       |       |            |          |       |       |
    |   2 |   PARTITION RANGE ITERATOR          |                  |    19 |   475 |     3   (0)| 00:00:01 |     3 |     4 |
    |   3 |    TABLE ACCESS BY LOCAL INDEX ROWID| T8_2             |    19 |   475 |     3   (0)| 00:00:01 |     3 |     4 |
    |*  4 |     INDEX RANGE SCAN                | T8_2_LOCAL_INDEX |    12 |       |     2   (0)| 00:00:01 |     3 |     4 |
    |   5 |   PARTITION RANGE ITERATOR          |                  |    19 |   475 |     3   (0)| 00:00:01 |     1 |     2 |
    |   6 |    TABLE ACCESS BY LOCAL INDEX ROWID| T8_2             |    19 |   475 |     3   (0)| 00:00:01 |     1 |     2 |
    |*  7 |     INDEX RANGE SCAN                | T8_2_LOCAL_INDEX |    10 |       |     2   (0)| 00:00:01 |     1 |     2 |
    ------------------------------------------------------------------------------------------------------------------------
    
    Predicate Information (identified by operation id):
    ---------------------------------------------------
    
       4 - access("ID">29990 AND "ID"<30010)
       7 - access("ID">9990 AND "ID"<10010)
           filter(LNNVL("ID">29990) OR LNNVL("ID"<30010))
    
    Note
    -----
       - dynamic sampling used for this statement (level=2)
    
    
    统计信息
    ----------------------------------------------------------
              0  recursive calls
              0  db block gets
             18  consistent gets
              0  physical reads
              0  redo size
           1317  bytes sent via SQL*Net to client
            441  bytes received via SQL*Net from client
              4  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
             38  rows processed


使用全局索引：create index t8_2_global_index on t8_2(id) ;
SQL> select * from t8_2 where (id>9990 and id<10010) or (id>29990 and id<30010);

    -------------------------------------------------------------------------------------------------------------------------
    | Id  | Operation                           | Name              | Rows  | Bytes| Cost (%CPU)| Time     | Pstart| Pstop |
    -------------------------------------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT                    |                   |    88 |  2200|     6   (0)| 00:00:01 |       |       |
    |   1 |  CONCATENATION                      |                   |       |      |            |          |       |       |
    |   2 |   TABLE ACCESS BY GLOBAL INDEX ROWID| T8_2              |    19 |   475|     3   (0)| 00:00:01 | ROWID | ROWID |
    |*  3 |    INDEX RANGE SCAN                 | T8_2_GLOBAL_INDEX |    21 |      |     2   (0)| 00:00:01 |       |       |
    |   4 |   TABLE ACCESS BY GLOBAL INDEX ROWID| T8_2              |    69 |  1725|     3   (0)| 00:00:01 | ROWID | ROWID |
    |*  5 |    INDEX RANGE SCAN                 | T8_2_GLOBAL_INDEX |    19 |      |     2   (0)| 00:00:01 |       |       |
    -------------------------------------------------------------------------------------------------------------------------
    
    Predicate Information (identified by operation id):
    ---------------------------------------------------
    
       3 - access("ID">29990 AND "ID"<30010)
       5 - access("ID">9990 AND "ID"<10010)
           filter(LNNVL("ID">29990) OR LNNVL("ID"<30010))
    
    Note
    -----
       - dynamic sampling used for this statement (level=2)
    
    
    统计信息
    ----------------------------------------------------------
              1  recursive calls
              0  db block gets
             14  consistent gets
              0  physical reads
              0  redo size
           1317  bytes sent via SQL*Net to client
            441  bytes received via SQL*Net from client
              4  SQL*Net roundtrips to/from client
              0  sorts (memory)
              0  sorts (disk)
             38  rows processed



3. 生成4个文件，见附件
-----------------------------------------------------------------------------
alter session set tracefile_identifier='t8_1';
alter session set sql_trace=true;
//上面运行SQL语句....
alter session set sql_trace=false;

tkprof orcl_ora_xxx.trc xxx_sql_trace.txt

    t8_1_sql_trace.txt
    t8_2_sql_trace.txt

alter session set tracefile_identifier='t8_2';
alter session set events '10046 trace name context forever,level 12';
//上面运行SQL语句....
alter session set events '10046 trace name context off';

tkprof orcl_ora_xxx.trc xxx_10046.txt

    t8_2_10046.txt
    t8_2_10046.txt


4. 生成2个文件，见附件
-----------------------------------------------------------------------------
Oracle通过CBO,计算每一步的成本和估算Cardinality,即找到代价最少的执行计划。


    t8_1_10053.txt
    t8_2_10053.txt
