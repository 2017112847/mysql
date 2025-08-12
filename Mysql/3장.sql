create table user2(
uid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
addr VARCHAR(50));

INSERT INTO user2 VALUES ('z101', 'ava', 23,  'asdfasd');



CREATE TABLE user3 (
uid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
hp CHAR(13) UNIQUE,
addr VARCHAR(50));
insert into user3 values ('a101', 'qwe', 11, '010-4444-4444','wewewe');

CREATE TABLE parent (
pid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
birth CHAR(10),
addr VARCHAR(100));
insert into parent values('c101', 'fbrfb', 14, 'vccs');

CREATE TABLE child (
cid VARCHAR(10) PRIMARY KEY,
name VARCHAR(10),
hp char(13) unique,
parent varchar(10),
foreign key (parent) references parent (pid));
insert into child values('v101', 'jkjkj', '010-0101-1554', 'c101');

create table user4(
uid varchar(10) primary key,
name varchar(10) not null,
gender char(1),
age int default 1,
hp char(13) unique,
addr varchar(20) );

insert into user4 values ('g101', 'opop', 'M', 2, '010-8585-4112','uijik' );

CREATE TABLE User5(
seq INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL,
gender CHAR(1) CHECK (gender IN ('M', 'F')),
age INT DEFAULT 1 CHECK (age > 0 AND age < 100),
addr VARCHAR(20));

insert into user5 values ('1','v', 'M', 5, 'plmjd');