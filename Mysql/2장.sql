create table user2(
uid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
addr VARCHAR(50));

CREATE TABLE user3 (
uid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
hp CHAR(13) UNIQUE,
addr VARCHAR(50));

CREATE TABLE parent (
pid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
addr VARCHAR(100));

CREATE TABLE child (
cid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
hp char(13) unique,
parent varchar(10),
foreign key (parent) references parent (pid));

create table user4(
uid varchar(10) primary key,
name varchar(10) not null,
gender char(1),
age int default 1,
hp char(13) unique,
addr varchar(20) );

CREATE TABLE User5(
seq INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL,
gender CHAR(1) CHECK (gender IN ('M', 'F')),
age INT DEFAULT 1 CHECK (age > 0 AND age < 100),
addr VARCHAR(20));