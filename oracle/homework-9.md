Oracle 第九周作业 - 张丹(15)
========================================================

阅读作业 《让Oracle跑得更快1》第7章 分析与动态采样。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.示例说明，过旧的分析数据，可能导致错误的执行计划。 
2.示例说明动态采样的作用，并演示动态采样对有内在关系的多列查询的影响。
3.示例说明直方图的作用。
4.比较dbms_stats.gather_table_stats中 granularity设置为golal和partition对执行计划的影响。

互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

## 1. 创建表t9_1
drop table t9_1 purge;
create table t9_1 as select object_id as id , object_name as name from dba_objects;
create index ind_t9_1 on t9_1(id);

### 查看执行计划
select * from t9_1 where id=100;

    ----------------------------------------------------------------------------------------
    | Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ----------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT            |          |     1 |    79 |     2   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T9_1     |     1 |    79 |     2   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | IND_T9_1 |     1 |       |     1   (0)| 00:00:01 |
    ----------------------------------------------------------------------------------------



### 分析表t9_1
exec dbms_stats.GATHER_TABLE_STATS(user,'t9_1');

### 更新表t9_1数据
update t9_1 set id=100 where id>500;commit;

    ---------------------------------------------------------------------------
    | Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    ---------------------------------------------------------------------------
    |   0 | UPDATE STATEMENT   |      | 72188 |   352K|    96   (2)| 00:00:02 |
    |   1 |  UPDATE            | T9_1 |       |       |            |          |
    |*  2 |   TABLE ACCESS FULL| T9_1 | 72188 |   352K|    96   (2)| 00:00:02 |
    ---------------------------------------------------------------------------

# 查看执行计划 , 过旧的分析数据导致错误的执行计划
select count(*) from t9_1 where id=100;

    ------------------------------------------------------------------------------
    | Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |          |     1 |     5 |     1   (0)| 00:00:01 |
    |   1 |  SORT AGGREGATE   |          |     1 |     5 |            |          |
    |*  2 |   INDEX RANGE SCAN| IND_T9_1 |     1 |     5 |     1   (0)| 00:00:01 |
    ------------------------------------------------------------------------------


### 分析表t9_1
exec dbms_stats.GATHER_TABLE_STATS(user,'t9_1');

### 查看执行计划，更新后，执行计划正常。
select count(*) from t9_1 where id=100;

    ----------------------------------------------------------------------------------
    | Id  | Operation             | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ----------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT      |          |     1 |     4 |    70   (2)| 00:00:01 |
    |   1 |  SORT AGGREGATE       |          |     1 |     4 |            |          |
    |*  2 |   INDEX FAST FULL SCAN| IND_T9_1 | 72097 |   281K|    70   (2)| 00:00:01 |
    ----------------------------------------------------------------------------------


## 2.动态采样的作用 

1. CBO 依赖的是充分的统计分析信息，但是并不是每个用户都会非常认真，及时地去对每个表做分析。
为了保证执行计划都尽可能地正确，Oracle需要使用动态采样技术来帮助CBO 获取尽可能多的信息。
    
2. 全局临时表。通常来讲，临时表的数据是不做分析的，因为它存放的数据是临时性的，可能很快就释放了，
但是当一个查询关联到这样的临时表时，CBO要想获得临时表上的统计信息分析数据，就只能依赖于动态采样了。
    
3. 动态采样除了可以在段对象没有分析时，给CBO提供分析数据之外，还有一个独特的能力，它可以对不同列之间的相关性做统计。
这点通常发生在表设计不符合3NF的情况下，这个特性在表符合3NF设计的情况下少见。

### 如下例子：采用动态采样，会会相关性的列的统计。使执行计划准确。

create table t9_2 as 
  select object_id as id , 
    decode( mod(rownum,2), 0, 'N', 'Y' ) flag1, 
    decode( mod(rownum,2), 0, 'Y', 'N' ) flag2
  from dba_objects;
create index ind_t9_2 on t9_2(flag1,flag2);

exec dbms_stats.gather_table_stats( user, 't9_2',method_opt=>'for all indexed columns size 254' );

select * from t9_2 where flag1='N' and flag2='N';

    --------------------------------------------------------------------------
    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    --------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |      | 18168 |   159K|    41   (3)| 00:00:01 |
    |*  1 |  TABLE ACCESS FULL| T9_2 | 18168 |   159K|    41   (3)| 00:00:01 |
    --------------------------------------------------------------------------

select /*+ dynamic_sampling(t9_2 3) */ * from t9_2 where flag1='N' and flag2='N';

    ----------------------------------------------------------------------------------------
    | Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ----------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT            |          |     1 |     9 |     2   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T9_2     |     1 |     9 |     2   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | IND_T9_2 |     1 |       |     1   (0)| 00:00:01 |
    ----------------------------------------------------------------------------------------
    
    Predicate Information (identified by operation id):
    ---------------------------------------------------
       2 - access("FLAG1"='N' AND "FLAG2"='N')
    
    Note
    -----
       - dynamic sampling used for this statement (level=2)


## 3. 直方图是帮助CBO进行数据分布情况分析的。

create table t9_3 as select 1 as id , object_name as name from dba_objects;
update t9_3 set id=99 where rownum=1;

create index ind_t9_3 on t9_3(id);
exec dbms_stats.gather_table_stats(user,'t9_3',cascade=>true);
select table_Name,column_name,endpoint_number,endpoint_value from user_histograms where table_name='T9_3';

    TABLE_NAME COLUMN_NAME ENDPOINT_NUMBER ENDPONT_VALUE
    ---------- ----------- --------------- -------------
    T9_3        ID	         0	             1
    T9_3	      NAME	       0	             245035608287067000000000000000000000
    T9_3	      ID	         1	             99
    T9_3	      NAME	       1	             629634626559793000000000000000000000

### 使用直方图的时，结果正常!!
select id,count(id) from t9_3 group by id;

            ID  COUNT(ID)
    ---------- ----------
             1      72672
            99          1

select * from t9_3 where id=99;
    
    --------------------------------------------------------------------------
    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    --------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |      | 36337 |   958K|    91   (2)| 00:00:02 |
    |*  1 |  TABLE ACCESS FULL| T9_3 | 36337 |   958K|    91   (2)| 00:00:02 |
    --------------------------------------------------------------------------

select * from t9_3 where id=1;

    --------------------------------------------------------------------------
    | Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
    --------------------------------------------------------------------------
    |   0 | SELECT STATEMENT  |      | 36337 |   958K|    91   (2)| 00:00:02 |
    |*  1 |  TABLE ACCESS FULL| T9_3 | 36337 |   958K|    91   (2)| 00:00:02 |
    --------------------------------------------------------------------------


### 删除直方图的时,结果不正常了！CBO不能进行正常的判断！
exec dbms_stats.delete_column_stats(user,'T9_3','id');
select num_rows,avg_row_len,blocks,last_analyzed from user_tables where table_name='T9_3';
select blevel,leaf_blocks,distinct_keys,last_analyzed from user_indexes where table_name='T9_3';

select id,count(id) from t9_3 group by id;

            ID  COUNT(ID)
    ---------- ----------
             1      72672
            99          1

select * from t9_3 where id=99;


    ----------------------------------------------------------------------------------------
    | Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ----------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT            |          |   727 | 19629 |    73   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T9_3     |   727 | 19629 |    73   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | IND_T9_3 |   291 |       |    71   (0)| 00:00:01 |
    ----------------------------------------------------------------------------------------

select * from t9_3 where id=1;

    ----------------------------------------------------------------------------------------
    | Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
    ----------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT            |          |   727 | 19629 |    73   (0)| 00:00:01 |
    |   1 |  TABLE ACCESS BY INDEX ROWID| T9_3     |   727 | 19629 |    73   (0)| 00:00:01 |
    |*  2 |   INDEX RANGE SCAN          | IND_T9_3 |   291 |       |    71   (0)| 00:00:01 |
    ----------------------------------------------------------------------------------------



## 4. 创建分区表和分区索引
create table t9_4 (id int,name varchar2(20))
PARTITION BY RANGE(id)
(
PARTITION id_1 VALUES LESS THAN(10),
PARTITION id_2 VALUES LESS THAN(20),
PARTITION id_3 VALUES LESS THAN(30)
);

insert into t9_4 values(1,'abc');
insert into t9_4 values(11,'abc');
insert into t9_4 values(21,'abc');
create index ind_t9_4 on t9_4(id) local;

exec dbms_stats.gather_table_stats(user,'T9_4',cascade=>true);

SQL> select num_rows,avg_row_len,last_analyzed from user_tables where table_name='T9_4';
    
      NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ---------- ----------- --------------
             3           7 27-8月 -12

SQL> select partition_name,num_rows,avg_row_len,last_analyzed from user_tab_partitions where table_name='T9_4';

    PARTITION_NAME                                                 NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ------------------------------------------------------------ ---------- ----------- --------------
    ID_1                                                                  1           7 27-8月 -12
    ID_2                                                                  1           7 27-8月 -12
    ID_3                                                                  1           7 27-8月 -12

SQL> select BLevel,leaf_blocks,last_analyzed from user_indexes where index_name='IND_T9_4';

        BLEVEL LEAF_BLOCKS LAST_ANALYZED
    ---------- ----------- --------------
             0           3 27-8月 -12

SQL> select partition_name,BLevel,leaf_blocks,last_analyzed from user_ind_partitions where index_name='IND_T9_4';

    PARTITION_NAME                                                   BLEVEL LEAF_BLOCKS LAST_ANALYZED
    ------------------------------------------------------------ ---------- ----------- --------------
    ID_1                                                                  0           1 27-8月 -12
    ID_2                                                                  0           1 27-8月 -12
    ID_3                                                                  0           1 27-8月 -12


### 增加表分区，做数据不均匀分布
alter table t9_4 add PARTITION id_other VALUES LESS THAN(maxvalue);
insert into t9_4 values(31,'abc');
insert into t9_4  select 100 as id , substr(object_name,0,20) as name from dba_objects;

SQL> select count(*) from t9_4;
    
      COUNT(*)
    ----------
         72688

SQL> select * from t9_4 partition(id_1);

            ID NAME
    ---------- ----------------------------------------
             1 abc

SQL> select * from t9_4 partition(id_2);

            ID NAME
    ---------- ----------------------------------------
            11 abc

SQL> select * from t9_4 partition(id_3);

            ID NAME
    ---------- ----------------------------------------
            21 abc

SQL> select id,count(*) from t9_4 partition(id_other) group by id;

            ID   COUNT(*)
    ---------- ----------
           100      72684
            31          1

SQL> select partition_name, num_rows,avg_row_len,last_analyzed from user_tab_partitions where table_name='T9_4';

    PARTITION_NAME                                                 NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ------------------------------------------------------------ ---------- ----------- --------------
    ID_1                                                                  1           7 27-8月 -12
    ID_2                                                                  1           7 27-8月 -12
    ID_3                                                                  1           7 27-8月 -12
    ID_OTHER

SQL> select num_rows,avg_row_len,last_analyzed from user_tables where table_name='T9_4';

      NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ---------- ----------- --------------
             3           7 27-8月 -12

### 分析执行计划，id=100
select * from t9_4 where id=100;

    -----------------------------------------------------------------------------------------------
    | Id  | Operation              | Name | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
    -----------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT       |      |     1 |     7 |     2   (0)| 00:00:01 |       |       |
    |   1 |  PARTITION RANGE SINGLE|      |     1 |     7 |     2   (0)| 00:00:01 |     4 |     4 |
    |*  2 |   TABLE ACCESS FULL    | T9_4 |     1 |     7 |     2   (0)| 00:00:01 |     4 |     4 |
    -----------------------------------------------------------------------------------------------

### 设置granularity=>'partition'
exec dbms_stats.gather_table_stats(user,'t9_4',partname=>'id_other',granularity=>'partition');
SQL> select partition_name, num_rows,avg_row_len,last_analyzed from user_tab_partitions where table_name='T9_4';

    PARTITION_NAME                                                 NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ------------------------------------------------------------ ---------- ----------- --------------
    ID_1                                                                  1           7 27-8月 -12
    ID_2                                                                  1           7 27-8月 -12
    ID_3                                                                  1           7 27-8月 -12
    ID_OTHER                                                          72685          23 27-8月 -12

SQL> select num_rows,avg_row_len,last_analyzed from user_tables where table_name='T9_4';

      NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ---------- ----------- --------------
             3           7 27-8月 -12

### 分析执行计划，id=100
select * from t9_4 where id=100;

    -----------------------------------------------------------------------------------------------
    | Id  | Operation              | Name | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
    -----------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT       |      | 72678 |  1632K|    78   (2)| 00:00:01 |       |       |
    |   1 |  PARTITION RANGE SINGLE|      | 72678 |  1632K|    78   (2)| 00:00:01 |     4 |     4 |
    |*  2 |   TABLE ACCESS FULL    | T9_4 | 72678 |  1632K|    78   (2)| 00:00:01 |     4 |     4 |
    -----------------------------------------------------------------------------------------------

### 设置granularity=>'GLOBAL'
exec dbms_stats.gather_table_stats(user,'T9_4',granularity=>'GLOBAL');
SQL> select partition_name, num_rows,avg_row_len,last_analyzed from user_tab_partitions where table_name='T9_4';

    PARTITION_NAME                                                 NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ------------------------------------------------------------ ---------- ----------- --------------
    ID_1                                                                  1           7 27-8月 -12
    ID_2                                                                  1           7 27-8月 -12
    ID_3                                                                  1           7 27-8月 -12
    ID_OTHER

SQL> select num_rows,avg_row_len,last_analyzed from user_tables where table_name='T9_4';

      NUM_ROWS AVG_ROW_LEN LAST_ANALYZED
    ---------- ----------- --------------
         72688          23 27-8月 -12

### 分析执行计划，id=100
select * from t9_4 where id=100;

    -----------------------------------------------------------------------------------------------
    | Id  | Operation              | Name | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
    -----------------------------------------------------------------------------------------------
    |   0 | SELECT STATEMENT       |      | 14538 |   326K|    21   (0)| 00:00:01 |       |       |
    |   1 |  PARTITION RANGE SINGLE|      | 14538 |   326K|    21   (0)| 00:00:01 |     4 |     4 |
    |*  2 |   TABLE ACCESS FULL    | T9_4 | 14538 |   326K|    21   (0)| 00:00:01 |     4 |     4 |
    -----------------------------------------------------------------------------------------------

1. 看一下新进来的数据的量在全表中所占的比例如何，如果所占比例不是很大，那就可以考虑不做全局分析，
否则，就要考虑，依据是业务的实际运行情况。
2. 采样比例。如果载入的数据量非常大，比如上千万或者更大，就要把采样比例压缩的尽可能的小，
但底线是但不能影响CBO 做出正确的执行计划；采样比例的上限是
不能消耗太多的资源而影响到业务的正常运行。
3. 新加载的数据应该要做分区级的数据分析。至于是否需要直方图分析，以及设置多少个的BUCKETS（size 参数指定），
需要DBA 依据数据的分布情况开考虑，关键是看数据的倾斜程度而定。




