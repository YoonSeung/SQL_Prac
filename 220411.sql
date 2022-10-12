--22년4월 11일 월요일
/*
 1. SG_Scores 테이블로부터 ‘C0901’ 학생의 성적[학번, 과목코드, 과목명, 성적]을 출력하시오.
*/
SELECT * 
FROM SG_Scores
WHERE Student_ID='C0901';

--Score_List view 생성
--단, SG_Scores와 Coures 이 두 개의 테이블에서 학번, 과목코드, 과목명, 과목별 점수만 구성된 view 생성
CREATE View Score_List
AS
    SELECT  Student_ID, Course_ID, Title, Score
    FROM    SG_Scores Join Course Using(Course_ID);
    
DESCRIB Score_List;

/*
 3. Course 테이블과 Professor 테이블로부터 교수별 담당 과목 수를 출력하는 뷰를 생성하고, 
이 뷰로부터 교수번호, 교수명, 과목 수를 출력하시오.
*/
CREATE VIEW Professor_Course_Count
(Professor_ID, Name, Course_Cnt)
AS
    SELECT  Professor_ID, Name, COUNT(*)
    FROM   Professor Join Course USING(Professor_ID)
    GROUP BY Professor_ID, Name;

 /*
 4. Student 테이블로부터 ‘컴공’학과 학생을 위한 Student_Computer 뷰를 생성하고, 뷰로부
터 (학과코드, 학년, 학번, 성명, 주민등록번호, 전화번호)를 출력하시오.
*/
CREATE View Student_Computer
AS
    SELECT  DEPT_ID, Year, Student_ID, Name, ID_Number, Telephone
    FROM    Student
    WHERE   DEPT_ID = '컴공';
    
-- (추가문제) 뷰에 내용 삽입 및 확인
INSERT INTO Student_Computer
VALUES('컴공', 2, 'C0905', '강미나', '910909-2******','011-999-1111');

SELECT * FROM Student_Computer
WHERE Student_ID = 'C0905';

--뷰에 내용삽입하면 테이블에도 내용이 들어감 ( 뷰가 테이블과 한개로 연결되어있을때만)
SELECT * FROM Student
WHERE Student_ID = 'C0905';

-- 반대의 경우도 가능 ( 테이블에 내용 추가하고 뷰를 확인)
INSERT INTO Student (Dept_ID, Year, Student_ID, Name, ID_Number, Telephone)
VALUES('컴공', 3, 'C0932', '정은지', '940909-2******','011-999-1111');

SELECT * FROM Student_Computer
WHERE Student_ID = 'C0932';

/*
========================<2교시>================================
*/
SELECT * FROM USER_VIEWS; --현재 시스템에 생성된 뷰 목록 보기

/*
6. Student_Computer 뷰를 삭제하시오
*/
DROP VIEW Student_Computer;

/*
SG_Scores 테이블을 성적과 학점을 내림차순으로 출력
1 페이지에 출력할 성적 상위 자 10명(1위 ~ 10위)의 학번, 성명, 과목명, 학점수, 성적, 등급을 출력
*/
SELECT  Student_ID, Course_ID, Title, C_number, Score, Grade
FROM    sg_scores Join Course Using(Course_ID)
Order by Score DESC, C_Number DESC; --DESC 는 내림차순

SELECT ROWNUM "순위", a.*
FROM    (   SELECT  SG.Student_ID, Name, Title, C_Number, Score, Grade
            FROM    SG_Scores SG Join Course C
                        ON (SG.Course_ID = C.Course_ID)
                        Join Student S
                        ON (SG.Student_id = S.Student_ID)
            Order BY SG.Score DESC, C_Number DESC) a
WHERE   ROWNUM<=10;

/*
위 커리문에서 성적이 21 ~ 30 등에 해당하는 학생들 조회
*/
SELECT *
FROM (
    SELECT ROWNUM num, a.*
    FROM    (   SELECT  SG.Student_ID, Name, Title, C_Number, Score, Grade
                FROM    SG_Scores SG Join Course C
                            ON (SG.Course_ID = C.Course_ID)
                            Join Student S
                            ON (SG.Student_id = S.Student_ID)
                Order BY SG.Score DESC, C_Number DESC) a
)
WHERE num BETWEEN 21 AND 30;

/*
==============<3교시>=============================
*/
--DEPT_SEQ 시퀀스 생성 및 활용
CREATE SEQUENCE DEPT_SEQ;

SELECT  DEPT_SEQ.NEXTVAL, DEPT_ID, DEPT_Name
FROM    Department;

SELECT * FROM DEPARTMENT;

SELECT * FROM Computer_Student;

DELETE FROM Computer_Student;

CREATE SEQUENCE ST_SEQ
START WITH 920;

INSERT INTO Computer_Student
(Student_id, Dept_ID, Year, Name, ID_Number, Email)
VALUES
(CONCAT('C', LTRIM(TO_CHAR(ST_SEQ.NEXTVAL, '0999'))),'&학과','&학년','&성명','&주민번호','&메일주소');

DROP SEQUENCE DEPT_SEQ;


SELECT * FROM TAB;

SELECT * FROM USER_CATALOG;

SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'PROFESSOR'; -- 대소문자 구분하니까 주의 할것

COLUMN CONSTRAINT_NAME FORMAT A14
COLUMN SEARCH_CONDITION FORMAT A14
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'COURSE';

--참조키를 비활성화 시킴
ALTER TABLE Professor
DISABLE CONSTRAINT PROFESSOR_FK;

INSERT INTO professor
(Professor_ID, Name, Position, DEPT_ID, Telephone, Email)
VALues('S11', '강민민', '교수', '역사', '123-4567', null);

SELECT * FROM Professor;

--참조키를 활성화 시킴 ( 오류뜰꺼임 왜냐 이미 참조키 외의 값을 삽입해놔서 안됨 )
ALTER TABLE Professor
ENABLE CONSTRAINT PROFESSOR_FK;

-- 아래 조건 삭제후 위의 코드 실행하면 됨 
DELETE FROM Professor
WHERE Professor_ID = 'S11';

SELECT * FROM Professor;

SELECT * 
FROM USER_INDEXES;

SELECT * 
FROM USER_IND_COLUMNS;

--EMP 테이블 급여 칼럼에 IDX_EMP_SAL 라는 인덱스 생성
-- 생성된 인덱스 확인
-- 생성된 인덱스 삭제
CREATE INDEX IDX_EMP_SAL
ON  EMP(SAL);

SELECT * 
FROM USER_IND_COLUMNS
WHERE INDEX_NAME = 'IDX_EMP_SAL';

DROP INDEX IDX_EMP_SAL;

--EMP 테이블에서 사원번호, 사원명, 직책, 부서번호만 구성된 'VW_EMP20' 뷰 생성
--단 부서번호가 20인 사원들로만 구성되는 뷰로
CREATE VIEW VW_EMP20
AS
    SELECT EMPNO, ENAME , JOB, DEPTNO
    FROM   EMP
    WHERE DEPTNO = 20;

SELECT * FROM VW_EMP20;
--emp 테이블 데이터 조회하되 맨 앞에 ROWNUM이 표현되어 조회가 되어야 하고,
-- 급여별 내림차순으로 정렬되어 화면에 조회 출력(인라인뷰)

 SELECT ROWNUM num, E.*
    FROM    (   SELECT  *
                FROM   emp
                Order BY SAL DESC ) E;

DROP VIEW VW_EMP20;
DROP TABLE DEPT_TEMP;
DROP TABLE DEPT_TEMP2;
DROP TABLE EMP_TEMP;
DROP TABLE EMP_TEMP2;
DROP TABLE COURSE_TEMP;
DROP TABLE TEMP;


WITH E AS (SELECT * FROM EMP ORDER BY SAL DESC)
SELECT ROWNUM, E.*
FROM E
WHERE ROWNUM<=3;

CREATE TABLE DEPT_SEQUENCE
AS
    SELECT *
    FROM DEPT
    WHERE 1<>1;
    
CREATE SEQUENCE SEQ_DEPT
    INCREMENT BY 10
    START WITH 10
    MAXVALUE 90
    MINVALUE 0
    NOCYCLE
    CACHE 2;
    
/*
========================<5교시>==================================
*/
INSERT INTO DEPT_SEQUENCE
(DEPTNO, DNAME, LOC)
VALUES
(SEQ_DEPT.nextval,'DATABASE','SEOUL');

SELECT * FROM DEPT_SEQUENCE;
SELECT SEQ_DEPT.CURRVAL FROm DUAL;

INSERT INTO DEPT_SEQUENCE
(DEPTNO, DNAME, LOC)
VALUES
(SEQ_DEPT.nextval,'JAVA','SEOUL');

--씨퀀스 수정
ALTER SEQUENCE SEQ_DEPT
    INCREMENT BY 3
    MAXVALUE 99
    CYCLE;
    
SELECT * FROM USER_SEQUENCES;

INSERT INTO DEPT_SEQUENCE
(DEPTNO, DNAME, LOC)
VALUES
(SEQ_DEPT.nextval,'JSP','SEOUL');

--시퀀스 삭제 및 삭제 확인
DROP SEQUENCE SEQ_DEPT;
SELECT * FROM USER_SEQUENCES;

------------------------------------------
CREATE TABLE TABLE_UNIQUE (
    LOGIN_ID    VARCHAR2(20)    UNIQUE,
    LOGIN_PWD   VARCHAR2(20)    NOT NULL,
    TEL         VARCHAR2(20)
);

SELECT  OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM    USER_CONSTRAINTS
WHERE   TABLE_NAME = 'TABLE_UNIQUE';

INSERT INTO TABLE_UNIQUE
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
('TEST_ID_01', 'PWD01', '010-111-1111');

SELECT * FROM TABLE_UNIQUE;

INSERT INTO TABLE_UNIQUE
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
('TEST_ID_02', 'PWD01', '010-222-1111');

INSERT INTO TABLE_UNIQUE
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
(NULL, 'PWD01', '010-111-1111');

UPDATE  TABLE_UNIQUE
SET     LOGIN_ID='TEST_ID_03' -- 01로는 안됨 왜냐 이미 01 이 있기때문에
WHERE LOGIN_ID IS NULL;

ALTER TABLE TABLE_UNIQUE
MODIFY(TEL UNIQUE); -- 데이터 중복된 값이 있으면 안됨

------------------------------------------
CREATE TABLE TABLE_UNIQUE2(
    LOGIN_ID    VARCHAR2(20)    CONSTRAINT TBLUNQ2_LOGIN_ID UNIQUE,
    LOGIN_PWD   VARCHAR2(20)    CONSTRAINT TBLUNQ2_LOGIN_NN NOT NULL,
    TEL         VARCHAR2(20)
);

SELECT * 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TABLE_UNIQUE2';

ALTER TABLE TABLE_UNIQUE2
MODIFY(TEL CONSTRAINT TBLUNQ2_TEL_UNQ   UNIQUE);

UPDATE  TABLE_UNIQUE
SET     TEL = null;

SELECT * FROM TABLE_UNIQUE;

ALTER TABLE TABLE_UNIQUE
MODIFY(TEL  UNIQUE);

SELECT * 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TABLE_UNIQUE';
/*
=========================<6교시>===================================
*/

ALTER TABLE TABLE_UNIQUE2 -- 제약조건 이름 수정
RENAME CONSTRAINT TBLUNQ2_TEL_UNQ TO TEL_UNQ;

SELECT*
FROm USER_CONSTRAINTS
WHERE TABLE_NAME = 'TABLE_UNIQUE2';

ALTER TABLE TABLE_UNIQUE2 -- 제약조건 삭제
DROP CONSTRAINT TEL_UNQ;

DROP TABLE TABLE_UNIQUE;
DROP TABLE TABLE_UNIQUE2;

CREATE TABLE TABLE_PK(
    LOGIN_ID    VARCHAR2(20)    CONSTRAINT TBLPK_LGNID_PK PRIMARY KEY,
    LOGIN_PWD   VARCHAR2(20)    CONSTRAINT TBLPK2_LGNPW_NN  NOT NULL,
    TEL         VARCHAR2(20)
);

INSERT INTO TABLE_PK
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
('TEST_ID_01','PWD01','010-123-1234');

SELECT * FROM TABLE_PK;

INSERT INTO TABLE_PK
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
('TEST_ID_01','PWD02','010-234-2345');  -- 오류남 ID가 프라이머리 키

SELECT * FROM TABLE_PK;

INSERT INTO TABLE_PK
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
(NULL,'PWD01','010-123-1234'); -- 프라이머리키는 null값이여도 오류

SELECT * 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMP', 'DEPT');

CREATE TABLE DEPT_PK(
    DEPTNO      NUMBER(2)   CONSTRAINT DEPTFK_DEPTNO_PK PRIMARY KEY,
    DNAME       VARCHAR2(14),
    LOC         VARCHAR2(13)
);

CREATE TABLE EMP_FK(
    EMPNO       NUMBER(4)   CONSTRAINT EMPFK_EMPNO_PK PRIMARY KEY,
    ENAME       VARCHAR2(15),
    JOB         VARCHAR2(9),
    MGR         VARCHAR2(4),
    HIREDATE    DATE,
    SAL         NUMBER(7,2),
    COMM        NUMBER(7,2),
    DEPTNO      NUMBER(2)   CONSTRAINT EMPFK_DEPTNO_FK REFERENCES DEPT_PK(DEPTNO)
);

INSERT INTO EMP_FK
VALUES (9999, 'TEST_NAME','TEST_JOB',NULL,TO_DATE('2001/01/01','YYYY/MM/DD'), 3000,NULL, 10);

INSERT INTO DEPT_PK
VALUES(10, 'TEST_DNAME','TEST_LOC');

SELECT * FROM EMP_FK;
SELECT * FROM DEPT_PK;

/*
테이블명 : TABLE_CHECK
컬럼 : LOGIN ID, LOGIN_PWD, TEL / VARCHAR2(20) LOGIN_ID 는 PRIMARY KEy
LOGIN_PWD 컬럼 CHECK 제약조건을 설정하는데 해당 컬럼에 저장되는 데이터가 3자리이상 데이터저장
할 수 있도록 check 제약조건 설정
*/
CREATE TABLE TABLE_CHECK(
    LOGIN_ID    VARCHAR2(20)  CONSTRAINT TBLCK_LOGINID_PK PRIMARY KEY,
    LOGIN_PWD   VARCHAR2(20),
    TEL         VARCHAR2(20)
);

ALTER TABLE TABLE_CHECK
ADD CONSTRAINT LOGIN_PW_CK CHECK(LENGTH(LOGIN_PWD)>3);

SELECT * FROM TABLE_CHECK;

SELECt*
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TABLE_CHECK';

INSERT INTO TABLE_CHECK
VALUES('TEST_ID','1234','010-123-2323');

INSERT INTO TABLE_CHECK
VALUES('TEST_ID2','12','010-123-2323'); -- 오류뜸 비밀번호 제약조건때메

SELECT * FROM TABLE_CHECK;

--tel 컬럼의 default로 적용될 값은 '010-000-0000'로 설정

ALTER TABLE TABLE_CHECK
MODIFY TEL Default '010-000-0000';

ALTER TABLE TABLE_CHECK
ADD COMM VARCHAR2(20) DEFAULT 'COMM';

DESCRIB TABLE_CHECK;


INSERT INTO TABLE_CHECK
VALUES('TEST_ID5','1234',default, default);

