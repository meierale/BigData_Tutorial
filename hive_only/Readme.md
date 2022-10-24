# Hive Only Tutorial
Dies ist ein bewusst sehr kurz & einfach gehaltenes mini Tutorial zu HDFS und Hive. Es entspricht praktisch 1:1 der Vorarbeit von Hrishi Shirodkar (https://hshirodkar.medium.com/apache-hive-on-docker-4d7280ac6f8e) und den Docker images von Big Data Europe (https://github.com/big-data-europe)

Wenn du das Repo lokal geklont hast, der Docker Daemon auf deinem System läuft, dann starte bitte die ganze Umgebung mit:
```
docker-compose up
```
Dieser Prozess kann initial einige Minuten in Anspruch nehmen, da einerseits mehrere Docker Images geladen werden müssen und andererseits das Aufstarten der Umgebung eine gewisse Zeit dauert, bis alle Services operativ sind.

Wenn du dir das `docker-compose.yml` genauer anschaust, siehst du, dass der `employee` Ordner des Repos direkt in das root Verzeichnis des `hive-server` gemounted wird (Zeile 33 & 34). Dies erleichtert nachher das Erstellen der `employee` Datenbank in Hive.

## Prüfen der Services
Nachdem `docker-compose up` einige Zeit gelaufen ist, solltest du irgendwann im Terminal die Meldung `hive-metastore:9083 is available` sehen. Dies ist das Zeichen, dass wir mit den weiteren Schritten fortfahren können.

Alternativ kannst du auch mit `docker stats` die aktuelle Auslastung der Docker container einsehen:
* Wenn jeder der 5 Container weniger als 2% CPU Auslastung aufweist 
* und wenn jeder Container lediglich wenige Hundert MB Ram benötigt, 
* dann kannst du ebenfalls mit den weiteren Schritten fortfahren.

## Hive Demo
Führe die folgenden Schritte nacheinander aus:
```
docker exec -it hive-server /bin/bash

root@dc86b2b9e566:/opt# ls
hadoop-2.7.4  hive

root@dc86b2b9e566:/# cd /employee/
root@dc86b2b9e566:/employee# hive -f employee_table.hql
root@dc86b2b9e566:/employee# hadoop fs -put employee.csv hdfs://namenode:8020/user/hive/warehouse/testdb.db/employee
```

Nun hast du die Hive Datenbank und Tabelle erstellt, dieses Setup kann jetzt validiert werden:
```
root@df1ac619536c:/employee# hive

hive> show databases;
OK
default
employees

hive> use employees;
OK
Time taken: 0.085 seconds

hive> select * from employee;
OK
1 Rudolf Bardin 30 cashier 100 New York 40000 5
2 Rob Trask 22 driver 100 New York 50000 4
3 Madie Nakamura 20 janitor 100 New York 30000 4
4 Alesha Huntley 40 cashier 101 Los Angeles 40000 10
5 Iva Moose 50 cashier 102 Phoenix 50000 20
Time taken: 4.237 seconds, Fetched: 5 row(s)
``` 