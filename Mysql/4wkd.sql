create table member (
uid varchar(10) primary key,
name varchar(10) not null,
hp varchar(13) not null unique,
pos varchar(10) not null default '사원',
dep int default null,
rdate datetime not null );

create table department(
depno int primary key,
name varchar(10) not null,
tel varchar(12) not null );

create table sales(
seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
uid varchar(10) not null,
year year not null,
month int not null,
sale int default null);

insert into member values ('a101', '박혁거세', '010-1234-1001', '부장', '101', '2020-11-19 11:39:48');
insert into member values ('a102', '김유신', '010-1234-1002', '차장', '101', '2020-11-19 11:39:48');
insert into member values ('a103', '김춘추', '010-1234-1003', '사원', '101', '2020-11-19 11:39:48');
insert into member values ('a104', '장보고', '010-1234-1004', '대리', '102', '2020-11-19 11:39:48');
insert into member values ('a105', '강감찬', '010-1234-1005', '과장', '102', '2020-11-19 11:39:48');
insert into member values ('a106', '이성계', '010-1234-1006', '차장', '103', '2020-11-19 11:39:48');
insert into member values ('a107', '정철', '010-1234-1007', '차장', '103', '2020-11-19 11:39:48');
insert into member values ('a108', '이순신', '010-1234-1008', '부장', '104', '2020-11-19 11:39:48');
insert into member values ('a109', '허균', '010-1234-1009', '부장', '104', '2020-11-19 11:39:48');
insert into member values ('a110', '정약용', '010-1234-1010', '사원', '105', '2020-11-19 11:39:48');
insert into member values ('a111', '박지원', '010-1234-1011', '사원', '105', '2020-11-19 11:39:48');


insert into sales (uid, year, month, sale) values ( 'a101', '2018', '1' , '98100');
insert into sales (uid, year, month, sale) values ( 'a102', 2018, 1 , 136000);
insert into sales (uid, year, month, sale) values ( 'a103', '2018', '1' , '80100');
insert into sales (uid, year, month, sale) values ( 'a104', '2018', '1' , '78000');
insert into sales (uid, year, month, sale) values ( 'a105', '2018', '1' , '93000');
insert into sales (uid, year, month, sale) values ( 'a101', '2018', '2' , '23500');
insert into sales (uid, year, month, sale) values ( 'a102', '2018', '2' , '126000');
insert into sales (uid, year, month, sale) values ( 'a103', '2018', '2' , '18500');
insert into sales (uid, year, month, sale) values ( 'a105', '2018', '2' , '19000');
insert into sales (uid, year, month, sale) values ( 'a106', '2018', '2' , '53000');

drop table sales;

insert into sales (uid, year, month, sale) values ( 'a101', 2019, 1, 24000);
insert into sales (uid, year, month, sale) values ( 'a102', 2019, 1, 109000);
insert into sales (uid, year, month, sale) values ( 'a103', 2019, 1, 101000);
insert into sales (uid, year, month, sale) values ( 'a104', 2019, 1, 53500);
insert into sales (uid, year, month, sale) values ( 'a107', 2019, 1, 24000);
insert into sales (uid, year, month, sale) values ( 'a102', 2019, 2, 160000);
insert into sales (uid, year, month, sale) values ( 'a103', 2019, 2, 101000);
insert into sales (uid, year, month, sale) values ( 'a104', 2019, 2, 43000);
insert into sales (uid, year, month, sale) values ( 'a105', 2019, 2, 24000);
insert into sales (uid, year, month, sale) values ( 'a106', 2019, 2, 109000);

insert into sales (uid, year, month, sale) values ( 'a102', 2020, 1, 20100);
insert into sales (uid, year, month, sale) values ( 'a104', 2020, 1, 63000);
insert into sales (uid, year, month, sale) values ( 'a105', 2020, 1, 74000);
insert into sales (uid, year, month, sale) values ( 'a106', 2020, 1, 122000);
insert into sales (uid, year, month, sale) values ( 'a107', 2020, 1, 111000);
insert into sales (uid, year, month, sale) values ( 'a102', 2020, 2, 120000);
insert into sales (uid, year, month, sale) values ( 'a103', 2020, 2, 93000);
insert into sales (uid, year, month, sale) values ( 'a104', 2020, 2, 84000);
insert into sales (uid, year, month, sale) values ( 'a105', 2020, 2, 180000);
insert into sales (uid, year, month, sale) values ( 'a108', 2020, 2, 76000);

insert into department (depno, name, tel) values
(101, '영업1부', '051-512-1001'),
(102, '영업2부', '051-512-1002'),
(103, '영업3부', '051-512-1003'),
(104, '영업4부', '051-512-1004'),
(105, '영업5부', '051-512-1005'),
(106, '영업지원부', '051-512-1006'),
(107, '인사부', '051-512-1007');


select * from department;
select * from member where name ='김유신';
select * from member where pos= '차장' and dep=101;
select * from member where pos= '차장' or dep=101;
select * from member where name != '김춘추';
select * from member where name <> '김춘추';
select * from member where pos ='사원' or pos ='대리';
select * from member where pos IN ('사원','대리');
select * from member where dep IN(101,102,103);
select * from member where name like '%신';
select * from member where name like '김%';
select * from member where name like '김__';
select * from member where name like '_성_';
select * from member where name like '정_';
select * from sales where sale > 50000;
select * from sales where sale >= 50000 and sale < 100000 and month=1;
select * from sales where sale between 50000 and 100000;
select * from sales where sale not between 50000 and 100000;
select * from sales where year in (2020);
select * from sales where month in (1,2);

select * from sales order by sale;
select * from sales order by sale asc;
select * from sales order by sale desc;
select * from member order by name;
select * from member order by name desc;
select * from member order by rdate asc;
select * from sales where sale > 50000 order by sale desc;
select * from sales where sale > 50000 order by year, month, sale desc;

select * from sales limit 3;
select * from sales limit 0, 3;
select * from sales limit 1,2;
select * from sales limit 5, 3;
select * from sales order by sale desc limit 3,5;
select * from sales where sale < 50000 order by sale desc limit 3;
select * from sales where sale < 50000 order by year desc, month, sale desc limit 5;

select sum(sale) as 합계 from sales;
select avg(sale) as 평균 from sales;
select max(sale) as 최대값 from sales;
select min(sale) as 최솟값 from sales;
select ceiling(1.2);
select ceiling(1.8);
select floor(1.2);
select floor(1.8);
select round(1.2);
select round(1.8);
select rand();
select ceiling(rand()*10);
select count(sale) as 개수 from sales;
select count(*) as 갯수 from sales;
select left ('HelloWorld',5);
select right ('HelloWorld',5);
SELECT SUBSTRING('HelloWorld', 6, 5);
select concat('Hello','World');
select concat(uid,name,hp)from member where uid='a108';
select curdate();
select curtime();
select now();
insert into member values('a112','유관순','010-1234-1012', '대리', 107, now());


select sum(sale) as 2018년1월매출 from sales where year in (2018) and month in (2) ;
select sum(sale) as 2019년2월매출 , avg(sale) as 평균 from sales where sale > 50000 and year in (2019) and month in (2) ;
select min(sale) as 최소, max(sale) as 최대 from sales where year  in (2020) ;

select * from sales group by uid;
select * from sales group by year;
SELECT uid, COUNT(*) AS 건수 FROM Sales GROUP BY uid;
select uid, sum(sale) as 합계 from sales group by uid;
select uid, avg(sale) as 평균 from sales group by uid;

select uid, year, sum(sale) as 합계 from sales group by uid, year;
select uid, year, sum(sale) as 합계 from sales group by uid, year order by year asc, 합계 desc;
select uid, year, sum(sale) as 합계 from sales where sale >= 50000 group by uid, year order by 합계 desc;

select uid, sum(sale) as 합계 from sales group by uid having 합계 >= 200000;
select uid, year, sum(sale) as 합계 from sales where sale >= 100000 group by uid, year having 합계 >= 200000 order by 합계 desc;

create table sales2 like sales;
insert into sales2 select * from sales;
update sales2 set year = year + 3;

select * from sales union select * from sales2;
select * from sales where sale >= 100000 union select * from sales2 where sale >= 100000;
select uid, year, sale from sales union select uid, year, sale from sales2;
select uid, year, sum(sale) as 합계 from sales group by uid,year union select uid, year, sum(sale) as 합계
from sales2 group by uid,year order by year asc, 합계 desc;

select * from sales inner join member on sales.uid = member.uid;
select * from member inner join department on member.dep = department.depno;

select * from sales as a join member as b on a.uid=b.uid;
select * from member as a, department as b where a.dep = b.depno;

select a.seq, a.uid, sale, name ,pos from sales as a join member as b on a.uid = b.uid;
select a.seq, a.uid ,sale, name, pos from sales as a join member as b using (uid);
select a.seq, a.uid, sale, name, pos from sales as a join member as b on a.uid= b.uid where sale >= 100000;

select a.seq, a.uid, b.name, b.pos, year, sum(sale) as 합계 from sales as a join member as b on a.uid = b.uid
group by a.uid, a.year having 합계 >= 100000 
order by a.year asc, 합계 desc;