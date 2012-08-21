Oracle 第六周作业 - 张丹(15)
========================================================

阅读作业 阅读《让Oracle跑得更快2》第8章-数据压缩。

以下题目都需要数据库的实际操作输出，而不是单纯语言论述：
1.演示表和索引在数据压缩前后空间占用情况的对比,注意观察压缩列在重复率高,低时这种差异的大小
2.演示数据压缩前后,对表进行查询时,CPU,扫描的数据块,执行时间的对比,注意观察压缩列在重复率高,低时这种差异的大小
3.演示数据压缩对DML操作的影响。
4.考虑数据压缩在海量数据环境下,对于表分区的意义并提供示例。


互动作业 

请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。

-----------------------------------------------------

1.当重复率低时，表和索引的压缩比较：
-----------------------------------------------------
create table t6_uncompression as select object_id,object_name from dba_objects;
create table t6_compression compress as select object_id,object_name from dba_objects;

create index t6_uncom on t6_uncompression(object_id) ;
create index t6_com on t6_compression(object_id)  compress;

select table_name,compression from user_tables where table_name like 'T6%';

T6_COMPRESSION  ENABLED
T6_UNCOMPRESSION	DISABLED

表压缩比较：压缩比未压缩少了一个块
压缩情况：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_COMPRESSION');
-----------------------------------------------------
T6_COMPRESSION  0	65536
T6_COMPRESSION	1	65536
T6_COMPRESSION	2	65536
T6_COMPRESSION	3	65536
T6_COMPRESSION	4	65536
T6_COMPRESSION	5	65536
T6_COMPRESSION	6	65536
T6_COMPRESSION	7	65536
T6_COMPRESSION	8	65536
T6_COMPRESSION	9	65536
T6_COMPRESSION	10	65536
T6_COMPRESSION	11	65536
T6_COMPRESSION	12	65536
T6_COMPRESSION	13	65536
T6_COMPRESSION	14	65536
T6_COMPRESSION	15	65536
T6_COMPRESSION	16	1048576


未压缩情况：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_UNCOMPRESSION');
-----------------------------------------------------
T6_UNCOMPRESSION  0	65536
T6_UNCOMPRESSION	1	65536
T6_UNCOMPRESSION	2	65536
T6_UNCOMPRESSION	3	65536
T6_UNCOMPRESSION	4	65536
T6_UNCOMPRESSION	5	65536
T6_UNCOMPRESSION	6	65536
T6_UNCOMPRESSION	7	65536
T6_UNCOMPRESSION	8	65536
T6_UNCOMPRESSION	9	65536
T6_UNCOMPRESSION	10	65536
T6_UNCOMPRESSION	11	65536
T6_UNCOMPRESSION	12	65536
T6_UNCOMPRESSION	13	65536
T6_UNCOMPRESSION	14	65536
T6_UNCOMPRESSION	15	65536
T6_UNCOMPRESSION	16	1048576
T6_UNCOMPRESSION	17	1048576


索引压缩比较：占用空间几乎相同
压缩情况：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_COM');
-----------------------------------------------------
T6_COM  0	65536
T6_COM	1	65536
T6_COM	2	65536
T6_COM	3	65536
T6_COM	4	65536
T6_COM	5	65536
T6_COM	6	65536
T6_COM	7	65536
T6_COM	8	65536
T6_COM	9	65536
T6_COM	10	65536
T6_COM	11	65536
T6_COM	12	65536
T6_COM	13	65536
T6_COM	14	65536
T6_COM	15	65536
T6_COM	16	1048576

未压缩情况：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_UNCOM');
-----------------------------------------------------
T6_UNCOM  0	65536
T6_UNCOM	1	65536
T6_UNCOM	2	65536
T6_UNCOM	3	65536
T6_UNCOM	4	65536
T6_UNCOM	5	65536
T6_UNCOM	6	65536
T6_UNCOM	7	65536
T6_UNCOM	8	65536
T6_UNCOM	9	65536
T6_UNCOM	10	65536
T6_UNCOM	11	65536
T6_UNCOM	12	65536
T6_UNCOM	13	65536
T6_UNCOM	14	65536
T6_UNCOM	15	65536
T6_UNCOM	16	1048576


当重复率高时，表和索引的压缩比较：
-----------------------------------------------------
create table t6_uncompression2 as select object_id,'aaa' object_name from dba_objects;
create table t6_compression2 compress as select object_id,'aaa' object_name from dba_objects;

create index t6_uncom2 on t6_uncompression2(object_name) ;
create index t6_com2 on t6_compression2(object_name)  compress;

select table_name,index_name,compression from user_indexes where index_name like 'T6_%';

T6_UNCOMPRESSION2  T6_UNCOM2	DISABLED
T6_COMPRESSION2	T6_COM2	ENABLED

表压缩比较：压缩表比未压缩表少了3个块，比较明显！！
压缩表：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_COMPRESSION2');
-----------------------------------------------------
T6_COMPRESSION2  0	65536
T6_COMPRESSION2	1	65536
T6_COMPRESSION2	2	65536
T6_COMPRESSION2	3	65536
T6_COMPRESSION2	4	65536
T6_COMPRESSION2	5	65536
T6_COMPRESSION2	6	65536
T6_COMPRESSION2	7	65536
T6_COMPRESSION2	8	65536
T6_COMPRESSION2	9	65536
T6_COMPRESSION2	10	65536
T6_COMPRESSION2	11	65536
T6_COMPRESSION2	12	65536
T6_COMPRESSION2	13	65536


未压缩表：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_UNCOMPRESSION2');
-----------------------------------------------------
T6_UNCOMPRESSION2  0	65536
T6_UNCOMPRESSION2	1	65536
T6_UNCOMPRESSION2	2	65536
T6_UNCOMPRESSION2	3	65536
T6_UNCOMPRESSION2	4	65536
T6_UNCOMPRESSION2	5	65536
T6_UNCOMPRESSION2	6	65536
T6_UNCOMPRESSION2	7	65536
T6_UNCOMPRESSION2	8	65536
T6_UNCOMPRESSION2	9	65536
T6_UNCOMPRESSION2	10	65536
T6_UNCOMPRESSION2	11	65536
T6_UNCOMPRESSION2	12	65536
T6_UNCOMPRESSION2	13	65536
T6_UNCOMPRESSION2	14	65536
T6_UNCOMPRESSION2	15	65536
T6_UNCOMPRESSION2	16	1048576


索引压缩比较：压缩的索引比未压缩的索引少了两个块，效果明显。
压缩索引：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_COMPRESSION2');
-----------------------------------------------------
T6_COM2  0	65536
T6_COM2	1	65536
T6_COM2	2	65536
T6_COM2	3	65536
T6_COM2	4	65536
T6_COM2	5	65536
T6_COM2	6	65536
T6_COM2	7	65536
T6_COM2	8	65536
T6_COM2	9	65536
T6_COM2	10	65536
T6_COM2	11	65536
T6_COM2	12	65536
T6_COM2	13	65536
T6_COM2	14	65536

未压缩索引：select segment_name,extent_id,bytes from user_extents where segment_name in ('T6_UNCOMPRESSION2');
-----------------------------------------------------
T6_UNCOM2  0	65536
T6_UNCOM2	1	65536
T6_UNCOM2	2	65536
T6_UNCOM2	3	65536
T6_UNCOM2	4	65536
T6_UNCOM2	5	65536
T6_UNCOM2	6	65536
T6_UNCOM2	7	65536
T6_UNCOM2	8	65536
T6_UNCOM2	9	65536
T6_UNCOM2	10	65536
T6_UNCOM2	11	65536
T6_UNCOM2	12	65536
T6_UNCOM2	13	65536
T6_UNCOM2	14	65536
T6_UNCOM2	15	65536
T6_UNCOM2	16	1048576

2. sql_trace使用tkprof .../orcl_ora_984_t6.trc t6.txt
-----------------------------------------------------
create table t6_uncompression as select object_id,'aaa' object_name from dba_objects;
create table t6_compression compress as select object_id,'aaa' object_name from dba_objects;

select table_name,compression from user_tables where table_name like 'T6%';
T6_COMPRESSION  ENABLED
T6_UNCOMPRESSION	DISABLED

create index idx_t6_com on t6_compression(object_id);
create index idx_t6_uncom on t6_uncompression(object_id);

alter session set tracefile_identifier='t6';
alter session set sql_trace=true;

对压缩和未压缩的表数据，通过index查询，在结果集比较小的情况下，cpu,query,disk的测试结果是一样的。
-----------------------------------------------------

select * from t6_compression  where object_id<30 order by object_id asc ;
-----------------------------------------------------

Rows     Row Source Operation
      1  SORT AGGREGATE (cr=2 pr=0 pw=0 time=0 us)
     28   VIEW  (cr=2 pr=0 pw=0 time=270 us cost=3 size=3969 card=441)
     28    COUNT STOPKEY (cr=2 pr=0 pw=0 time=162 us)
     28     INDEX RANGE SCAN IDX_T6_COM (cr=2 pr=0 pw=0 time=54 us cost=3 size=5733 card=441)(object id 74980)

call     count       cpu    elapsed       disk      query    current        rows
Parse        1      0.00       0.00          0          2          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch        3      0.00       0.00          0          7          0          28
total        5      0.00       0.00          0          9          0          28


select * from t6_uncompression  where object_id<30 order by object_id asc ;
-----------------------------------------------------

Rows     Row Source Operation
      1  SORT AGGREGATE (cr=2 pr=0 pw=0 time=0 us)
     28   VIEW  (cr=2 pr=0 pw=0 time=270 us cost=3 size=5148 card=572)
     28    COUNT STOPKEY (cr=2 pr=0 pw=0 time=162 us)
     28     INDEX RANGE SCAN IDX_T6_UNCOM (cr=2 pr=0 pw=0 time=54 us cost=3 size=7436 card=572)(object id 74981)

call     count       cpu    elapsed       disk      query    current        rows
Parse        1      0.00       0.00          0          2          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch        3      0.00       0.00          0          7          0          28
total        5      0.00       0.00          0          9          0          28


对压缩和未压缩的表数据，在重复率很高的列上面，压缩的查询次数会比较少，但CPU的时间比未压缩的CPU时间要长，是符合场景的！
-----------------------------------------------------

select * from t6_compression  where object_name='aaa' order by object_id asc ;
-----------------------------------------------------

Rows     Row Source Operation
      1  SORT AGGREGATE (cr=62 pr=0 pw=0 time=0 us)
  39361   TABLE ACCESS SAMPLE T6_COMPRESSION (cr=62 pr=0 pw=0 time=77569 us cost=19 size=87482 card=5146)


call     count       cpu    elapsed       disk      query    current        rows
Parse        1      0.00       0.00          0          1          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch     4845      0.12       0.11          0        112          0       72650
total     4847      0.12       0.11          0        113          0       72650



select * from t6_uncompression   where object_name='aaa' order by object_id asc ;
-----------------------------------------------------

Rows     Row Source Operation
      1  SORT AGGREGATE (cr=69 pr=0 pw=0 time=0 us)
  33862   TABLE ACCESS SAMPLE T6_UNCOMPRESSION (cr=69 pr=0 pw=0 time=66060 us cost=19 size=87482 card=5146)

call     count       cpu    elapsed       disk      query    current        rows
Parse        1      0.00       0.00          0          1          0           0
Execute      1      0.00       0.00          0          0          0           0
Fetch     4845      0.07       0.11          0        144          0       72649
total     4847      0.07       0.11          0        145          0       72649


alter session set sql_trace=false;






3. 初始化表，压缩表T6_COMPRESSION占用2m，未压缩表T6_UNCOMPRESSION占用3m.
-----------------------------------------------------
create table t6_uncompression as select object_id,object_name from dba_objects;
create table t6_compression compress as select object_id,object_name from dba_objects;
set serveroutput on;
exec show_space('T6_COMPRESSION')

Free Blocks.............................               0
Total Blocks............................             256
Total Bytes.............................       2,097,152
Total MBytes............................               2
Unused Blocks...........................               0
Unused Bytes............................               0
Last Used Ext FileId....................               1
Last Used Ext BlockId...................          97,280
Last Used Block.........................             128


exec show_space('T6_UNCOMPRESSION')
Free Blocks.............................               0
Total Blocks............................             384
Total Bytes.............................       3,145,728
Total MBytes............................               3
Unused Blocks...........................              38
Unused Bytes............................         311,296
Last Used Ext FileId....................               1
Last Used Ext BlockId...................          97,152
Last Used Block.........................              90

insert操作：插入数据到压缩表，oracle执行解压操作，然后原压缩表增涨到3m未压缩大小！
-----------------------------------------------------
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');
insert into t6_compression values(123,'adfdafdaf');

exec show_space('T6_COMPRESSION');
Free Blocks.............................               5
Total Blocks............................             384
Total Bytes.............................       3,145,728
Total MBytes............................               3
Unused Blocks...........................             123
Unused Bytes............................       1,007,616
Last Used Ext FileId....................               1
Last Used Ext BlockId...................          98,176
Last Used Block.........................               5


update操作：修改表数据，oracle对压缩表执行解压操作，然后原压缩表增涨到3m未压缩大小！
-----------------------------------------------------
update t6_compression set object_name='abcad' where object_id>30;

exec show_space('T6_COMPRESSION')
Free Blocks.............................               2
Total Blocks............................             384
Total Bytes.............................       3,145,728
Total MBytes............................               3
Unused Blocks...........................             123
Unused Bytes............................       1,007,616
Last Used Ext FileId....................               1
Last Used Ext BlockId...................          98,176
Last Used Block.........................               5


delete操作：删除表数据，表大小并没有增涨到2m，还保持原大小！
-----------------------------------------------------
delete from t6_compression where  object_id=15;
delete from t6_compression where  object_id=20;

exec show_space('T6_COMPRESSION')
Free Blocks.............................               0
Total Blocks............................             256
Total Bytes.............................       2,097,152
Total MBytes............................               2
Unused Blocks...........................               0
Unused Bytes............................               0
Last Used Ext FileId....................               1
Last Used Ext BlockId...................          97,280
Last Used Block.........................             128


4.数据压缩技术用于处理表分区的海量数据时，可以
-----------------------------------------------------
1. 对表分区进行分为压缩，和分区索引分为的压缩
2. 减少数据块读入
3. 减少IO和内存的消耗
4. 减少占用磁盘空间
5. 提高查询效率

创建分区表
create table t6_obj_comp(
tid NUMBER(5),
tname VARCHAR2(30)
)
PARTITION BY RANGE(tid)
(
PARTITION t6_obj_comp1 VALUES LESS THAN(10000) ,
PARTITION t6_obj_comp2 VALUES LESS THAN(20000) ,
PARTITION t6_obj_comp3 VALUES LESS THAN(30000) ,
PARTITION t6_obj_comp4 VALUES LESS THAN(40000) ,
PARTITION t6_obj_comp5 VALUES LESS THAN(50000) ,
PARTITION t6_obj_comp6 VALUES LESS THAN(maxvalue)
);


select partition_name,compression from user_tab_partitions where table_name='T6_OBJ_COMP';
T6_OBJ_COMP1  DISABLED
T6_OBJ_COMP2	DISABLED
T6_OBJ_COMP3	DISABLED
T6_OBJ_COMP4	DISABLED
T6_OBJ_COMP5	DISABLED
T6_OBJ_COMP6	DISABLED

创建分区索引
create index idx_t6_obj_comp on t6_obj_comp(tid) local compress;

select table_name,index_name,compression from user_indexes where index_name like 'IDX_T6%';
T6_OBJ_COMP  IDX_T6_OBJ_COMP	ENABLED

select partition_name,compression from user_ind_partitions where index_name='IDX_T6_OBJ_COMP';

T6_OBJ_COMP1  ENABLED
T6_OBJ_COMP2	ENABLED
T6_OBJ_COMP3	ENABLED
T6_OBJ_COMP4	ENABLED
T6_OBJ_COMP5	ENABLED
T6_OBJ_COMP6	ENABLED


当分区1的10000条满了以后，修改分区t6_obj_comp1为压缩分区。
alter table t6_obj_comp modify partition t6_obj_comp1 compress;

select partition_name,compression from user_tab_partitions where table_name='T6_OBJ_COMP';
T6_OBJ_COMP1  ENABLED
T6_OBJ_COMP2	DISABLED
T6_OBJ_COMP3	DISABLED
T6_OBJ_COMP4	DISABLED
T6_OBJ_COMP5	DISABLED
T6_OBJ_COMP6	DISABLED


