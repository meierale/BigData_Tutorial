# BigData_Tutorial

## Web UIs
http://3.67.205.210:9870/ (resp. http://localhost:9870/)
http://3.67.205.210:8080/ (resp..
http://3.67.205.210:8081/ 

## HDFS 
docker cp breweries.csv nodemanager:tmp/breweries.csv
docker exec -it nodemanager bash

hdfs dfs -ls -R /

    3  hdfs dfs -mkdir -p /data/openbeer/breweries
    5  hdfs dfs -put breweries.csv /data/openbeer/breweries/breweries.csv
    6  hdfs dfs -ls -R /data

## Spark (pySpark)
docker exec -it spark-master bash
bash-5.0# /spark/bin/pyspark --master spark://spark-master:7077

brewfile = spark.read.csv("hdfs://namenode:9000/data/openbeer/breweries/breweries.csv")
brewfile.show()

## Hive
docker exec -it hive-server bash
root@51a06b766366:/opt# hiveserver2

netstat -anp | grep 10000
tcp        0      0 0.0.0.0:10000           0.0.0.0:*               LISTEN      418/java

beeline -u jdbc:hive2://localhost:10000 -n root

dann am schluss
hdfs dfs -ls -R /user
drwxr-xr-x   - root supergroup          0 2022-10-15 13:59 /user/hive
drwxrwxr-x   - root supergroup          0 2022-10-16 13:47 /user/hive/warehouse
drwxrwxr-x   - root supergroup          0 2022-10-16 13:47 /user/hive/warehouse/openbeer.db
