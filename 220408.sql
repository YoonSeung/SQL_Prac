--22년 4월 8일 
--1교시
/*  EMP, DEPT 테이블 사용
1.급여가 3000 이상인 사원의 사원번호, 이름, 급여, 부서번호, 부서명, 지역 출력
2. 사원번호, 사원명, 사원별 매니저 번호와 매니저명 출력
3.사원번호, 사원명, 사원별 매니저 번호와 매니저명을 출력하는데 매니저가 없는 사원도
출력할 수 있도록 하시오
4.급여가 3000이하인 사원의 사원번호, 사원명, 직무, 매니저번호, 입사일 급여
추가 수당, 부서번호, 부서명, 지역명을 출력하시오(JOIN ~ ON 사용)
5. 1번을 JOIN ~ USING을 사용해 출력
    */
    
--1번--
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND SAL>=3000;

--2번--
SELECT  E1.EMPNO, E1.ENAME, E1.MGR, E2.EMPNO AS MGR_EMPNO, E2.ENAME AS MGR_ENAME
FROM    EMP E1, EMP E2
WHERE   E1.MGR = E2.EMPNO;

--3번--
SELECT  E1.EMPNO, E1.ENAME, E1.MGR, E2.EMPNO AS MGR_EMPNO, E2.ENAME AS MGR_ENAME
FROM    EMP E1, EMP E2
WHERE   E1.MGR = E2.EMPNO(+)
ORDER BY E1.EMPNO;

--4번--
SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE E.SAL <=3000
ORDER BY E.DEPTNO, E.EMPNO;

--5번
SELECT EMPNO, ENAME, SAL, DEPTNO, DNAME, LOC
FROM EMP JOIN DEPT USING (DEPTNO)
WHERE SAL >=3000;

CREATE TABLE T_Course
AS
    SELECT * FROM Course
    WHERE 10=20;
    
SELECT * from T_Course;
/*=================================================*/
--2교시
/*
1.T_Course 테이블에 새로운 과목을 추가하시오. 과목코드는 'L1061'이고 과목명이 'ERP실 무'
3학점이며, 담당교수가 'p12'이고, 추가 수강료는 50000원이다.
2.T_Course 테이블에 과목코드는 'L1062'이고, 과목명이 '그룹웨어구축',3학점이며, 담당교수가 'p13
추가 수강료는 40000원
3.학번이 'B0901'인 'L1051'과목의 85점에 대한 성적 취득 날짜는 2010년 6월 28일이다. 
이정보는 SG_Scores 테이블에 입력
4. 'C0901'의 '박은혜' 학생의 ID_Number 칼럼에 고유 키(Unique) 제약조건(SYS_C0017694)이
중복된 데이터를 찾아 수정해 입력하시오
전공이 '컴공',학년은 2학년이며 학번은 'C0901', 학생명은 '박은혜',Id_Number는 '911109-2******',
이메일은 'c0931@cyber.ac.kr를 추가
만약 오류가 발생하게 되면 오류가 발생되어진 컬럼값을 수정해 다시 데이터를 추가해라
*/
--1번--
INSERT INTO T_Course VALUES ('L1061','ERP실무',3,'P12',50000);
--2번--
INSERT INTO T_Course VALUES ('B0901','그룹웨어구축',3,'P13',40000);
commit;
--3번--
INSERT INTO SG_Scores VALUES ('B0901','L1051',85,null,'2010/06/28');
commit;
SELECT * from SG_Scores;
--4번--
INSERT INTO Student(Dept_ID, Year, Student_ID, Name, ID_Number, Email)
VALUES('컴공',2,'C0901','박은혜','911109-2******','c0931@cyber.ac.kr');

SELECT * FROM Student
WHERE ID_Number = '911109-2******';

SELECT * FROM Student
WHERE student_ID = 'C0901';

INSERT INTO Student(Dept_ID, Year, Student_ID, Name, ID_Number, Email)
VALUES('컴공',2,'C0931','박은혜','911119-2******','c0931@cyber.ac.kr');

commit;
SELECT * FROM Student;

--2010년 6월 28일에 취득한 'C0931'학번의 'L1031'과목의 97점이 누락하여 추가 입력하고자 
--INSERT INTO 테이블명한다. 누가 언제 입력하는지의 정보를 추가하시오
--생성되어있는 테이블에 칼럼 추가하기
ALTER TABLE SG_Scores
ADD(User_Name Varchar2(25) Default '오라클계정:'||User,
    C_DATE DATE Default SYSDATE);
    
COMMIT;

INSERT INTO SG_Scores(Student_ID, Course_ID, Score, Score_Assigned)
VALUES('C0931','L1031',97,'10/06/28');

SELECT * FROM sg_scores
WHERE Student_ID='C0931' AND Course_ID='L1031';

SELECT * 
FROM Course
WHERE Professor_ID = 'P12';

DESCRIB T_Course;
INSERT INTO T_Course(Course_ID, Title, C_Number, Professor_ID, Course_fees)
    SELECt Course_ID, Title, C_Number, Professor_ID, Course_Fees
    From Course
    WHERE Professor_ID = 'P12';
    
    
    SELECT * FROM t_course
    WHERE Professor_ID='P12';
    
    
    SELECT * FROM t_course;
    
    
--테이블 안에 컬럼 삭제
DELETE FROM T_Course WHERE professor_id = 'p13';
    
--학번이 'C0901'이고, 과목코드가 'L1041'의 성적이 85점을 105점으로 잘못 입력하였다. Sg_Scores테이블 
--성적을 변경하시오
SELECT * 
FROM Sg_Scores
WHERE Student_ID='C0901' AND Course_ID='L1042';

UPDATE sg_scores
set score = 85
WHERE Student_ID='C0901' AND Course_ID='L1042';

commit;

SELECT *
FROM Course
WHERE Course_Fees > (Select AVG(Course_Fees) From Course);

update Course
SET Course_Fees = Course_Fees-5000
WHERE Course_Fees>(Select AVG(Course_Fees) From Course);

ROLLBACK;

/*
. Cours 테이블의 과목코드(Course_ID)가 ‘L0012’이고, 과목명(Title)이 ‘문학과 여행’인 과목
을 삭제하시오
*/
DELETE FROM Course WHERE Course_ID = 'L0012' AND title ='문학과 여행';
select * from Course;
commit;
/*
Computer_Student 테이블의 모든 행을 삭제하시오.(TRUNCATE TABLE 명령어 사용)
*/
TRUNCATE TABLE COMPUTER_Student;

/*
================================================================
*/
--5교시
--Course_Temp 테이블을 생성
--Course 테이블의 컬럼과 type이 일치 
--단 Course 테이블의 데이터는 제외

CREATE TABLE Course_Temp
AS
    SELECT * FROM Course
    WHERE 1<>1;

DESCRIB Course_Temp;
commit;

INSERT INTO Course_Temp VALUES ('L1031','SQL응용', 3,'P12',50000);
INSERT INTO Course_Temp VALUES ('L1032','JAVA', 3,'P13',30000);
INSERT INTO Course_Temp VALUES ('L1043','JSP 프로그래밍', 3,NULL,50000);
INSERT INTO Course_Temp VALUES ('L1033','게임프로그램', 3,'P23',40000);
INSERT INTO Course_Temp VALUES ('L4011','경영정보시스', 3,'P41',30000);
INSERT INTO Course_Temp VALUES ('L4012','세무행정학', 3,'P51',50000);

SELECT * FROM Course_Temp;

commit;

MERGE INTO Course C
        USING Course_Temp T
        ON (C.Course_ID = T.Course_ID)
WHEN    MATCHED THEN
        UPDATE 
        SET C.Title = T.Title, C.Course_Fees = T.Course_Fees
WHEN NOT MATCHED THEN
        INSERT (Course_ID, Title, C_Number, Professor_ID, Course_Fees)
        VALUES (T.Course_ID, T.Title, T.C_Number, T.Professor_ID, T.Course_Fees);
        
SELECT * FROM Course;

commit;

INSERT INTO Computer_Student
    SELECT DEPT_ID, Year, Student_ID, Name, ID_Number, Email
    FROm Student
    WHERE Dept_ID='컴공';
    
    SELECT * FROM Computer_Student
    WHERE Dept_ID='컴공';
    
    COMMIt;
    
CREATE TABLE TEMP(
    COL1    VARCHAR2(7),
    COL2    NUMBER(3));
    
COMMIT;

INSERT INTO TEMP VALUES('0905001', 88);
INSERT INTO TEMP VALUES('0905002', 99);
INSERT INTO TEMP VALUES('0905003', 55);

commit;

SELECT * FROM TEMP;

SAVEPOINT Insert_1;
INSERT INTO TEMP VALUES ('0905005', 66);

SAVEPOINT Delete_1;
DELETE FROM TEMP
WHERE Col1 = '0905003';

SAVEPOINT Update_1;
Update TEMP
SET Col2=77
WHERE Col1 = '0905001';

ROllback TO Update_1;
SELECT * FROM Temp;

COMMIT;
/*
===========================================================
*/
CREATE TABLE DEPT_TEMP
AS
    SELECT * FROM DEPT

INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
VALUES (50, 'DATABASE', 'SEOUL');

INSERT INTO DEPT_TEMP
VALUES(60 , 'NETWORK','BUSAN');

INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
VALUES(70, 'WEB', NULL);

INSERT INTO DEPT_TEMP (DEPTNO, DNAME, LOC)
VALUES(80 , 'MOBILE','');

INSERT INTO DEPT_TEMP(DEPTNO, LOC)
VALUES (90,'INCHEON');

COMMIT;

SELECT * FROM DEPT_TEMP;

--EMP_TEMP 테이블 생성하되 EMP 테이블 복사 데이터 복사 x

CREATE TABLE EMP_TEMP
AS
    SELECT * FROM EMP
       WHERE 1<>1;
       
SELECT * FROM EMP_TEMP;

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (9999,'홍길동', 'PRESIDENT', NULL, '2001/01/01', 5000, 1000, 10);

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (2111,'이순신', 'MANAGER', 9999, '07/01/2001', 4000, NULL, 20);

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (2111,'이순신', 'MANAGER', 9999, 
        TO_DATE('07/01/2001', 'DD/MM/YYYY'), 4000, NULL, 20);
        
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (3111,'심청이', 'MANAGER', 9999, SYSDATE, 4000, NULL, 30);        
SELECT * FROM EMP_TEMP;

commit;



INSERT INTO EMP_TEMP
    SELECT DEPT_ID, Year, Student_ID, Name, ID_Number, Email
    FROm Student
    WHERE Dept_ID='컴공';
    
--EMP_TEMP 테이블에 SALGRADE 테이블의 grade가 1에 해당하는 급여를 가지고있는 
--데이터들만 저장한다.

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    SELECT  E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
    FROM   SALGRADE SG, EMP E
    WHERE   E.SAL BETWEEN SG.losal AND SG.hisal
        and SG.Grade=1;

SELECT * FROM EMP_TEMP;
commit;

--DEPT_TEMP2 테이블 생성
--DEPT 테이블과 동일한 테이블로 생성(데이터도)

CREATE TABLE DEPT_TEMP2
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP2;
COMMIT;
/*
======================================================================
1. DEPT_TEMP2 테이블의 부서번호가 40번인 부서의 부서명을 "DATABASE",
지역명은 "SEOUL"로 변경하시오
*/

SELECT * 
FROM DEPT_TEMP2
WHERE DEPTNO=40;

UPDATE DEPT_TEMP2
set DNAME = 'DATABASE' 
WHERE  DEPTNO=40;

UPDATE DEPT_TEMP2
set LOC = 'SEOUL'
WHERE  DEPTNO=40;

/*정답
UPDATE DEPT_TEMP2
set  DNAME = 'DATABASE' , LOC = 'SEOUL'
WHERE  DEPTNO=40;
*/

/*
2.DEPT_TEMP2 테이블의 부서번호가 40번인 부서의 부서명을 DEPT 테이블의 부서번호가 
40번에 해당하는 부서명으로 변경하고 지역명은 DEPT 테이블의 부서번호가 40인 부서번호의
지역명을 변경하시오
*/
update DEPT_TEMP2
SET (DNAME, LOC) = (SELECT DNAME, LOC
            FROM DEPT
            WHERE DEPTNO = 40)
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TEMP2 WHERE DEPTNO =40;

/*
3. DEPT_TEMP2 테이블의 부서번호가 DEPT 테이블의 부서명이 "OPERATIONS"에 해당하는
부서의 지역명을 "SEOUL"로 변경하시오
*/
UPDATE DEPT_TEMP2
SET LOC='SEOUL'
WHERE DEPTNO = (SELECT DEPTNO
                FROM DEPT
                WHERE DNAME = 'OPERATIONS');
                
--------------
CREATE TABLE EMP_TEMP2
AS SELECT * FROm EMP;

SELECT * FROM EMP_TEMP2;

/*
1.JOB이 'MANAGER'인 데이터를 삭제하시오(EMP_TEMP2 테이블)
*/
DELETE 
FROM EMP_TEMP2 
WHERE JOB='MANAGER';

SELECT * FROM EMP_TEMP2;
/*
2.등급이 3이고 부서번호가 30인 사원을 찾아서 삭제하시오 SALGRADE 테이블 활용)
*/
DELETE
 FROM   EMP_TEMP2
 WHERE  DEPTNO = 30 and ( SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
                from SALGRADE SG, EMP_TEMP2 E
               WHERE E.SAL BETWEEN SG.losal AND SG.hisal
                and SG.Grade=3);
--정답
DELETE
FROM EMP_TEMP2
WHERE EMPNO IN (SELECT E.EMPNO
                FROM EMP_TEMP2 E, SALGRADE S
                WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
                AND S.GRADE =3
                AND DEPTNO =30);
SELECT * FROM EMP_TEMP2;
/*
EMP_TEMP2 테이블 데이터 모두 삭제
*/
DELETE FROM EMP_TEMP2;
SELECT * FROm EMP_TEMP2;
commit;

/*
==============================막교시===================================
*/
CREATE INDEX Student_Name
ON  Student(Name);

SELECT * FROM Student;

COMMIT;

DROP INDEX Student_Name;
