Oracle 第七周作业 - 张丹(15)
========================================================

阅读作业 阅读《让Oracle跑得更快1》变量绑定,性能视图和性能报告部分。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.通过awr或者v$....advice动态视图评估你的数据库当前的SGA_target,pga_aggregate_target是否设置合理,写出分析过程和理由。
2.模拟一个绑定变量环境，分别设置cursor_sharing的值为exact,similar和force，比较对绑定变量后的SQL执行计划的影响情况。
3.你认为OLAP系统是否适合使用邦定变量?给出充分的理由. 
4.分别写出适合优化器模式为all_rows和first_rows(n)的场景相应的SQL语句，并比较同样的SQL分别使用这两种优化器模式的性能情况。
5.设置DB_FILE_MULTIBLOCK_READ_COUNT为不同的值，观察SQL的性能变化，写出几种类型的SQL会从这个参数中受益。

互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

-----------------------------------------------------------------------------

1. 我的本机Oracle装在windowXP，所有配置都是默认，只是做作业才会使用。使用v$sga_target_advice和select * from v$pga_target_advice的建议器。
-----------------------------------------------------------------------------

SGA的视图发现，736MB为Oracle共享内存，与552MB的所有性能指标都是一样的，我应该设置为552MB更为合理，这样就有更多的内存可以干点别的事情了。

SQL> select * from v$sga_target_advice;

    SGA_SIZE SGA_SIZE_FACTOR ESTD_DB_TIME ESTD_DB_TIME_FACTOR ESTD_PHYSICAL_READS
       184             .25         1079              2.4702               44152
       368              .5          476              1.0883               22673
       552             .75          437                   1               21347
       736               1          437                   1               21347
       920            1.25          437                   1               21347
      1104             1.5          437                   1               21347
      1288            1.75          437                   1               21347
      1472               2          437                   1               21347

PGA的视图发现，现在496MB的设置，并不是合适的，因为62MB,124MB,248MB，372MB的性能指标，都与496是一样的，因为我可以设置少一点的PGA内存，省出更多的内存！

SQL> select PGA_TARGET_FOR_ESTIMATE/1024/1024 as MB,PGA_TARGET_FACTOR,ADVICE_STATUS,BYTES_PROCESSED,ESTD_TIME,ESTD_EXTRA_BYTES_RW,ESTD_PGA_CACHE_HIT_PERCENTAGE,ESTD_OVERALLOC_COUNT from v$pga_target_advice;

        MB PGA_TARGET_FACTOR ADVICE BYTES_PROCESSED  ESTD_TIME ESTD_EXTRA_BYTES_RW ESTD_PGA_CACHE_HIT_PERCENTAGE ESTD_OVERALLOC_COUNT
        62              .125 ON           648897536        927                  0                           100                    0
       124               .25 ON           648897536        927                  0                           100                    0
       248                .5 ON           648897536        927                  0                           100                    0
       372               .75 ON           648897536        927                  0                           100                    0
       496                 1 ON           648897536        927                  0                           100                    0
       595               1.2 ON           648897536        927                  0                           100                    0
       694               1.4 ON           648897536        927                  0                           100                    0
       793               1.6 ON           648897536        927                  0                           100                    0
       892               1.8 ON           648897536        927                  0                           100                    0
       992                 2 ON           648897536        927                  0                           100                    0
      1488                 3 ON           648897536        927                  0                           100                    0
      1984                 4 ON           648897536        927                  0                           100                    0
      2976                 6 ON           648897536        927                  0                           100                    0
      3968                 8 ON           648897536        927                  0                           100                    0


2. 默认情况下cursor_sharing是EXACT的。
-----------------------------------------------------------------------------

create table t7 as select 99 id, a.* from dba_objects a;
create index t7_ind on t7(id);
ID是索引列，并且只有一个值。

cursor_sharing=EXACT的情况：
-----------------------------------------------------------------------------

SQL> show parameter cursor_sharing

          NAME                TYPE           VALUE
    cursor_sharing          string           EXACT

select * from t7 set_exact where id=2;
select * from t7 set_exact where id=7;

SQL> select sql_text from v$sql where sql_text like '%set_exact%';

     SQL_TEXT
     select * from t7 set_exact where id=7
     select * from t7 set_exact where id=2

查询v$sql.sql_text出现了两条记录，因此没有对谓词进行解析。


SQL> variable x number;
SQL> exec :x:=100
SQL> select * from t7 set_exact where id=:x;
SQL> exec :x:=101;
SQL> select * from t7 set_exact where id=:x;
SQL> select sql_text from v$sql where sql_text like '%set_exact%';

     SQL_TEXT
     select * from t7 set_exact where id=7
     select * from t7 set_exact where id=:x
     select * from t7 set_exact where id=2

查询v$sql.sql_text出现了三条记录，通过绑定变量:x，Oracle合并查询，第二次进行了软解析。


cursor_sharing=SIMILAR的情况：
-----------------------------------------------------------------------------
SQL>alter session set cursor_sharing=similar;
SQL> show parameter cursor_sharing

          NAME                TYPE           VALUE
    cursor_sharing          string           SIMILAR

SQL> select * from t7 set_exact where id=20;
SQL> select * from t7 set_exact where id=21;
SQL> select sql_text from v$sql where sql_text like '%set_exact%';

    SQL_TEXT
    select * from t7 set_exact where id=:"SYS_B_0"
    select * from t7 set_exact where id=:"SYS_B_0"



通过绑定变量后，所有查询会共享SQL。

SQL> select 3 from t7 set_exact where id=:x and OWNER='bsspirit';
SQL> select 5 from t7 set_exact where id=:x and OWNER='bsspirit';
SQL> select sql_text from v$sql where sql_text like '%set_exact%';

    SQL_TEXT
    select :"SYS_B_0" from t7 set_exact where id=:x and OWNER=:"SYS_B_1"



cursor_sharing=FORCE的情况：
-----------------------------------------------------------------------------
SQL> alter session set cursor_sharing=force;
SQL> show parameter cursor_sharing;

          NAME                TYPE           VALUE
------------------ --------------- ---------------
    cursor_sharing          string           FORCE

SQL> select * from t7 set_exact where id=30;
SQL> select * from t7 set_exact where id=31;
SQL> select sql_text from v$sql where sql_text like '%set_exact%';

    SQL_TEXT
    select * from t7 set_exact where id=7
    select * from t7 set_exact where id=:x
    select * from t7 set_exact where id=:"SYS_B_0"
    select * from t7 set_exact where id=:"SYS_B_0"
    select * from t7 set_exact where id=:"SYS_B_0"
    select * from t7 set_exact where id=2

通过绑定变量后，所有查询会共享SQL。

SQL> select 1 from t7 set_exact where id=:x;
SQL> select 2 from t7 set_exact where id=:x;
SQL> select 3 from t7 set_exact where id=:x;
SQL> select sql_text from v$sql where sql_text like '%set_exact%';

    SQL_TEXT
    select :"SYS_B_0" from t7 set_exact where id=:x



3. 我认为OLAP系统不适合用绑定变量！！
-----------------------------------------------------------------------------
首先OLAP是大数据量，主要用于数据查询，因此查询性能决定了，OLAP的性能。
绑定变量，是把硬解析的SQL变成软解析的SQL。对于一条新SQL会执行下面4步(语法分析，语义分析，生成执行计划，SQL执行)。

由于Oracle会根据绑定变量，选择是否共享SQL。由于通常的OLAP都有大量的聚合查询操作(Group by)，有时候不走索引会更好。
因此，绑定变量有时候有可能会选择错误的执行计划，使得查询非常慢，这种效率的查询会远大于硬解析的耗时，SQL解析消耗的资源就显得微不足道了。


4. 对表进行优化器比较。三种情况(默认,all_rows,first_rows)
-----------------------------------------------------------------------------
create table t7 as select 99 id, a.* from dba_objects a;
create index t7_ind on t7(id);
索引列数据只有一个值为99。

由于id没有1，因此使用索引是最好的。通过索引查询三种情况的结果是一样的。
-----------------------------------------------------------------------------
select * from t7 where id=1;
select /*+ all_rows */ * from t7 where id=1;
select /*+ first_rows(10) */ * from t7 where id=1;


SQL> select * from t7 where id=1;

    | Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT            |        |     1 |   220 |     1   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T7     |     1 |   220 |     1   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | T7_IND |     1 |       |     1   (0)| 00:00:01 |

SQL> select /*+ all_rows */ * from t7 where id=1;

    | Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT            |        |     1 |   220 |     1   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T7     |     1 |   220 |     1   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | T7_IND |     1 |       |     1   (0)| 00:00:01 |

SQL> select /*+ first_rows(10) */ * from t7 where id=1;

    | Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT            |        |     1 |   220 |     1   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T7     |     1 |   220 |     1   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | T7_IND |     1 |       |     1   (0)| 00:00:01 |


由于id值是99，因此不使用索引是，使用全表扫描是最好的。通过比较可以看出,all_rows选择全表扫描对全局结果是最优的，而first_row(10)只取前10个值，因此通过索引是最好的。
-----------------------------------------------------------------------------

select * from t7 where id=99;
select /*+ all_rows */ * from t7 where id=99;
select /*+ first_rows(10) */ * from t7 where id=99;

SQL> select * from t7 where id=99;

    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT  |      | 78523 |    16M|   403   (1)| 00:00:05 |
    |*  1 |  TABLE ACCESS FULL| T7   | 78523 |    16M|   403   (1)| 00:00:05 |

SQL> select /*+ all_rows */ * from t7 where id=99;

    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT  |      | 78523 |    16M|   403   (1)| 00:00:05 |
    |*  1 |  TABLE ACCESS FULL| T7   | 78523 |    16M|   403   (1)| 00:00:05 |

SQL> select /*+ first_rows(10) */ * from t7 where id=99;

    | Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT            |        | 78523 |    16M|     2   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T7     | 78523 |    16M|     2   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | T7_IND |       |       |     1   (0)| 00:00:01 |




5. 分别设置db_file_multiblock_read_count为4,64,1024三种情况。CBO计算出的FTS成本分别是51,25,24。
-----------------------------------------------------------------------------
create table t7_4(x int, y int);
insert into t7_4 values(1,1);
insert into t7_4 values(2,1);
alter table t7_4 minimize records_per_block;
insert into t7_4 select rownum+2,1 from all_objects where rownum <= 254;
create index t7_4_ind on t7_4(x);
exec dbms_stats.gather_table_stats(user,'t7_4');

表占用数据块为128个
select count(distinct dbms_rowid.rowid_block_number(rowid)) as count from t7_4;

     COUNT
----------
       128


SQL> alter session set db_file_multiblock_read_count=4;
SQL> select * from t7_4;

    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT  |      |   256 |  1792 |    51   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS FULL| T7_4 |   256 |  1792 |    51   (0)| 00:00:01 |


SQL> alter session set db_file_multiblock_read_count=64;
SQL> select * from t7_4;

    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT  |      |   256 |  1792 |    25   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS FULL| T7_4 |   256 |  1792 |    25   (0)| 00:00:01 |


SQL> alter session set db_file_multiblock_read_count=1024;
SQL> select * from t7_4;

    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    |   0 | SELECT STATEMENT  |      |   256 |  1792 |    24   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS FULL| T7_4 |   256 |  1792 |    24   (0)| 00:00:01 |


会受益的SQL:扫描大量数据的SQL都会受益。
-----------------------------------------------------------------------------
select * from t7_4 where x>1;
select * from t7_4;
select * from t7_4 where y>0;


