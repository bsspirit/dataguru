Oracle 第一周作业 - 张丹(15)
========================================================

阅读作业 本节课没有书面阅读,大家有兴趣可以去找一些大树据相关的资料阅读. 

书面作业
1.你心中的大数据是什么样的? 
2.搭建一个测试环境，作行，列数据库的性能比较(数据库可以选择Oracle和sybase iq，自己定义几种类型的SQL查询). 
3.你对RDBMS和NOSQL的将来，有什么看法？ 

互动作业
请所有的学员都在炼数成金网站（http://f.dataguru.cn）注册账号，并且在“真实姓名”属性项填写“ora-nn”的字样（此处nn代表分配的学号），使我们可以在公众用户中识别出学员。 要求大家在本周参与“相关IT支撑技术”板块（讨论数据库相关技术）,"关系型数据库数据分析"(OLAP相关技术的讨论)的互动。每位学员至少以主题帖的形式提出2个问题（或讨论话题）然后至少参加5个上述主题的讨论（回帖形式）。 本周的网络互动属于适应期，暂时不进行核查和扣罚。


------------------------------------------------
1.你心中的大数据是什么样的? 
大数据包括二类, 一类是人的数据, 比如一个人衣食住行,吃乐玩喝,在海量用户的时数据量是无法想像的.
第二类是所有非人类制造的数据,比如x光片,物联网,卫星等,这些数据和人类制造数据再进行交叉,在海量用户和海量机器的情况下,这样规模数据的数量级,远远超过现在所有存储设备容量总和.


2.搭建一个测试环境，作行，列数据库的性能比较(数据库可以选择Oracle和sybase iq，自己定义几种类型的SQL查询). 

测试环境MySQL的MyISAM行式数据库引擎和InfoBright的brightHouse列式数据库引擎.
本机系统：普通台式机，2CPU，2G内存，硬盘5400转，Linux Ubuntu 12.04 32位
InfoBright按最小默认配置my-ib.cnf
 [mysqld]
 27 port        = 5029
 28 socket      = /tmp/mysql-ib.sock
 29 skip-locking
 30 key_buffer = 16M
 31 max_allowed_packet = 500M
 32 table_cache = 16
 33 sort_buffer_size = 1M
 34 read_buffer_size = 1M
 35 read_rnd_buffer_size = 4M
 36 myisam_sort_buffer_size = 8M
 37 net_buffer_length = 8K
 38 thread_cache_size = 32
 39 thread_stack = 512K
 40 query_cache_size = 8M
 41 query_cache_type=0
 42 # Try number of CPU cores*4 for thread_concurrency
 43 thread_concurrency = 8

数据结构DDL：
CREATE TABLE t_user_myISAM(
    id INT,
    name varchar(32) NOT NULL ,
    create_date TIMESTAMP NULL  DEFAULT now()
)ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE t_user_righthouse(
    id INT,
    name varchar(32) NOT NULL ,
    create_date TIMESTAMP NULL  DEFAULT now()
)ENGINE=Brighthouse DEFAULT CHARSET=utf8;

数据样本：
tail -f /tmp/myisam.csv 
14999990,14999990--14999990,2012-07-05 16:56:54
14999991,14999991--14999991,2012-07-05 16:56:54
14999992,14999992--14999992,2012-07-05 16:56:54
14999993,14999993--14999993,2012-07-05 16:56:54
14999994,14999994--14999994,2012-07-05 16:56:54
14999995,14999995--14999995,2012-07-05 16:56:54
14999996,14999996--14999996,2012-07-05 16:56:54
14999997,14999997--14999997,2012-07-05 16:56:54
14999998,14999998--14999998,2012-07-05 16:56:54
14999999,14999999--14999999,2012-07-05 16:56:54



存储比较：数据量分别为50W条，500W条，2500W条
第一行为原始CSV,第二行为tar.gz压缩的CSV，t_user_myISAM.MYD为MyISAM引擎存储的数据文件，t_user_righthouse.bht是

#50w
-rw-rw-rw- 1 mysql mysql 20666643  7月  5 16:03 /tmp/myisam.csv
-rw-rw-r-- 1 mysql mysql  3640018  7月  5 16:20 /tmp/myisam.tar.gz
-rwxr-xr-x 1 mysql mysql     8630  7月  5 15:32 t_user_myISAM.frm*
-rwxr-xr-x 1 mysql mysql 13959580  7月  5 15:32 t_user_myISAM.MYD*
-rwxr-xr-x 1 mysql mysql     1024  7月  5 15:32 t_user_myISAM.MYI*

#500w
-rw-rw-rw- 1 mysql mysql 221666643  7月  5 16:32 /tmp/myisam.csv
-rw-rw-r-- 1 conan conan  36877526  7月  5 16:33 /tmp/myisam.tar.gz
-rw-rw---- 1 mysql mysql      8630  7月  5 16:24 t_user_myISAM.frm
-rw-rw---- 1 mysql mysql 155959580  7月  5 16:30 t_user_myISAM.MYD
-rw-rw---- 1 mysql mysql      1024  7月  5 16:30 t_user_myISAM.MYI

#2500w
-rw-rw-rw- 1 mysql mysql 908333286  7月  5 16:58 /tmp/myisam.csv
-rw-rw-r-- 1 conan conan 147507267  7月  5 16:59 /tmp/myisam.tar.gz
-rw-rw---- 1 mysql mysql      8630  7月  5 16:24 t_user_myISAM.frm
-rw-rw---- 1 mysql mysql 631919160  7月  5 16:56 t_user_myISAM.MYD
-rw-rw---- 1 mysql mysql      1024  7月  5 16:56 t_user_myISAM.MYI
drwxrwx--x 2 mysql mysql      4096  7月  5 17:01 t_user_righthouse.bht/
-rw-rw---- 1 mysql mysql      8630  7月  5 16:24 t_user_righthouse.frm
#打开t_user_righthouse.bht/目录
drwxr-xr-x 2 mysql mysql      4096  7月  5 17:01 ./
drwxr-xr-x 3 mysql mysql      4096  7月  5 16:24 ../
-rw-rw---- 1 mysql mysql         0  7月  5 17:01 ab_switch
-rw-rw---- 1 mysql mysql     15344  7月  5 17:01 TA00000000000000.ctb
-rw-rw---- 1 mysql mysql      5616  7月  5 16:34 TA00000000000001.ctb
-rw-rw---- 1 mysql mysql       117  7月  5 16:34 TA00000.ctb
-rw-rw---- 1 mysql mysql     14171  7月  5 17:01 TA00000DPN.ctb
-rw-rw---- 1 mysql mysql 126449126  7月  5 17:01 TA00001000000000.ctb
-rw-rw---- 1 mysql mysql  31428144  7月  5 16:34 TA00001000000001.ctb
-rw-rw---- 1 mysql mysql       103  7月  5 16:34 TA00001.ctb
-rw-rw---- 1 mysql mysql     14171  7月  5 17:01 TA00001DPN.ctb
-rw-rw---- 1 mysql mysql     16962  7月  5 17:01 TA00002000000000.ctb
-rw-rw---- 1 mysql mysql      6015  7月  5 16:34 TA00002000000001.ctb
-rw-rw---- 1 mysql mysql       126  7月  5 16:34 TA00002.ctb
-rw-rw---- 1 mysql mysql     14171  7月  5 17:01 TA00002DPN.ctb
-rw-rw---- 1 mysql mysql        65  7月  5 16:24 Table.ctb
-rw-rw---- 1 mysql mysql       117  7月  5 17:01 TB00000.ctb
-rw-rw---- 1 mysql mysql       103  7月  5 17:01 TB00001.ctb
-rw-rw---- 1 mysql mysql       126  7月  5 17:01 TB00002.ctb

数据存储总结：brighthouse的列式引擎的压缩比，真是相当的高啊！

数据行    csv   csv.tar.gz    MyISAM     brighthouse        
50w       20m      3m           14m
500w      222m    37m          156m
2500w     908m    147m         623m         159m    


数据查询(2500w)：无索引！
SELECT * FROM infobright.t_user_myISAM 
where create_date<'2012-07-05 16:26:32' limit 1000000,100; 
时间>30s

SELECT * FROM infobright.t_user_righthouse 
where create_date<'2012-07-05 16:26:32' limit 1000000,100;
时间<1s

SELECT count(id) FROM infobright.t_user_myISAM 
where create_date<'2012-07-05 16:26:32';
时间>30s

SELECT count(id) FROM infobright.t_user_righthouse 
where create_date<'2012-07-05 16:26:32';
时间<1s

如此可以，brighthouse引擎查询是很快的,远优于无索引的MyIASM。

在t_user_myISAM表创建索引：
CREATE INDEX t_user_myISAM_IDX_1 on t_user_myISAM(id);

-rw-rw---- 1 mysql mysql      8630  7月  6 10:52 t_user_myISAM.frm
-rw-rw---- 1 mysql mysql 631919160  7月  6 10:53 t_user_myISAM.MYD
-rw-rw---- 1 mysql mysql 226201600  7月  6 10:54 t_user_myISAM.MYI
索引占用空间226m


mysql> SELECT count(id) FROM infobright.t_user_myISAM where id<15484646;
+-----------+
| count(id) |
+-----------+
|  19999998 |
+-----------+
1 row in set (16.17 sec)

mysql> explain SELECT count(id) FROM infobright.t_user_myISAM  where id<15484646;
+----+-------------+---------------+-------+---------------------+---------------------+---------+------+----------+--------------------------+
| id | select_type | table         | type  | possible_keys       | key                 | key_len | ref  | rows     | Extra                    |
+----+-------------+---------------+-------+---------------------+---------------------+---------+------+----------+--------------------------+
|  1 | SIMPLE      | t_user_myISAM | index | t_user_myISAM_IDX_1 | t_user_myISAM_IDX_1 | 5       | NULL | 19999998 | Using where; Using index |
+----+-------------+---------------+-------+---------------------+---------------------+---------+------+----------+--------------------------+
1 row in set (0.01 sec)

按索引的查询，需要16.17s

mysql> SELECT count(id) FROM infobright.t_user_righthouse  where id<15484646;
+-----------+
| count(id) |
+-----------+
|  24999997 |
+-----------+
1 row in set (0.00 sec)

mysql> explain SELECT count(id) FROM infobright.t_user_righthouse  where id<15484646;
+----+-------------+-------------------+------+---------------+------+---------+------+----------+-----------------------------------+
| id | select_type | table             | type | possible_keys | key  | key_len | ref  | rows     | Extra                             |
+----+-------------+-------------------+------+---------------+------+---------+------+----------+-----------------------------------+
|  1 | SIMPLE      | t_user_righthouse | ALL  | NULL          | NULL | NULL    | NULL | 24999997 | Using where with pushed condition |
+----+-------------+-------------------+------+---------------+------+---------+------+----------+-----------------------------------+
1 row in set (0.00 sec)


索引总结：即使使用MyISAM的索引查询，对于2500W条数据来说，也不如brighthouse的无索引ALL查询。我们真应该在适合的时间，适合的地点，把列式数据库应用起来！！








3.你对RDBMS和NOSQL的将来，有什么看法？
首先, RDBMS与NOSQL都在发展, 都有各自的使用领域, 会一直并存下去.
从应用角度, RDBMS偏向于设计,对于像软件应用,ERP系统等, 业务需求稳定的系统来说, RDBMS会一直是主流.
对于快速原型,快速实现,需求天天变的互联网应用来说,NoSQL是让开发人员少加班的利器.

也许未来,NoSQL会更专业化, 就像Neo4j一样...一种领域,一种数据库. 
而对于RDBMS把基础数据类型,基础功能完善好,其实就足够了.当然,如果能在RDBMS里,定义NoSQL的类型字段,那么RBDMS又将统一天下了!





