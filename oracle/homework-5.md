Oracle 第五周作业 - 张丹(15)
========================================================

阅读作业 阅读《让Oracle跑得更快1》第8章-并行执行。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.利用你现有的设备资源,分别比较几种场景（count,group by,以及条件语句）下的并行和非并行的性能差异并尝试分析原因。
2.比较sql*Loader加载数据以及/*+append */方式插入数据时，分别使用并行和非并行选项时的性能差异，并尝试分析原因。
3.比较创建表，索引，alter table move等场景下并行和非并行的性能差异。
4.对于DML操作，尝试使用并行和非并行，比较性能差异。


互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配 的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数 据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形 式）。

--------------------------------------------------------



1.由于测试数据量不大，并且未进行表分区，CPO/IO资源都不太多，因为并行的速度，没有串行速度快。
-----------------------------------------------

create table tpal1 as select object_id as id, object_name as name, status from dba_objects;
create index tpall_index on tpal1(id);

无并行的情况
select  count(*),status from tpal1 group by status;

Plan hash value: 492067268
| Id  | Operation          | Name  | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT   |       | 79676 |   389K|   116   (5)| 00:00:02 |
|   1 |  HASH GROUP BY     |       | 79676 |   389K|   116   (5)| 00:00:02 |
|   2 |   TABLE ACCESS FULL| TPAL1 | 79676 |   389K|   112   (1)| 00:00:02 |


并行度是4的情况
alter table tpal1 parallel 4;
select  count(*),status from tpal1 group by status;

Plan hash value: 583428510
| Id  | Operation                | Name     | Rows  | Bytes | Cost (%CPU)| Time     |    TQ  |IN-OUT| PQ Distrib |
|   0 | SELECT STATEMENT         |          | 79676 |   389K|    33   (7)| 00:00:01 |        |      |            |
|   1 |  PX COORDINATOR          |          |       |       |            |          |        |      |            |
|   2 |   PX SEND QC (RANDOM)    | :TQ10001 | 79676 |   389K|    33   (7)| 00:00:01 |  Q1,01 | P->S | QC (RAND)  |
|   3 |    HASH GROUP BY         |          | 79676 |   389K|    33   (7)| 00:00:01 |  Q1,01 | PCWP |            |
|   4 |     PX RECEIVE           |          | 79676 |   389K|    33   (7)| 00:00:01 |  Q1,01 | PCWP |            |
|   5 |      PX SEND HASH        | :TQ10000 | 79676 |   389K|    33   (7)| 00:00:01 |  Q1,00 | P->P | HASH       |
|   6 |       HASH GROUP BY      |          | 79676 |   389K|    33   (7)| 00:00:01 |  Q1,00 | PCWP |            |
|   7 |        PX BLOCK ITERATOR |          | 79676 |   389K|    31   (0)| 00:00:01 |  Q1,00 | PCWC |            |
|   8 |         TABLE ACCESS FULL| TPAL1    | 79676 |   389K|    31   (0)| 00:00:01 |  Q1,00 | PCWP |            |



2. 并行的效率要比非并行的快
-----------------------------------------------
create table tpal2 as select * from dba_objects;
非并行的append加载数据
insert /*+ append */ into tpal2 select * from dba_objects;

并行append加载数据：
explain plan for insert /*+ append */ into tpal2 select /*+parallel(tpal2,4) */ * from dba_objects;
select * from table(dbms_xplan.display);


3. 并行执行比串行要快，但是日志我没能打印出来！
---------------------------------------------
并行创建表
create table tpal3 parallel 4 as select * from dba_objects;
关行创建索引
create index tpal3_ind on tpal3(object_id) parallel 4;


4.并行和非并行，性能消耗差不多
---------------------------------------

create table tpal4 parallel 4 as select * from dba_objects;
ALTER SESSION ENABLE PARALLEL DML;

并行：explain plan for insert /*+ parallel(tpal4,4) */ into tpal2 select /*+parallel(tpal4,4) */ * from dba_objects;
select * from table(dbms_xplan.display);

| Id  | Operation                           | Name        | Rows  | Bytes | Cost (%CPU)| Time     |    TQ  |IN-OUT| PQ Distrib |
|   0 | INSERT STATEMENT                    |             | 68923 |    13M|   260   (3)| 00:00:04 |        |      |            |
|   1 |  PX COORDINATOR                     |             |       |       |            |          |        |      |            |
|   2 |   PX SEND QC (RANDOM)               | :TQ10001    | 68923 |    13M|   260   (3)| 00:00:04 |  Q1,01 | P->S | QC (RAND)  |
|   3 |    LOAD AS SELECT                   | TPAL2       |       |       |            |          |  Q1,01 | PCWP |            |
|   4 |     PX RECEIVE                      |             | 68923 |    13M|   260   (3)| 00:00:04 |  Q1,01 | PCWP |            |
|   5 |      PX SEND ROUND-ROBIN            | :TQ10000    | 68923 |    13M|   260   (3)| 00:00:04 |        | S->P | RND-ROBIN  |
|   6 |       VIEW                          | DBA_OBJECTS | 68923 |    13M|   260   (3)| 00:00:04 |        |      |            |
|   7 |        UNION-ALL                    |             |       |       |        |          |        |      |            |
|*  8 |         TABLE ACCESS BY INDEX ROWID | SUM$        |     1 |     9 |1   (0)| 00:00:01 |        |      |            |
|*  9 |          INDEX UNIQUE SCAN          | I_SUM$_1    |     1 |       |0   (0)| 00:00:01 |        |      |            |
|  10 |         TABLE ACCESS BY INDEX ROWID | OBJ$        |     1 |    30 |3   (0)| 00:00:01 |        |      |            |
|* 11 |          INDEX RANGE SCAN           | I_OBJ1      |     1 |       |2   (0)| 00:00:01 |        |      |            |
|* 12 |         FILTER                      |             |       |       |       |          |        |      |            |
|* 13 |          HASH JOIN                  |             | 73378 |  8742K|257 (3)| 00:00:04 |        |      |            |
|  14 |           TABLE ACCESS FULL         | USER$       |    93 |  1581 |3   (0)| 00:00:01 |        |      |            |
|* 15 |           HASH JOIN                 |             | 73378 |  7524K|   253   (2)| 00:00:04 |        |      |            |
|  16 |            INDEX FULL SCAN          | I_USER2     |    93 |  2046 |1   (0)| 00:00:01 |        |      |            |
|* 17 |            TABLE ACCESS FULL        | OBJ$        | 73378 |  5947K|   251   (2)| 00:00:04 |        |      |            |
|* 18 |          TABLE ACCESS BY INDEX ROWID| IND$        |     1 |     8 |2   (0)| 00:00:01 |        |      |            |
|* 19 |           INDEX UNIQUE SCAN         | I_IND1      |     1 |       |1   (0)| 00:00:01 |        |      |            |
|  20 |          NESTED LOOPS               |             |     1 |    29 |2   (0)| 00:00:01 |        |      |            |
|* 21 |           INDEX FULL SCAN           | I_USER2     |     1 |    20 |1   (0)| 00:00:01 |        |      |            |
|* 22 |           INDEX RANGE SCAN          | I_OBJ4      |     1 |     9 |1   (0)| 00:00:01 |        |      |            |
|  23 |         NESTED LOOPS                |             |     1 |   105 |3   (0)| 00:00:01 |        |      |            |
|  24 |          TABLE ACCESS FULL          | LINK$       |     1 |    88 |2   (0)| 00:00:01 |        |      |            |
|  25 |          TABLE ACCESS CLUSTER       | USER$       |     1 |    17 |1   (0)| 00:00:01 |        |      |            |
|* 26 |           INDEX UNIQUE SCAN         | I_USER#     |     1 |       |0   (0)| 00:00:01 |        |      |            |


非并行：explain plan for insert /*+ noparallel */ into tpal2 select /*+ noparallel */ * from dba_objects;
select * from table(dbms_xplan.display);

 
| Id  | Operation                       | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | INSERT STATEMENT                |             | 68923 |    13M|   260   (3)| 00:00:04 |
|   1 |  LOAD TABLE CONVENTIONAL        | TPAL2       |       |       |            |          |
|   2 |   VIEW                          | DBA_OBJECTS | 68923 |    13M|   260   (3)| 00:00:04 |
|   3 |    UNION-ALL                    |             |       |       |            |          |
|*  4 |     TABLE ACCESS BY INDEX ROWID | SUM$        |     1 |     9 |     1   (0)| 00:00:01 |
|*  5 |      INDEX UNIQUE SCAN          | I_SUM$_1    |     1 |       |     0   (0)| 00:00:01 |
|   6 |     TABLE ACCESS BY INDEX ROWID | OBJ$        |     1 |    30 |     3   (0)| 00:00:01 |
|*  7 |      INDEX RANGE SCAN           | I_OBJ1      |     1 |       |     2   (0)| 00:00:01 |
|*  8 |     FILTER                      |             |       |       |            |          |
|*  9 |      HASH JOIN                  |             | 73378 |  8742K|   257   (3)| 00:00:04 |
|  10 |       TABLE ACCESS FULL         | USER$       |    93 |  1581 |     3   (0)| 00:00:01 |
|* 11 |       HASH JOIN                 |             | 73378 |  7524K|   253   (2)| 00:00:04 |
|  12 |        INDEX FULL SCAN          | I_USER2     |    93 |  2046 |     1   (0)| 00:00:01 |
|* 13 |        TABLE ACCESS FULL        | OBJ$        | 73378 |  5947K|   251   (2)| 00:00:04 |
|* 14 |      TABLE ACCESS BY INDEX ROWID| IND$        |     1 |     8 |     2   (0)| 00:00:01 |
|* 15 |       INDEX UNIQUE SCAN         | I_IND1      |     1 |       |     1   (0)| 00:00:01 |
|  16 |      NESTED LOOPS               |             |     1 |    29 |     2   (0)| 00:00:01 |
|* 17 |       INDEX FULL SCAN           | I_USER2     |     1 |    20 |     1   (0)| 00:00:01 |
|* 18 |       INDEX RANGE SCAN          | I_OBJ4      |     1 |     9 |     1   (0)| 00:00:01 |
|  19 |     NESTED LOOPS                |             |     1 |   105 |     3   (0)| 00:00:01 |
|  20 |      TABLE ACCESS FULL          | LINK$       |     1 |    88 |     2   (0)| 00:00:01 |
|  21 |      TABLE ACCESS CLUSTER       | USER$       |     1 |    17 |     1   (0)| 00:00:01 |
|* 22 |       INDEX UNIQUE SCAN         | I_USER#     |     1 |       |     0   (0)| 00:00:01 |
 
