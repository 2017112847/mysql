create database green;
create user 'green'@'%' identified by '1234';

grant all privileges on green.* to 'green'@'%';
flush privileges;

DROP TRIGGER IF EXISTS course_before_insert;
DROP TRIGGER IF EXISTS enrollment_before_insert;
DROP TRIGGER IF EXISTS student_before_insert;
DROP TRIGGER IF EXISTS users_before_insert;
DROP TRIGGER IF EXISTS professor_before_insert;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS college;
DROP TABLE IF EXISTS sequence_table;

use green;

CREATE TABLE sequence_table (
    name VARCHAR(50) PRIMARY KEY,
    value BIGINT NOT NULL
);

-- 초기값 세팅 (원하면 INSERT로 각 키에 맞게 등록)
INSERT INTO sequence_table (name, value) VALUES
('course_cs_seq', 0),
('enrollment_en_no_seq', 0),
('student_std_seq', 0),
('users_us_id_seq', 0),
('professor_pro_seq', 0);


CREATE TABLE college (
    college VARCHAR(20) NOT NULL,
    PRIMARY KEY (college)
);

CREATE TABLE department (
    dep_no INT NOT NULL,
    college VARCHAR(20) NOT NULL,
    dep_name VARCHAR(20) NOT NULL,
    dep_eng_name VARCHAR(50),
    dep_est_date DATE,
    dep_king VARCHAR(20),
    dep_hp CHAR(12),
    dep_office VARCHAR(50),
    PRIMARY KEY (dep_no),
    FOREIGN KEY (college) REFERENCES college(college)
);

CREATE TABLE professor (
    pro_no BIGINT NOT NULL,
    pro_jumin CHAR(14) NOT NULL UNIQUE,
    pro_name VARCHAR(50) NOT NULL,
    pro_eng_name VARCHAR(50),
    pro_gen CHAR(1) NOT NULL,
    pro_nation VARCHAR(20),
    pro_hp VARCHAR(15),
    pro_email VARCHAR(100),
    pro_addr VARCHAR(50),
    pro_univ VARCHAR(30),
    dep_no INT NOT NULL,
    pro_grad_date DATE,
    pro_degree VARCHAR(20),
    pro_appoint_date DATE,
    pro_position VARCHAR(50),
    pro_status VARCHAR(20),
    pro_seq INT NOT NULL,
    PRIMARY KEY (pro_no),
    FOREIGN KEY (dep_no) REFERENCES department(dep_no)
);

CREATE TABLE student (
    std_no BIGINT NOT NULL,
    std_jumin CHAR(14) NOT NULL UNIQUE,
    std_name VARCHAR(30) NOT NULL,
    std_eng_name VARCHAR(30),
    std_gen CHAR(1) NOT NULL,
    std_nation VARCHAR(30) DEFAULT '한국',
    std_hp CHAR(13),
    std_email VARCHAR(30),
    std_addr VARCHAR(50),
    dep_no INT NOT NULL,
    pro_no BIGINT NOT NULL,
    std_seq INT,
    std_ent INT NOT NULL,
    std_ent_grade INT,
    std_ent_sem INT,
    std_status VARCHAR(20),
    PRIMARY KEY (std_no),
    FOREIGN KEY (dep_no) REFERENCES department(dep_no),
    FOREIGN KEY (pro_no) REFERENCES professor(pro_no)
);

CREATE TABLE course (
    cs_id BIGINT NOT NULL,
    dep_no INT NOT NULL,
    cs_grade INT,
    cs_credit INT,
    cs_dist VARCHAR(20),
    pro_no BIGINT NOT NULL,
    cs_name VARCHAR(50) NOT NULL,
    cs_info VARCHAR(100),
    cs_year INT NOT NULL,
    cs_sem INT NOT NULL,
    cs_time VARCHAR(20),
    cs_weekday VARCHAR(30),
    cs_eval VARCHAR(50),
    cs_book VARCHAR(100),
    cs_room VARCHAR(30),
    cs_max INT,
    cs_seq INT NOT NULL,
    PRIMARY KEY (cs_id),
    FOREIGN KEY (dep_no) REFERENCES department(dep_no),
    FOREIGN KEY (pro_no) REFERENCES professor(pro_no)
);

CREATE TABLE enrollment (
    en_no BIGINT NOT NULL,
    cs_id BIGINT NOT NULL,
    std_no BIGINT NOT NULL,
    score INT,
    grade CHAR(2),
    PRIMARY KEY (en_no),
    FOREIGN KEY (cs_id) REFERENCES course(cs_id),
    FOREIGN KEY (std_no) REFERENCES student(std_no)
);
ALTER TABLE enrollment MODIFY en_no BIGINT DEFAULT NULL;

CREATE TABLE users (
    us_id BIGINT NOT NULL,
    us_pass VARCHAR(20) NOT NULL,
    us_name VARCHAR(30) NOT NULL,
    us_hp CHAR(13),
    us_email VARCHAR(50) NOT NULL,
    us_addr VARCHAR(50),
    PRIMARY KEY (us_id)
);



DELIMITER //
CREATE TRIGGER course_before_insert
BEFORE INSERT ON course
FOR EACH ROW
BEGIN
  DECLARE next_val BIGINT;

  IF NEW.cs_seq IS NULL THEN
    UPDATE sequence_table 
      SET value = value + 1 
      WHERE name = 'course_cs_seq';

    SELECT value INTO next_val 
      FROM sequence_table 
      WHERE name = 'course_cs_seq';

    SET NEW.cs_seq = next_val;
  END IF;

  SET NEW.cs_id =  (NEW.dep_no * 100000000)
                 + (NEW.cs_year * 10000)
                 + (NEW.cs_sem * 1000)
                 + NEW.cs_seq;
END;
//
DELIMITER ;



DELIMITER //
CREATE TRIGGER enrollment_before_insert
BEFORE INSERT ON enrollment
FOR EACH ROW
BEGIN
  DECLARE next_val BIGINT;

  IF NEW.en_no IS NULL THEN
    UPDATE sequence_table SET value = value + 1 WHERE name='enrollment_en_no_seq';
    SELECT value INTO next_val FROM sequence_table WHERE name='enrollment_en_no_seq';
    SET NEW.en_no = next_val;
  END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER student_before_insert
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
  DECLARE next_val BIGINT;

  IF NEW.std_seq IS NULL THEN
    UPDATE sequence_table 
      SET value = value + 1 
      WHERE name = 'student_std_seq';

    SELECT value INTO next_val 
      FROM sequence_table 
      WHERE name = 'student_std_seq';

    SET NEW.std_seq = next_val;
  END IF;

  SET NEW.std_no = (NEW.std_ent * 1000000)
                 + (NEW.dep_no * 10000)
                 + NEW.std_seq;
END;
//
DELIMITER ;





DELIMITER //
CREATE TRIGGER users_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  DECLARE next_val BIGINT;

  IF NEW.us_id IS NULL OR NEW.us_id = 0 THEN
    UPDATE sequence_table SET value = value + 1 WHERE name='users_us_id_seq';
    SELECT value INTO next_val FROM sequence_table WHERE name='users_us_id_seq';
    SET NEW.us_id = next_val;
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER professor_before_insert
BEFORE INSERT ON professor
FOR EACH ROW
BEGIN
  DECLARE next_val BIGINT;

  IF NEW.pro_seq IS NULL THEN
    UPDATE sequence_table 
      SET value = value + 1 
      WHERE name = 'professor_pro_seq';

    SELECT value INTO next_val 
      FROM sequence_table 
      WHERE name = 'professor_pro_seq';

    SET NEW.pro_seq = next_val;
  END IF;

  SET NEW.pro_no = (YEAR(NEW.pro_appoint_date) * 1000000)
                 + (NEW.dep_no * 10000)
                 + NEW.pro_seq;
END;
//
DELIMITER ;

#-----------------------------------------------------
#공지사항 db
CREATE TABLE IF NOT EXISTS article (
  ano INT auto_increment,
  title VARCHAR(60) NOT NULL,
  content VARCHAR(150) NOT NULL,
  file_cnt INT NULL DEFAULT 0,
  hit_cnt INT NULL DEFAULT 0,
  writer VARCHAR(45) NOT NULL,
  wdate DATE NOT NULL,
  wdist INT NOT NULL,
  PRIMARY KEY (ano)
  );

insert into article (title, content, writer, wdate, wdist) values 
('의료,인공지능 융합인재 양성사업단 사업설명회', '그린대학교 의료인공지능융합인재양성사업단에서 「2025 의료 인공지능 특화 융합인재 양성 사업」 참여 학부생 모집을 위해 학부생을 대상으로 설명회를 개최합니다. 1. 일시 및 장소  가. 인문사회캠퍼스 : 2025년 5월 27일 화요일 오후 6시, 호암관 1층 하이브리드 강의실(50106)  나. 자연과학캠퍼스 : 2025년 5월 28일 수요일 오후 6시, 의학관 3층 AI빅데이터 강의실(713304) 2. 참가신청  가. 대상 : 의료 인공지능에 관심있는 성균관대학교 학부생 누구나  나. 신청 : 네이버폼 작성 및 제출(https://naver.me/Ig4fxaqd) *포스터 속 QR코드로도 접속 가능  다. 신청기간 : 2025년 5월 26일 월요일 오후 2시까지  3. 문의 : 그린대학교 의료인공지능융합인재양성사업단 (medicalai@green.edu)  관심있는 학생들의 많은 참여 바랍니다.  감사합니다.', '학사지원실', curdate(), 1);
insert into article (title, content, writer, wdate, wdist) values 
('2025학년도 신입학 추가모집 모집요강 및 모집인원 공지', '1. 전형별 모집인원: 17명 (2025. 2. 24. 15:43기준) ※ 모집인원은 원서접수 중에도 변동될 수 있습니다. ▶ 입학 안내 홈페이지를 수시로 확인해 주세요!! ※ 한림대학교 내 중복지원은 불가하며, 1개 모집단위에만 지원 가능합니다.  2. 전형 일정     ■ 원서접수 : 2025. 2. 21.(금) 09:00 ~ 2. 24.(월) 20:00 까지      ■ 모집인원 : 수시·정시 미충원인원(실시간 변경 인원 홈페이지 안내)     ■ 최초 합격자 발표(개별 전화통보) : 2. 25.(화) 14:00 ~     ■ 최초 합격자 등록 : 발표이후 ~ 2. 26.(수) 09:00   3. 학기 개시일: 2025. 3. 1.(토)', '담당자', curdate(), 2);
insert into article (title, content, writer, wdate, wdist) values 
('2025학년도 신입학 2차 추가모집 모집요강 및 모집인원 공지', '2차 추가모집 관해 공지드립니다.     1. 전형별 모집인원: 17명 (2025. 2. 24. 15:43기준) ※ 모집인원은 원서접수 중에도 변동될 수 있습니다. ▶ 입학 안내 홈페이지를 수시로 확인해 주세요!! ※ 한림대학교 내 중복지원은 불가하며, 1개 모집단위에만 지원 가능합니다.  2. 전형 일정     ■ 원서접수 : 2025. 2. 21.(금) 09:00 ~ 2. 24.(월) 20:00 까지      ■ 모집인원 : 수시·정시 미충원인원(실시간 변경 인원 홈페이지 안내)     ■ 최초 합격자 발표(개별 전화통보) : 2. 25.(화) 14:00 ~     ■ 최초 합격자 등록 : 발표이후 ~ 2. 26.(수) 09:00   3. 학기 개시일: 2025. 3. 1.(토)', '담당사', curdate(), 2);
insert into article (title, content, writer, wdate, wdist) values 
('2025학년도 신입학 2차 추가모집 모집요강 및 모집인원 공지', '2차 추가모집 관해 공지드립니다.     1. 전형별 모집인원: 17명 (2025. 2. 24. 15:43기준) ※ 모집인원은 원서접수 중에도 변동될 수 있습니다. ▶ 입학 안내 홈페이지를 수시로 확인해 주세요!! ※ 한림대학교 내 중복지원은 불가하며, 1개 모집단위에만 지원 가능합니다.  2. 전형 일정     ■ 원서접수 : 2025. 2. 21.(금) 09:00 ~ 2. 24.(월) 20:00 까지      ■ 모집인원 : 수시·정시 미충원인원(실시간 변경 인원 홈페이지 안내)     ■ 최초 합격자 발표(개별 전화통보) : 2. 25.(화) 14:00 ~     ■ 최초 합격자 등록 : 발표이후 ~ 2. 26.(수) 09:00   3. 학기 개시일: 2025. 3. 1.(토)', '담당사', curdate(), 2);
insert into article (title, content, writer, wdate, wdist) values 
('2025학년도 신입학 2차 추가모집 모집요강 및 모집인원 공지', '3차 추가모집 관해 공지드립니다.     1. 전형별 모집인원: 17명 (2025. 2. 24. 15:43기준) ※ 모집인원은 원서접수 중에도 변동될 수 있습니다. ▶ 입학 안내 홈페이지를 수시로 확인해 주세요!! ※ 한림대학교 내 중복지원은 불가하며, 1개 모집단위에만 지원 가능합니다.  2. 전형 일정     ■ 원서접수 : 2025. 2. 21.(금) 09:00 ~ 2. 24.(월) 20:00 까지      ■ 모집인원 : 수시·정시 미충원인원(실시간 변경 인원 홈페이지 안내)     ■ 최초 합격자 발표(개별 전화통보) : 2. 25.(화) 14:00 ~     ■ 최초 합격자 등록 : 발표이후 ~ 2. 26.(수) 09:00   3. 학기 개시일: 2025. 3. 1.(토)', '담당사', curdate(), 3);
#--------------------------------------------------
USE green;

CREATE TABLE IF NOT EXISTS counsel (
  ano INT auto_increment,
  title VARCHAR(60) NOT NULL,
  content VARCHAR(150) NOT NULL,
  file_cnt INT NULL DEFAULT 0,
  hit_cnt INT NULL DEFAULT 0,
  writer VARCHAR(45) NOT NULL,
  wdate DATE NOT NULL,
  wdist INT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT '답변중',
  PRIMARY KEY (ano)
  );
UPDATE counsel
SET title = '수시'
WHERE title = '정시' AND writer = '홍길동' AND wdist = 3;
INSERT INTO counsel (title, content, writer, wdate, wdist)
VALUES ('정시모집 관련해 문의드립니다.', '정시 원서 제출 방법 문의드립니다.', '홍길동', CURDATE(), 3);
INSERT INTO counsel (title, content, writer, wdate, wdist)
VALUES ('정시모집 관련해 문의드립니다.', '정시 원서 제출 방법 문의드립니다.', '홍길동', CURDATE(), 3);
INSERT INTO counsel (title, content, writer, wdate, wdist)
VALUES ('정시모집 관련해 문의드립니다.', '정시 원서 제출 방법 문의드립니다.', '홍길동', CURDATE(), 3);


SELECT * FROM counsel;
INSERT INTO counsel (title, content, writer, wdate, wdist) VALUES
('정시', '정시모집 관련해 문의드립니다.', '홍길동', CURDATE(), 3);
INSERT INTO counsel (title, content, writer, wdate, wdist) VALUES
('정시', '정시모집 관련해 문의드립니다.', '홍길동', CURDATE(), 3);
INSERT INTO counsel (title, content, writer, wdate, wdist) VALUES
('정시', '정시모집 관련해 문의드립니다.', '홍길동', CURDATE(), 3);



insert into college values ('인문사회대학');
insert into college values ('자연과학대학');
insert into college values ('공과대학');
insert into college values ('사범대학');
insert into college values ('대학원');


insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (10, '인문사회대학', '국어국문학과', '김국어', '051-123-1001');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (11, '인문사회대학', '영어영문학과', '김영어', '051-123-1002');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (12, '인문사회대학', '일어일문학과', '김일어', '051-123-1003');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (13, '인문사회대학', '중어중문학과', '김중어', '051-123-1004');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (14, '인문사회대학', '역사학과', '김역사', '051-123-1005');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (15, '인문사회대학', '경제학과', '김경제', '051-123-1006');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (16, '인문사회대학', '경영학과', '김경영', '051-123-1007');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (17, '인문사회대학', '법학과', '김법학', '051-123-1008');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (18, '인문사회대학', '철학과', '김철학', '051-123-1009');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (19, '인문사회대학', '정치외교학과', '김정치', '051-123-1010');

insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (20, '자연과학대학', '수학과', '김수학', '051-123-2001');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (21, '자연과학대학', '물리학과', '김물리', '051-123-2002');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (22, '자연과학대학', '화학과', '김화학', '051-123-2003');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (23, '자연과학대학', '천문학과', '김천문', '051-123-2004');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (24, '자연과학대학', '지구과학학과', '김지구', '051-123-2005');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (25, '자연과학대학', '생명과학과', '김생명', '051-123-2006');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (26, '자연과학대학', '미생물학과', '김생물', '051-123-2007');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (27, '자연과학대학', '해양학과', '김해양', '051-123-2008');

insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (30, '공과대학', '기계공학과', '김기계', '051-123-3001');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (31, '공과대학', '전자공학과', '김전자', '051-123-3002');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (32, '공과대학', '전기공학과', '김전기', '051-123-3003');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (33, '공과대학', '컴퓨터공학과', '김컴공', '051-123-3004');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (34, '공과대학', '건축공학과', '김건축', '051-123-3005');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (35, '공과대학', '재료공학과', '김재료', '051-123-3006');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (36, '공과대학', '화학공학과', '김화학', '051-123-3007');

insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (40, '사범대학', '국어교육과', '김국어', '051-123-4001');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (41, '사범대학', '영어교육과', '김영어', '051-123-4002');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (42, '사범대학', '수학교육과', '김수학', '051-123-4003');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (43, '사범대학', '윤리학과', '김윤리', '051-123-4004');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (44, '사범대학', '교육학과', '김교육', '051-123-4005');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (45, '사범대학', '사회교육과', '김사회', '051-123-4006');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (46, '사범대학', '역사교육과', '김역사', '051-123-4007');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (47, '사범대학', '체육교육과', '김체육', '051-123-4008');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (48, '사범대학', '특수교육과', '김특수', '051-123-4009');

insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (50, '대학원', '경영대학원', '김경영', '051-123-5001');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (51, '대학원', '경제대학원', '김경제', '051-123-5002');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (52, '대학원', '행정대학원', '김행정', '051-123-5003');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (53, '대학원', '교육대학원', '김교육', '051-123-5004');
insert into department (dep_no, college, dep_name, dep_king, dep_hp)values (54, '대학원', '산업대학원', '김산업', '051-123-5005');


insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이자바', '700526-1111111', 33, 'M', '2021-01-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이자료', '700526-1111112', 33, 'F', '2022-02-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이미적', '700526-1111113', 42, 'M', '2021-01-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이기하', '700526-1111114', 42, 'F', '2022-02-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이칸트', '700526-1111115', 18, 'M', '2021-01-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이니체', '700526-1111116', 18, 'F', '2022-02-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이영국', '700526-1111117', 41, 'F', '2021-01-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이미국', '700526-1111118', 41, 'M', '2022-02-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이고전', '700526-1111119', 10, 'M', '2021-01-26');
insert into professor (pro_name, pro_jumin, dep_no, pro_gen, pro_appoint_date) values ('이현대', '700526-1111110', 10, 'F', '2022-02-26');


insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('040526-1111111', '박컴공', 'F', 33, 2021330001, 2023);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('030526-1111112', '박컴학', 'M', 33, 2022330002, 2022);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('040526-1111113', '박이산', 'F', 42, 2021420003, 2023);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('020526-1111114', '박확통', 'M', 42, 2022420004, 2021);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('050526-1111115', '박데카', 'F', 18, 2021180005, 2024);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('040526-1111116', '박플라', 'M', 18, 2022180006, 2023);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('040526-1111117', '박하이', 'F', 41, 2021410007, 2023);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('020526-1111118', '박바이', 'M', 41, 2022410008, 2021);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('040526-1111119', '박애란', 'F', 10, 2021100009, 2023);
insert into student (std_jumin, std_name, std_gen, dep_no, pro_no, std_ent) values ('000526-1111110', '박유정', 'M', 10, 2022100010, 2019);


insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('컴퓨터학개론', 1, 3, 2025, 1, 33, 2021330001);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('자바 프로그래밍', 2, 3, 2025, 1, 33, 2022330002);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('이산수학', 1, 3, 2025, 1, 42, 2021420003);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('확률과 통계', 1, 3, 2025, 1, 42, 2022420004);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('서양중세철학사', 2, 3, 2025, 1, 18, 2021180005);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('철학고전 읽기와 토론', 1, 2, 2025, 1, 18, 2022180006);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('미디어 영문학', 4, 2, 2025, 1, 41, 2021410007);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('영미단편소설', 1, 3, 2025, 1, 41, 2022410008);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('한국어학일반론', 3, 3, 2025, 1, 10, 2021100009);
insert into course (cs_name, cs_grade, cs_credit, cs_year, cs_sem, dep_no, pro_no) values ('현대소설론', 1, 3, 2025, 1, 10, 2022100010);


insert into enrollment (cs_id, std_no, score, grade)values (3320251001, 2023330001, 95, 'A');
insert into enrollment (cs_id, std_no, score, grade)values (3320251002, 2022330002, 99, 'A+');
insert into enrollment (cs_id, std_no, score, grade)values (4220251003, 2023420003, 86.2, 'B');
insert into enrollment (cs_id, std_no, score, grade)values (4220251004, 2021420004, 92.6, 'A');
insert into enrollment (cs_id, std_no, score, grade)values (1820251005, 2024180005, 56.2, 'F');
insert into enrollment (cs_id, std_no, score, grade)values (1820251006, 2023180006, 80, 'B');
insert into enrollment (cs_id, std_no, score, grade)values (4120251007, 2023410007, 88.8, 'B+');

INSERT INTO users (us_id, us_pass, us_name, us_hp, us_email, us_addr)VALUES (NULL, '1234', '홍길동', '010-1234-1001', 'honng1001@naver.com', '부산시 부전동');
INSERT INTO users (us_id, us_pass, us_name, us_hp, us_email, us_addr)VALUES (NULL, '1234', '김길동', '010-1234-1002', 'kim1001@gmail.com', '부산시 우암동');
INSERT INTO users (us_id, us_pass, us_name, us_hp, us_email, us_addr)VALUES (NULL, '1234', '이길동', '010-1234-1003', 'lee1001@hanmail.net', '부산시 구서동');