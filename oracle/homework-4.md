Oracle 第四周作业 - 张丹(15)
========================================================

阅读作业 阅读《让Oracle跑得更快2》第二篇 索引，最重要的是要弄清楚每种索引的使用场景以及它们的具体应用。


书面作业 
1.用示例说明B-Tree索引性能优于BitMap索引.
2.用示例说明BitMap索引性能优于B-Tree索引.
3.用示例说明全文索引的性能优势.
4.演示一个带有全文索引表的分区交换例子。


互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

--------------------------------
1，创建表t1，id1,id2是相同的两列，数据都是唯一的。在id1建立btree indxe, 在id2建立bitmap index.分别通过索引查询。
btree的结果要优于bitmap的结果

create table t1 as select object_id as id1,object_id as id2 from dba_objects;
create index t1_btree on t1(id1);
create bitmap index t1_bmap on t1(id2);

select * from t1 where id1=22;
------------------------------------------------------------
| Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT            |          |     1 |    26 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T1       |     1 |    26 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | T1_BTREE |     1 |       |     1   (0)| 00:00:01 |


统计信息
          0  recursive calls
          0  db block gets
          4  consistent gets
          0  physical reads
          0  redo size
        489  bytes sent via SQL*Net to client
        420  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
          1  rows processed


select /*+ index(t1 t1_bmap)*/* from t1 where id2=22;
------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT             |         |     1 |    26 |    32   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID | T1      |     1 |    26 |    32   (0)| 00:00:01 |
|   2 |   BITMAP CONVERSION TO ROWIDS|         |       |       |            |
|*  3 |    BITMAP INDEX SINGLE VALUE | T1_BMAP |       |       |            |

统计信息
          0  recursive calls
          0  db block gets
          4  consistent gets
          0  physical reads
          0  redo size
        489  bytes sent via SQL*Net to client
        420  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
          1  rows processed






-----------------------------------
2，创建表t2，id1,id2是相同的两列，数据重复率很高。在id1建立btree indxe, 在id2建立bitmap index.分别通过索引查询。
bitmap的结果要优于btree的结果

create table t2 as select mod(object_id,3) as id1,mod(object_id,3) as id2 from dba_objects;
create index t2_bree on t2(id1);
create bitmap index t2_bmap on t2(id2);

select /*+ index(t2 t2_btree)*/* from t2 where id1=2;
--------------------------------------------------

| Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT            |          | 27817 |   706K|   158   (0)| 00:00:02 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T2       | 27817 |   706K|   158   (0)| 00:00:02 |
|*  2 |   INDEX RANGE SCAN          | T2_BTREE | 27817 |       |    47   (0)| 00:00:01 |

统计信息
          0  recursive calls
          0  db block gets
       3368  consistent gets
          0  physical reads
          0  redo size
     475900  bytes sent via SQL*Net to client
      18140  bytes received via SQL*Net from client
       1613  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
      24178  rows processed


select * from t2 where id2=2;
--------------------------------

| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)|Time     |
|   0 | SELECT STATEMENT             |         | 27817 |   706K|    26   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID | T2      | 27817 |   706K|    26   (0)| 00:00:01 |
|   2 |   BITMAP CONVERSION TO ROWIDS|         |       |       |            |
|*  3 |    BITMAP INDEX SINGLE VALUE | T2_BMAP |       |       |            |

统计信息
          0  recursive calls
          0  db block gets
       1719  consistent gets
          0  physical reads
          0  redo size
     475900  bytes sent via SQL*Net to client
      18140  bytes received via SQL*Net from client
       1613  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
      24178  rows processed

-------------------------------------
3，创建表t3，name1,name2是相同的两列字符串。在name1建立btree indxe, 在name2建立text index.分别通过索引查询。
通过查询可以看出，text index是对文本内存进行了分词处理。


create table t3(name1 varchar(40),name2 varchar(40));
create index t3_btree on t3(name1);
create index t3_text on t3(name2) indextype is ctxsys.context

insert into t3 values('hello','hello');
insert into t3 values('hello 1','hello 1');
insert into t3 values('1 hello','1 hello');
insert into t3 values('1_hello','1_hello');
insert into t3 values('jifdaoid djkfk adk jfdajd adj fd  hello','jifdaoid djkfk adk jfdajd adj fd hello');
insert into t3 values('hello8lkda jdka da','hello8lkda jdka da');
insert into t3 values('hell3o','hell3o');
insert into t3 values('hello','hello');
insert into t3 values('hello','hello');



select * from t3 where name1 like '%hello%';
------------------------------------------------------------------------------
| Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT            |          |     8 |   352 |     0   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T3       |     8 |   352 |     0   (0)| 00:00:01 |
|*  2 |   INDEX FULL SCAN           | T3_BTREE |     1 |       |     0   (0)| 00:00:01 |

统计信息
          0  recursive calls
          0  db block gets
          4  consistent gets
          0  physical reads
          0  redo size
        757  bytes sent via SQL*Net to client
        419  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
          8  rows processed




alter index t3_text rebuild parameters('sync');
select * from t3 where contains(name2,'hello')>0;
--------------------------------------------------------------------------------
| Id  | Operation                   | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
|   0 | SELECT STATEMENT            |         |     1 |    56 |     4   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T3      |     1 |    56 |     4   (0)| 00:00:01 |
|*  2 |   DOMAIN INDEX              | T3_TEXT |       |       |     4   (0)| 00:00:01 |

统计信息
         11  recursive calls
          0  db block gets
         24  consistent gets
          0  physical reads
          0  redo size
        714  bytes sent via SQL*Net to client
        419  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
          7  rows processed


select token_text ,token_last,token_count from DR$T3_TEXT$I;
------------------------------------------------------
1  4	3
ADJ	5	1
ADK	5	1
DA	6	1
DJKFK	5	1
FD	5	1
HELL3O	7	1
HELLO	9	7
HELLO8LKDA	6	1
JDKA	6	1
JFDAJD	5	1
JIFDAOID	5	1

--------------------------------------
4，
1)创建分区表t4，和分区索引t4_text
---------------------------------------
create table t4(
s_name VARCHAR2(40),
s_date DATE)
PARTITION BY RANGE(s_date)
(
PARTITION sales_2012 VALUES LESS THAN(TO_DATE('01/01/2012','DD/MM/YYYY')),
PARTITION sales_2013 VALUES LESS THAN(TO_DATE('01/01/2013','DD/MM/YYYY')),
PARTITION sales_2014 VALUES LESS THAN(TO_DATE('01/01/2014','DD/MM/YYYY'))
);
create index t4_text on t4(s_name) indextype is ctxsys.context local;

2)创建临时表tmp4，和临时表的索引tmp4_text
------------------------------------------
create table tmp4(
s_name VARCHAR2(40),
s_date DATE)
create index tmp4_text on tmp4(s_name) indextype is ctxsys.context

3)向临时表加载数据
---------------------------
insert into tmp4 values('hello',sysdate);
insert into tmp4 values('hello 1',sysdate);
insert into tmp4 values('1 hello',sysdate);
insert into tmp4 values('1_hello',sysdate);
insert into tmp4 values('jifdaoid djkfk adk jfdajd adj fd  hello',sysdate);
insert into tmp4 values('hello8lkda jdka da',sysdate);
insert into tmp4 values('hell3o',sysdate);
insert into tmp4 values('hello',sysdate);
insert into tmp4 values('hello',sysdate);
alter index tmp4_text rebuild parameters('sync');
select * from tmp4 where contains(s_name,'hello')>0;

4）分区交换
-----------------------
alter table t4 exchange partition sales_2013 with table tmp4 including indexes without validation;

5）执行text index查询
----------------------------
select * from t4 where contains(s_name,'hello')>0;

hello     29-7月 -12
hello 1	  29-7月 -12
1 hello	  29-7月 -12
1_hello	  29-7月 -12
jifdaoid djkfk adk jfdajd adj fd  hello	29-7月 -12
hello	    29-7月 -12
hello	    29-7月 -12






