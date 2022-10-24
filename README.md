# BigData_Tutorial
Dies ist ein bewusst sehr kurz & einfach gehaltenes mini Tutorial zu HDFS, Spark und Hive. Es basiert auf der Vorarbeit von Marcel Jan (https://github.com/Marcel-Jan/docker-hadoop-spark) und den Docker images von Big Data Europe (https://github.com/big-data-europe)

Wenn du das Repo lokal geklont hast, der Docker Daemon auf deinem System läuft, dann starte bitte die ganze Umgebung mit:
```
docker-compose up
```
Dieser Prozess kann initial einige Minuten in Anspruch nehmen, da einerseits mehrere Docker Images geladen werden müssen und andererseits das Aufstarten der Umgebung eine gewisse Zeit dauert, bis alle Services operativ sind.


## Web UIs
Die folgenden Web UIs werden wir im Tutorial verwenden:
* HDFS Namenode UI: http://localhost:9870/ (http://3.67.205.210:9870/) 
* Spark Master UI:  http://localhost:8080/ (http://3.67.205.210:8080/) 
* Spark Worker UI:  http://localhost:8081/ (http://3.67.205.210:8081/) 

## HDFS 
In diesem Teil des Tutorial laden wir zunächst ein lokal vorhandenes File in einen Docker Container hoch, welcher Zugriff auf HDFS hat. Dann laden wir von diesem Docker Container aus das File ins HDFS:
1. `docker ps` 
1. `docker cp breweries.csv nodemanager:tmp/breweries.csv`
1. `docker exec -it nodemanager bash`
1. `hdfs dfs -ls /`
1. `hdfs dfs -mkdir -p /data/openbeer/breweries`
1. `hdfs dfs -put breweries.csv /data/openbeer/breweries/breweries.csv`
1. `hdfs dfs -ls -R /data`

## Spark (pySpark)
Nun, da wir das file `breweries.csv` in HDFS liegen haben, können wir es mit PySpark einlesen und bearbeiten:

1. `docker ps` 
1. `docker exec -it spark-master /bin/bash`
1. `bash-5.0# /spark/bin/pyspark --master spark://spark-master:7077`
1. `brewfile = spark.read.csv("hdfs://namenode:9000/data/openbeer/breweries/breweries.csv")`
1. `brewfile.show()`
1. `brewfile.printSchema()`
1. `brewfile.count()`
1. `brewfile.groupBy("name", "calories").count().show()`

Weitere Beispiele einfügen:
```
filter(), groupby(), toDF(), sort, etc.
```

## Hive
Nebst Spark wollen wir auch einen kurzen Einblick in Hive haben. In Hive erstellen wir eine neue Datenbank sowie eine Tabelle mit den Daten des hochgeladenen Files.
Die Daten selbst liegen im angegebenen CSV, die Metadatan im Hive Warehouse:

1. `docker ps` 
1. `docker cp breweries_table.hql hive-server:tmp/breweries_table.hql`
1. `docker exec -it hive-server /bin/bash`
1. `cd /tmp/`
1. `hive -f breweries_table.hql` 
1. `hive`
1. `show databases;`
1. `describe breweries;`
1. `select name from breweries limit 10;`
1. `select count(*) from breweries;`

ODER
Alternative Variante, manuell Tabelle anlegen:
1. `root@51a06b766366:/opt# hiveserver2`
   * `netstat -anp | grep 10000`
    ```
    tcp        0      0 0.0.0.0:10000           0.0.0.0:*               LISTEN      418/java
    ```

1. `beeline -u jdbc:hive2://localhost:10000 -n root`
1. `show databases;`
1. `create database openbeer;`
1. `use openbeer;`
1. ```
   CREATE EXTERNAL TABLE IF NOT EXISTS breweries(
    NUM INT,
    NAME CHAR(100),
    CITY CHAR(100),
    STATE CHAR(100),
    ID INT )
   ROW FORMAT DELIMITED
   FIELDS TERMINATED BY ','
   STORED AS TEXTFILE
   location '/data/openbeer/breweries';
   ```
1. `select name from breweries limit 10;`


Den neuen Eintrag der Breweries-DB Metadaten sehen wir nun auch in HDFS, unter dem Userhome des `hive` users::
```
hdfs dfs -ls -R /user
drwxr-xr-x   - root supergroup          0 2022-10-15 13:59 /user/hive
drwxrwxr-x   - root supergroup          0 2022-10-16 13:47 /user/hive/warehouse
drwxrwxr-x   - root supergroup          0 2022-10-16 13:47 /user/hive/warehouse/openbeer.db
```
