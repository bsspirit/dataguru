第2周 Hadoop数据分析平台  -- 张丹(12)
========================================================

书面作业 

完成Hadoop集群的安装，把安装的过程抓图（不方便抓图的可以用拍照等各种手段）放在作业中，作业中应要介绍具体的安装环境和主要安装步骤。 


互动作业 

本周的互动内容自由，可以围绕Hadoop的安装实施问题，Hadoop集群的应用等方面展开。 
要求每位同学至少发2篇主题（Hadoop版：http://f.dataguru.cn/forum-59-1.html），至少参与5个上述主题的讨论（回帖）。 
注意在Dataguru课程平台上的“互动”功能标签，大家进入后可以看到本周的互动要求（板块，时间段，数量等），以及你现在的完成进度情况。 
本周的书面作业和互动作业都纳入罚扣考核范围，请大家注意按时按质完成！


### 操作系统及环境信息
Linux Gentoo

$ uname -a
Linux domU-00-16-3e-00-00-84 2.6.38-xen #2 SMP Wed Jan 18 10:18:13 CST 2012 x86_64 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux

$ java -version
java version "1.6.0_29"
Java(TM) SE Runtime Environment (build 1.6.0_29-b11)
Java HotSpot(TM) 64-Bit Server VM (build 20.4-b02, mixed mode)

### ５台机器，１个NameNode，４个DataNode，通过DNS指定域名

    namenode:  nn.qa.tianji.com   1G  2G+16G
    datanode1: dn0.qa.tianji.com　1G  2G+16G
    datanode2: dn1.qa.tianji.com  1G  2G+16G
    datanode3: dn2.qa.tianji.com  1G  2G+16G
    datanode4: dn3.qa.tianji.com  1G  2G+16G

### 挂载硬盘16G
1. mkfs.ext4 -j /dev/xvdb
2. mkdir /hadoop
3. mount /dev/xvdb /hadoop
4. vi /etc/fstab

        /dev/xvdb /hadoop ext4 noatime 0 1
   
### 创建hadoop账号和组
1. groupadd hadoop
2. useradd hadoop -g hadoop;
3. passwd hadoop
4. mkdir /home/hadoop
5. chown -R hadoop:hadoop /home/hadoop

### 创建hadoop工作目录
1. mkdir /hadoop/conan/data0
2. chown -R hadoop:hadoop /hadoop/conan/data0

### 配置ssh及密码
nn.qa.tianji.com:
  1. su hadoop
  2. ssh-keygen -t rsa
  3. cd /home/hadoop/.ssh/
  4. cat id_rsa.pub >> authorized_keys
  5. scp authorized_keys dn0.qa.tianji.com:/home/hadoop/.ssh/
  
dn0.qa.tianji.com:
  1. su hadoop
  2. ssh-keygen -t rsa
  3. cd /home/hadoop/.ssh/
  4. cat id_rsa.pub >> authorized_keys
  5. scp authorized_keys dn1.qa.tianji.com:/home/hadoop/.ssh/
  
dn1.qa.tianji.com:
  1. su hadoop
  2. ssh-keygen -t rsa
  3. cd /home/hadoop/.ssh/
  4. cat id_rsa.pub >> authorized_keys
  5. scp authorized_keys dn2.qa.tianji.com:/home/hadoop/.ssh/
  
dn2.qa.tianji.com:
  1. su hadoop
  2. ssh-keygen -t rsa
  3. cd /home/hadoop/.ssh/
  4. cat id_rsa.pub >> authorized_keys
  5. scp authorized_keys dn3.qa.tianji.com:/home/hadoop/.ssh/
  
dn3.qa.tianji.com:
  1. su hadoop
  2. ssh-keygen -t rsa
  3. cd /home/hadoop/.ssh/
  4. cat id_rsa.pub >> authorized_keys
  5. scp authorized_keys nn.qa.tianji.com:/home/hadoop/.ssh/
  
nn.qa.tianji.com:
  1. su hadoop
  2. cd /home/hadoop/.ssh/
  3. scp authorized_keys dn0.qa.tianji.com:/home/hadoop/.ssh/
  4. scp authorized_keys dn1.qa.tianji.com:/home/hadoop/.ssh/
  5. scp authorized_keys dn2.qa.tianji.com:/home/hadoop/.ssh/
  6. scp authorized_keys dn3.qa.tianji.com:/home/hadoop/.ssh/
  
  
### 下载及配置hadoop
nn.qa.tianji.com:
  1. cd /hadoop/conan
  2. wget http://mirror.bjtu.edu.cn/apache/hadoop/common/hadoop-0.20.2/hadoop-0.20.2.tar.gz
  3. tar zxvf hadoop-0.20.2.tar.gz
  4. cd /hadoop/conan/hadoop-0.20.2/conf
  5. vi hadoop-env.sh
      export JAVA_HOME=/etc/java-config-2/current-system-vm
  6. vi hdfs-site.xml
  
        <configuration>
          <property>
            <name>dfs.data.dir</name>
            <value>/hadoop/conan/data0</value>
          </property>
          <property>
            <name>dfs.replication</name>
            <value>2</value>
          </property>
        </configuration>
  
  7. vi core-site.xml 
  
        <configuration>
        <property>
          <name>fs.default.name</name>
          <value>hdfs://nn.qa.tianji.com:9000</value>
        </property>
        </configuration>
  
  8. vi mapred-site.xml
  
        <configuration>
        <property>
          <name>mapred.job.tracker</name>
          <value>nn.qa.tianji.com:9001</value>
        </property>
        </configuration>

  9. vi masters
  
        nn.qa.tianji.com
  
  10. vi slaves
  
        n0.qa.tianji.com
        dn1.qa.tianji.com
        dn2.qa.tianji.com
        dn3.qa.tianji.com
  
  11. cd /hadoop/conan
  12. scp -r ./hadoop-0.20.2 dn0.qa.tianji.com:/hadoop/conan
  13. scp -r ./hadoop-0.20.2 dn1.qa.tianji.com:/hadoop/conan
  14. scp -r ./hadoop-0.20.2 dn2.qa.tianji.com:/hadoop/conan
  15. scp -r ./hadoop-0.20.2 dn3.qa.tianji.com:/hadoop/conan
  16. cd /hadoop/conan/hadoop-0.29.2
  17. bin/hadoop namenode -format
  18. bin/start-all.sh
  19. jps
      
        9362 Jps
        7756 SecondaryNameNode
        7531 JobTracker
        7357 NameNode
        
  20. netstat -nl
  
        Active Internet connections (only servers)
        Proto Recv-Q Send-Q Local Address           Foreign Address         State      
        tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
        tcp        0      0 0.0.0.0:5666            0.0.0.0:*               LISTEN     
        tcp        0      0 0.0.0.0:8649            0.0.0.0:*               LISTEN     
        tcp6       0      0 :::50070                :::*                    LISTEN     
        tcp6       0      0 :::22                   :::*                    LISTEN     
        tcp6       0      0 :::39418                :::*                    LISTEN     
        tcp6       0      0 :::32895                :::*                    LISTEN     
        tcp6       0      0 192.168.1.238:9000      :::*                    LISTEN     
        tcp6       0      0 192.168.1.238:9001      :::*                    LISTEN     
        tcp6       0      0 :::50090                :::*                    LISTEN     
        tcp6       0      0 :::51595                :::*                    LISTEN     
        tcp6       0      0 :::50030                :::*                    LISTEN     
        udp        0      0 239.2.11.71:8649        0.0.0.0:*  

### HDFS测试
nn.qa.tianji.com:
  1. cd /hadoop/conan/hadoop-0.29.2
  2. bin/hadoop fs -mkdir /test
  3. bin/hadoop fs -copyFormLocal README.txt /test
  4. bin/hadoop fs -ls /test
    
        Found 1 items
        -rw-r--r--   2 hadoop supergroup       1366 2012-08-30 02:05 /test/README.txt

### MapReduce测试


      

  
      



