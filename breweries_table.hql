create database if not exists breweries;
use breweries;
CREATE EXTERNAL TABLE IF NOT EXISTS brewery(
    NUM INT,
    NAME CHAR(100),
    CITY CHAR(100),
    STATE CHAR(100),
    ID INT )
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
location '/data/openbeer/breweries';