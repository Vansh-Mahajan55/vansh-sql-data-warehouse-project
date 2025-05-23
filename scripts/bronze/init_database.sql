/*
=============================
Create Database and Schemas
=============================
Script Use:
    This Script creates a Database named "DataWareHouse" after checking if it already exists or not.
    If it exists it is dropped and recreated.  
    Additionally, the script creates three new schemas within the Database: "bronze, silver, gold".

Warning:
    The script WILL delete the database if it already exists.
    All data stored will be permanently deleted. Ensure backups before running this script.
*/

-- selecting the master branch
use master;

-- drop and recreate the 'DataWareHouse' database
if exists(select 1 from sys.databases where name='DataWareHouse')
begin
  alter database DataWareHouse set SINGLE_USER with rollback immediate;
  drop database DataWareHouse;
end;

-- Creating the Database
create database DataWareHouse;
go
-- Selecting the Database
use DataWareHouse;

go
-- Creating the Schemas
create schema bronze;
go
create schema silver;
go
create schema gold;

