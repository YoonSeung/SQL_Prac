INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7369, 'SMITH', 'CLERK', 7902, '1980/12/17', 800, 20);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '1981/02/20', 1600, 300, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) VALUES (7521, 'WARD', 'SALESMAN', 7698, '1981/02/22', 1250, 500, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7566, 'JONES', 'MANAGER', 7839, '1981/04/02', 2975, 20);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) VALUES (7654, 'MARTIN', 'SALESMAN', 7698, '1981/09/28', 1250, 1400, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7698, 'BLAKE', 'MANAGER', 7839, '1981/05/01', 2850, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7782, 'CLARK', 'MANAGER', 7839, '1981/06/09', 2450, 10);
INSERT INTO EMP (EMPNO, ENAME, JOB, HIREDATE, SAL, DEPTNO) VALUES (7839, 'KING', 'PRESIDENT', '1981/11/17', 5000, 10);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO) VALUES (7844, 'TURNER', 'SALESMAN', 7698, '1981/09/08', 1500, 0, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7900, 'JAMES', 'CLERK', 7698, '1981/12/03', 950, 30);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7902, 'FORD', 'ANALYST', 7566, '1981/12/03', 3000, 20);
INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, DEPTNO) VALUES (7934, 'MILLER', 'CLERK', 7782, '1982/01/23', 1300, 10);

DROP TABLE SG_Scores;
DROP TABLE Student;
DROP TABLE Course;
DROP TABLE Professor;
DROP TABLE department;

COMMIT;

create table department (
    dept_id   varchar2(10),
    dept_name varchar2(25),
    dept_Tel varchar2(12),
    constraint department_pk primary key(dept_id));

/* Student 테이블 생성*/    
CREATE  TABLE  Student (
Dept_ID        VARCHAR2(10),
Year           VARCHAR2(1),
Student_ID     VARCHAR2(7)     NOT NULL,
Name           VARCHAR2(10)    NOT NULL,
ID_Number      VARCHAR2(14)    NOT NULL    UNIQUE,
Address        VARCHAR2(40),
Telephone      VARCHAR2(12),
Email          VARCHAR2(20)    UNIQUE,
Status         VARCHAR2(1),
I_Date         DATE,
CONSTRAINT     Student_pk      PRIMARY KEY (Student_ID),
CONSTRAINT     Student_fk      FOREIGN KEY (Dept_ID)
               REFERENCES      Department);

/*professor 테이블생성*/                  
CREATE TABLE Professor(
Professor_ID     VARCHAR2(3),
NAME            VARCHAR2(10)        NOT NULL,
Position        VARCHAR2(20)        NOT NULL    CONSTRAINT Prof_ck
                CHECK (Position in ('총장','교수','부교수','조교수','전임강사')),
Dept_ID         VARCHAR2(10),
Telephone       VARCHAR2(12)        UNIQUE,
Email           VARCHAR2(20)        UNIQUE,
Duty            VARCHAR2(10),
Mgr             VARCHAR2(3),
CONSTRAINT  Professor_pk    PRIMARY KEY(Professor_ID),
CONSTRAINT  Professor_fk    FOREIGN KEY(Dept_ID)
            REFERENCES      Department);

/*course 테이블생성*/            
CREATE TABLE Course(
Course_ID       VARCHAR2(5),
Title           VARCHAR2(20)    NOT NULL,
C_Number        NUMBER(1)       NOT NULL,
Professor_ID    VARCHAR2(3),
Course_Fees     NUMBER(7),
CONSTRAINT  Course_pk   PRIMARY KEY(Course_ID),
CONSTRAINT  Course_fk   FOREIGN KEY(Professor_ID)
            REFERENCES Professor);
            
/*course 테이블생성*/  
CREATE TABLE SG_Scores(
Student_ID      VARCHAR2(7),
Course_ID       VARCHAR2(5),
Score           VARCHAR2(3),
Grade           VARCHAR2(2),
Score_Assigned DATE DEFAULT SYSDATE,
CONSTRAINT  sg_scores_pk   PRIMARY KEY(Student_ID,Course_ID),
CONSTRAINT  sgscores_fk1   FOREIGN KEY(Student_ID)
            REFERENCES  Student,
CONSTRAINT  sgscores_fk2   FOREIGN KEY(Course_ID)
            REFERENCES  Course);
            
            COMMIT;
INSERT INTO department VALUES ('컴공','컴퓨터공학과','765-4100');
INSERT INTO department VALUES ('정통','정보통신공학과','765-4200');
INSERT INTO department VALUES ('경영','경영학과','765-4400');
INSERT INTO department VALUES ('행정','세무행정학과','765-4500');

INSERT INTO Student  VALUES
('컴공','1','C1001','김대현','920101-1******','서울시 송파구', '01-932-9999', 
 'c1001@cyber.ac.kr',Null,'2010/03/01');
INSERT INTO Student  VALUES
('컴공','1','C1002','신지애','920521-2******','대전시 대덕구', '041-343-8838',
 'c10032cyber.ac.kr','H', '2010/03/01');
INSERT INTO Student  VALUES
('컴공','2','C0901','이정민','911109-2******','대구시 수성구', Null,          
 'c0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('컴공','2','C0902','박주영','920917-1******','경남 진해시',   '010-555-1616',          
 'c0902@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('컴공','3','C0801','한영삼','900708-1******','부산시 동래구', '016-999-0101',          
 'c0801@cyber.ac.kr',Null,'2008/03/05');
INSERT INTO Student  VALUES
('컴공','3','C0802','서희경','890205-2******','서울시 영등포구','010-333-0707',         
 'c0802@cyber.ac.kr',Null,'2008/03/05');
INSERT INTO Student  VALUES
('정통','1','T1001','김병호','891124-1******','대구시 달서구',  '011-222-0303',         
  Null,              Null,'2010/03/05');
INSERT INTO Student  VALUES
('정통','2','T0901','이정필','901117-1******','충남 천안시',    Null,          
 't0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('경영','1','B1001','김빛나','930422-2******','서울시 은평구',  Null,
  Null,              Null,'2010/03/05');
INSERT INTO Student  VALUES
('경영','2','B0901','배상문','761225-1******','대전시 동구읍',  Null,         
 'b0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('행정','1','A1001','이미나','901217-2******','전남 광양시',    '010-888-5050',         
  Null, Null,'2008/03/05');

/**********************************************************
*  Professor 테이블 견본 데이터
***********************************************************/
INSERT INTO Professor VALUES
 ('P11', '신기술', '교수',    '컴공','765-4111','ksshin@cyber.ac.kr','학과장','P00');
INSERT INTO Professor VALUES
 ('P12', '이대호', '부교수',  '컴공','765-4112','dhlee@cyber.ac.kr', Null,    'P11');
INSERT INTO Professor VALUES
 ('P13', '유소연', '전임강사','컴공','765-4113','syyoo@cyber.ac.kr',Null,    'P11');
INSERT INTO Professor VALUES
 ('P21', '박지성', '부교수',  '정통','765-4211','jspark@cyber.ac.kr','학과장','P00');
INSERT INTO Professor VALUES
 ('P22', '김하늘', '조교수',  '정통','765-4212','hnkim@cyber.ac.kr',  Null,    'P21');
INSERT INTO Professor VALUES
 ('P23', '이상혁', '전임강사','정통','765-4213','shlee@cyber.ac.kr', Null,    'P21');
INSERT INTO Professor VALUES
 ('P41', '안연홍', '부교수',  '경영','765-4411','yhahn@cyber.ac.kr','학과장', 'P00');
INSERT INTO Professor VALUES
 ('P51', '함영애', '부교수',  '행정','765-4511','yaham@cyber.ac.kr','학과장', 'P00');

/**********************************************************
*  Course 테이블 견본 데이터
***********************************************************/
INSERT INTO Course VALUES ('L1011','컴퓨터구조',    2,'P11',Null);
INSERT INTO Course VALUES ('L1012','웹디자인',      2, Null,20000);
INSERT INTO Course VALUES ('L1021','데이터베이스',  2,'P12',Null);
INSERT INTO Course VALUES ('L1022','정보통신개론',  2,'P21',Null);
INSERT INTO Course VALUES ('L1031','SQL',           3,'P12',30000);
INSERT INTO Course VALUES ('L1032','자바프로그래밍',3,'P13',Null);
INSERT INTO Course VALUES ('L1041','컴퓨터네트워크',2,'P21',Null);
INSERT INTO Course VALUES ('L1042','Delphi',        3,'P13',50000);
INSERT INTO Course VALUES ('L1051','웹서버관리',    2,'P11',Null);
INSERT INTO Course VALUES ('L1052','전자상거래',    3,'P22',30000);
INSERT INTO Course VALUES ('L2031','게임이론',      3,'P23',50000);
INSERT INTO Course VALUES ('L0011','TOEIC연구',     2, Null,Null);
INSERT INTO Course VALUES ('L0012','문학과 여행',   2, Null,Null);
INSERT INTO Course VALUES ('L0013','문학개론',      2, Null,Null);

/**********************************************************
*  SG_Scores 테이블 견본 데이터
***********************************************************/
INSERT INTO SG_Scores VALUES ('C0901','L1011', 97, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0902','L1011', 89, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0901','L1012', 82, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0902','L1012', 94, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0801','L1031', 96, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0802','L1031', 96, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0801','L1032', 78, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0802','L1032', 90, Null, '2009/06/29');
INSERT INTO SG_Scores VALUES ('C0901','L1021', 96, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0902','L1021', 86, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0901','L1022', 97, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0902','L1022', 87, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0801','L1041', 87, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0802','L1041', 99, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0801','L1042', 83, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0802','L1042', 98, Null, '2009/12/23');
INSERT INTO SG_Scores VALUES ('C0901','L1031', 85, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0902','L1031', 77, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0901','L1032', 93, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0902','L1032', 97, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0801','L1051', 87, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0802','L1051', 77, Null, '2010/06/28');
INSERT INTO SG_Scores VALUES ('C0801','L1052', 89, Null, '2010/06/28'); 
INSERT INTO SG_Scores VALUES ('C0802','L1052', 89, Null, '2010/06/28'); 
INSERT INTO SG_Scores VALUES ('C0901','L1041', 93, Null, '2010/12/27');
INSERT INTO SG_Scores VALUES ('C0902','L1041', 87, Null, '2010/12/27');
INSERT INTO SG_Scores VALUES ('C0901','L1042',105, Null, '2010/12/27');
INSERT INTO SG_Scores VALUES ('C0902','L1042', 98, Null, '2010/12/27');
INSERT INTO SG_Scores VALUES ('C0801','L0011', 68, Null, '2010/12/27');
INSERT INTO SG_Scores VALUES ('C0802','L0011', 98, Null, '2010/12/27');

COMMIT;

SELECT * FROM SG_Scores;

