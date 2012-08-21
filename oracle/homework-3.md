Oracle 第三周作业 - 张丹(15)
========================================================
阅读作业 阅读《让Oracle跑得更快2》第一篇 分区，最重要的是要弄清楚每种分区的使用场景和分区的具体应用。

书面作业 
1.分别创建range,list和hash分区表，并说明他们在现实中的适用场景。
2.模拟数据加载入库的过程（数据加载--sql*loader---〉临时表-----〉创建索引----〉分区交换）。
3.性能比较，自己构造分区表,索引和SQL语句，来比较range,list和Hash3种分区的性能差异。
4.手工创建 Range-hash， Range-list， RANGE-RANGE， LIST-RANGE， LIST-HASH ，LIST-LIST这几种组合分区，对每种组合分区，说明它们在现 实中的应用场景。


互动作业 
请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配 的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数 据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形 式）。

------------------------------------------------
1.range分区:按时间把数据分隔在不同的区域。用于按时间的历史数据存储。
create table t_user1(
id1 NUMBER(5),
name1 VARCHAR2(30),
date1 DATE)
PARTITION BY RANGE(date1)
(
PARTITION sales_2012 VALUES LESS THAN(TO_DATE('01/01/2012','DD/MM/YYYY')),
PARTITION sales_2013 VALUES LESS THAN(TO_DATE('01/01/2013','DD/MM/YYYY')),
PARTITION sales_2014 VALUES LESS THAN(TO_DATE('01/01/2014','DD/MM/YYYY'))
);


Hash分区：通过hash算法把数据均匀分部到不同的区域，用于均匀分配磁盘空间。
create table t_user2 
partition by hash(object_id) partitions 8 as 
select * 
from dba_objects;


list分区：按字段值进行分区，用于按地区的数据存储。
create table t_user3(
id1 NUMBER(5),
name1 VARCHAR2(30),
area VARCHAR2(10)
)
PARTITION BY LIST(area)
(
PARTITION west VALUES ('west'),
PARTITION east VALUES ('east'),
PARTITION north VALUES ('north'),
PARTITION south VALUES ('south')
);


------------------------------------------------
2.
在在线数据库中通过临时表的方式将需要过期处理的分区数据和索引交换出来；
通过表空间传递的方式导出表空间；
将导出的dmp 文件和表空间数据文件拷贝到离线数据库中；
在离线数据库中导入表空间；
将导入表空间上的临时表数据和索引交换到离线数据库的分区表中。

select partition_name,tablespace_name,segment_type from user_segments
where segment_name='SALE_DATA';

select partition_name,tablespace_name,segment_type from user_segments
where segment_name='IND_SALE_DATA';

select tablespace_name,segment_name,segment_type from user_segments
where segment_name like '%SALE_DATA_2009_1';

alter table sale_data exchange partition sales_2009_1
with table tmp_sale_data_2009_1 including indexes with validation

select partition_name,tablespace_name,segment_type from user_segments
where segment_name = 'SALE_DATA' or segment_name='IND_SALE_DATA' order by 2;

select tablespace_name,segment_name,segment_type from user_segments
where segment_name like '%SALE_DATA_2009_1';

exec dbms_tts.transport_set_check('TS_SALES_2009_1', TRUE);
alter tablespace TS_SALES_2009_1 read only;

alter table sale_data exchange partition sales_2009_1
with table tmp_sale_data_2009_1 including indexes with validation;

------------------------------------------------
3.
create table t_range(
id1 NUMBER(5),
date1 DATE)
PARTITION BY RANGE(date1)
(
PARTITION sales_2012 VALUES LESS THAN(TO_DATE('01/01/2012','DD/MM/YYYY')),
PARTITION sales_2013 VALUES LESS THAN(TO_DATE('01/01/2013','DD/MM/YYYY')),
PARTITION sales_2014 VALUES LESS THAN(TO_DATE('01/01/2014','DD/MM/YYYY'))
);
create index t_range on t_range(id1) local;

create table t_hash(
id1 NUMBER(5),
date1 DATE)
PARTITION BY hash(id1) partitions 3;
create index t_hash on t_hash(id1) local;


create table t_list(
id1 NUMBER(5),
date1 DATE)
PARTITION BY LIST(id1)
(
partition p1 values(0,1,2,3,4),
partition p2 values(5,6,7,8,9),
partition p3 values (10,11,12,13,14)
);
create index t_list on t_list(id1) local


insert into t_range  select object_id, sysdate from dba_objects;
insert into t_hash  select object_id, sysdate from dba_objects;
insert into t_list select namespace, sysdate from dba_objects where namespace<=14;


对于数值重复率很低的一个表，当进行一个小范围扫描时，哈希分区通过索引访问数据的效率要高于范围分区。
但当扫描的范围足够大，索引不再适合时，由于分区裁剪的原因，范围分区的效率就会高于哈希分区.
列表分区与范围分区类似，主要看数据量及分布情况。


------------------------------------------------
4.
Range-hash：范围-哈希组合分区，用于按时间的历史数据，均匀分布存储。
create table t_range_hash(id int,name varchar2(100))
partition by range(id)
subpartition by hash(name)
 (
 partition p1 values less than(5)
 (
 subpartition sp1,
 subpartition sp2
 ),
 partition p2 values less than(10)
 (
 subpartition sp3,
 subpartition sp4
 )
);

Range-list：范围-列表组合分区，用于按时间的历史数据，再按地区分布。
create table t_range_list(id int,area varchar2(100))
partition by range(id)
subpartition by list(area)
(
 partition p1 values less than(5)
 (
  subpartition west1 VALUES ('west'),
  subpartition east1 VALUES ('east'),
  subpartition north1 VALUES ('north'),
  subpartition south1 VALUES ('south')
 ),
 partition p2 values less than(10)
 (
  subpartition west2 VALUES ('west'),
  subpartition east2 VALUES ('east'),
  subpartition north2 VALUES ('north'),
  subpartition south2 VALUES ('south')
 )
);


RANGE-RANGE：范围-范围组合分区，用于按时间年分布，再按时间月分布。
create table t_range_range(id int,age int)
partition by range(id)
subpartition by range(age)
(
 partition p1 values less than(5)
 (
  subpartition age20_1 VALUES less than(20),
  subpartition age40_1 VALUES less than(40),
  subpartition age60_1 VALUES less than(60)
 ),
 partition p2 values less than(10)
 (
  subpartition age20_2 VALUES less than(20),
  subpartition age40_2 VALUES less than(40),
  subpartition age60_2 VALUES less than(60)
 )
);


LIST-RANGE：列表-范围组合分区，先按地区分布，再按时间分布。
create table t_list_range(
id1 NUMBER(5),
area VARCHAR2(10)
)
PARTITION BY LIST(area)
subpartition by range(id1)
(
  PARTITION west VALUES ('west')
  (
  subpartition p1 values less than(5),
  subpartition p2 values less than(10)
  ),
  PARTITION east VALUES ('east')
  (
  subpartition p3 values less than(5),
  subpartition p4 values less than(10)
  )
);


LIST-HASH：列表-哈希组合分区：先按地区分布，再均匀分布存储。
create table t_list_hash(
id1 NUMBER(5),
area VARCHAR2(10)
)
PARTITION BY LIST(area)
subpartition by hash(id1)
(
  PARTITION west VALUES ('west')
  (
  subpartition p1 ,
  subpartition p2
  ),
  PARTITION east VALUES ('east')
  (
  subpartition p3,
  subpartition p4 
  )
);

LIST-LIST：列表-列表组合分区：先按地区分布，再按收入分布。
create table t_list_list(
id1 NUMBER(5),
name VARCHAR2(10),
area VARCHAR2(10)
)
PARTITION BY LIST(area)
subpartition by LIST(name)
(
  PARTITION west VALUES ('west')
  (
  subpartition zhang1 VALUES ('zhang'),
  subpartition wang1 VALUES ('wang')
  ),
  PARTITION east VALUES ('east')
  (
  subpartition zhang2 VALUES ('zhang'),
  subpartition wang2 VALUES ('wang')
  )
);

