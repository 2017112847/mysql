-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`department` (
  `depno` INT NOT NULL,
  `depname` VARCHAR(20) NOT NULL,
  `deptel` CHAR NOT NULL,
  PRIMARY KEY (`depno`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`professor` (
  `prono` CHAR not NULL,
  `depno` INT NOT NULL,
  `proname` VARCHAR(20) NOT NULL,
  `projumin` CHAR NOT NULL,
  `prohp` CHAR NOT NULL,
  `proemail` VARCHAR(100) NOT NULL,
  `proaddr` VARCHAR(100) NULL,
  PRIMARY KEY (`prono`),
  INDEX `fk_professor_department1_idx` (`depno` ASC) VISIBLE,
  UNIQUE INDEX `projumin_UNIQUE` (`projumin` ASC) VISIBLE,
  UNIQUE INDEX `prohp_UNIQUE` (`prohp` ASC) VISIBLE,
  CONSTRAINT `fk_professor_department1`
    FOREIGN KEY (`depno`)
    REFERENCES `mydb`.`department` (`depno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student` (
  `stdno` CHAR(8) NOT NULL,
  `depno` INT NOT NULL,
  `prono` CHAR NOT NULL,
  `stdname` VARCHAR(20) NOT NULL,
  `stdjumin` CHAR NOT NULL,
  `stdhp` CHAR NOT NULL,
  `stdemail` VARCHAR(100) NULL,
  `stdaddr` VARCHAR(100) NULL,  
  PRIMARY KEY (`stdno`),
  INDEX `fk_student_professor_idx` (`professor_prono` ASC) VISIBLE,
  INDEX `fk_student_department1_idx` (`depno` ASC) VISIBLE,
  UNIQUE INDEX `stdjumin_UNIQUE` (`stdjumin` ASC) VISIBLE,
  UNIQUE INDEX `stdhp_UNIQUE` (`stdhp` ASC) VISIBLE,
  UNIQUE INDEX `stdemail_UNIQUE` (`stdemail` ASC) VISIBLE,
  CONSTRAINT `fk_student_professor`
    FOREIGN KEY (`professor_prono`)
    REFERENCES `mydb`.`professor` (`prono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_department1`
    FOREIGN KEY (`depno`)
    REFERENCES `mydb`.`department` (`depno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE enrollment DROP FOREIGN KEY fk_enrollment_student1;


ALTER TABLE student MODIFY stdjumin CHAR(14) NOT NULL;
ALTER TABLE student MODIFY stdhp CHAR(13) NOT NULL;
ALTER TABLE student MODIFY prono CHAR(10) NOT NULL;
ALTER TABLE student MODIFY prono CHAR(10) NOT NULL;


ALTER TABLE enrollment
ADD CONSTRAINT fk_enrollment_student1
FOREIGN KEY (stdno)
REFERENCES student(stdno)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
-- -----------------------------------------------------
-- Table `mydb`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`course` (
  `csno` CHAR NOT NULL,
  `prono` CHAR NOT NULL,
  `csname` VARCHAR(45) NOT NULL,
  `cscredit` INT NOT NULL,
  `cstime` INT NOT NULL,
  `csclass` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`csno`, `prono`),
  INDEX `fk_course_professor1_idx` (`prono` ASC) VISIBLE,
  CONSTRAINT `fk_course_professor1`
    FOREIGN KEY (`prono`)
    REFERENCES `mydb`.`professor` (`prono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`enrollment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`enrollment` (
  `stdno` CHAR(10) NOT NULL,
  `csno` CHAR(10) NOT NULL,
  `prono` CHAR(10) NOT NULL,
  `scoreattd` INT NULL,
  `scoremid` INT NULL,
  `scorefinal` INT NULL,
  `scoretotal` INT NULL,
  `scoregrade` CHAR(2) NULL,
  PRIMARY KEY (`stdno`, `csno`, `prono`),
  INDEX `fk_enrollment_course1_idx` (`csno`, `prono`) VISIBLE,
  INDEX `fk_enrollment_student1_idx` (`stdno`) VISIBLE,
  CONSTRAINT `fk_enrollment_course1`
    FOREIGN KEY (`csno`, `prono`)
    REFERENCES `mydb`.`course` (`csno`, `prono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_enrollment_student1`
    FOREIGN KEY (`stdno`)
    REFERENCES `mydb`.`student` (`stdno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO student VALUES ('20101001', 10, 'P10101', '정우성', '760121-1234567', '010-1101-7601', NULL, '서울', 'P10101');
INSERT INTO student VALUES ('20101002', 10, 'P10101', '이정재', '750611-1234567', '010-1102-7506', NULL, '서울', 'P10101');
INSERT INTO student VALUES ('20111011', 11, 'P11103', '전지현', '890530-1234567', '010-1103-8905', 'jjh@naver.com', NULL, 'P11103');
INSERT INTO student VALUES ('20111013', 11, 'P11103', '이나영', '790413-1234567', '010-2101-7904', 'lee@naver.com', '대전', 'P11103');
INSERT INTO student VALUES ('20111014', 11, 'P11104', '원빈', '660912-1234567', '010-2104-6609', 'one@daum.net', '대전', 'P11104');
INSERT INTO student VALUES ('21221010', 22, 'P22110', '장동건', '790728-1234567', '010-3101-7907', 'jang@naver.com', '대구', 'P22110');
INSERT INTO student VALUES ('21231002', 23, 'P23102', '고소영', '840615-1234567', '010-4101-8406', 'goso@daum.net', NULL, 'P23102');
INSERT INTO student VALUES ('22311011', 31, 'P31104', '김연아', '651021-1234567', '010-5101-6510', 'yuna@daum.net', '대구', 'P31104');
INSERT INTO student VALUES ('22311014', 31, 'P31104', '유재석', '721128-1234567', '010-6101-7211', NULL, '부산', 'P31104');
INSERT INTO student VALUES ('22401001', 40, 'P40101', '강호동', '920907-1234567', '010-7103-9209', NULL, '부산', 'P40101');
INSERT INTO student VALUES ('22401002', 40, 'P40101', '조인성', '891209-1234567', '010-7104-8912', 'join@gmail.com', '광주', 'P40101');
INSERT INTO student VALUES ('22421003', 42, 'P42103', '강동원', '770314-1234567', '010-8101-7703', 'dong@naver.com', '광주', 'P42103');



