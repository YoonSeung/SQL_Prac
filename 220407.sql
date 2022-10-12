--4월 7일 1교시
-- DECODE 함수 내에서 GROUPING() 함수를 활용한 예제
select  DECODE(GROUPING(DEPTNO), 1 ,'ALL_DEPT', DEPTNO) AS DEPTNO,
        DECODE(GROUPING(JOB), 1 ,'ALL_JOB', JOB) AS JOB,
        count(*), max(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

--부서별 사원 이름을 나란히 나열해서 출력(LISTAGG)
SELECT  DEPTNO,
        LISTAGG(ENAME, ', ') WITHIN GROUP(ORDER BY SAL DESC) AS ENAMES --부서별 그룹핑한다음 같은 부서내의 사원들을 급여 낮은순에서 높은순으로 정렬하여 사원이름을 나열하겠다.
FROM EMP
GROUP BY DEPTNO;

SELECT * FROM EMP;

--PIVOT 함수를 이용해 직책별, 부서별 최고 급여를 2차원 표로 출력(행-> 열)
SELECT *
FROM(SELECT DEPTNO, JOB, SAL FROM EMP) -- EMP테이블에서 괄호 3개만 가져와 가상의 테이블 만든다
PIVOT (MAX(SAL)
    FOR DEPTNO IN(10, 20, 30)
)
ORDER BY JOB;

--- DEPTNO를 기준으로 JOB별 목록 표현
SELECT *
FROM(SELECT DEPTNO, JOB, SAL FROM EMP) -- EMP테이블에서 괄호 3개만 가져와 가상의 테이블 만든다
PIVOT (MAX(SAL)
    FOR JOB IN('CLERK' AS CLERK, 'SALESMAN' AS SALESMAN, 'PRESIDENT' AS PRESIDENT, 'MANAGER' AS MANAGER, 'ANALYST' AS ANALYST )
)
ORDER BY DEPTNO; 

--2교시
SELECT  DEPTNO,
        MAX(DECODE(JOB, 'CLERK', SAL)) AS "CLERK",
        MAX(DECODE(JOB, 'SALESMAN', SAL)) AS "SALESMAN",
        MAX(DECODE(JOB, 'PRESIDENT', SAL)) AS "PRESIDENT",
        MAX(DECODE(JOB, 'MANAGER', SAL)) AS "MANAGER",
        MAX(DECODE(JOB, 'ANALYST', SAL)) AS "ANALYST"
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;
/*
1. JONES의 급여보다 높은 급여를 받는 사원 정보를 출력하시오
2. KING보다 늦게 입사한 사원 정보를 출력하시오
3. 부서번호가 20인 사원들 중 평균급여보다 급여를 더 많이 받는 사원 정보를 출력하시오
*/
select * from emp;
/*1번*/
SELECT *
FROM EMP
WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='JONES');

/*2번*/
SELECT *
FROM EMP
WHERE HIREDATE>(SELECT HIREDATE
   FROM EMP
   WHERE ENAME='KING');
   
/*3번*/ 
select *
from emp
where deptno = 20
    and sal > (select avg(sal)
        from emp);

-- 3번 응용
--부서번호가 20인 사원들 중 평균급여보다 급여를 더 많이 받는 사원의 사원번호, 직챙명, 급여, 부서번호, 부서명, 지역명을 출력하시오
SELECT EMPNO, ENAME, JOB, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND E.DEPTNO = 20
    AND E.SAL > (SELECT AVG(SAL)
                FROM EMP);
-- 위와 같은 결과 다른 코딩
SELECT E.EMPNO, E.ENAME, E.JOB, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM    EMP E INNER JOIN DEPT D
        ON E.DEPTNO = D.DEPTNO
WHERE   E.DEPTNO=20
    AND E.SAL > (SELECT AVG(SAL)
                FROM EMP);
                
--각 부서별 최고 급여와 동일한 급여를 받는 사원 정보 출력 (아래 3개 전부 동일)
SELECT *
FROM EMP
WHERE SAL IN (SELECT MAX (SAL)
            FROM EMP GROUP BY DEPTNO);
     
SELECT *
FROM EMP
WHERE SAL = ANY(SELECT MAX (SAL)
            FROM EMP GROUP BY DEPTNO);
            
SELECT *
FROM EMP
WHERE SAL = SOME(SELECT MAX (SAL)
            FROM EMP GROUP BY DEPTNO);

/*any 연산자 이용해서 
부서별 사원들 중 최소 급액보다 많은 급여를 받는 사원 정보를 출력
*/
SELECT *
FROM EMP
WHERE SAL > any(SELECT MIN (SAL)
            FROM EMP GROUP BY DEPTNO);
-- 30번 부서의 최소 급여보다 적은 급여를 받는 사원 정보 출력
SELECT *
FROM EMP
WHERE SAL < ANY(SELECT SAL
            FROM EMP WHERE DEPTNO=30);
--any연산자를 이용해 데이터 추출할때"=" 연산을 하게 되면 하나라도 일치하는 데이터가 있으면
--모두 출력하고 ">" any 연산자안에 조회된 데이터 중 가장 작은 데이터를 기준으로 그 데이터보다 
-- 큰 데이터를 출력한다.
-- "<"는 반대
--보통 "="을 쓸 때 any 를 자주 사용

-- all은 
SELECT *
FROM EMP
WHERE SAL > ALL(SELECT SAL
            FROM EMP WHERE DEPTNO=30);
/*최종정리
IN , SOME , ANY : 비교하려는 항목이 하나라도 있으면 해당하는 데이터 추출하고자 할 때 사용
ALL 연산자 : 비교하려는 항목에서 가장 작은 또는 가장 큰 값을 가져와 해당 항목보다 큰 값, 또는 작은값 
데이터를 추출하고자 할 때 사용
*/

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
                FROM DEPT
                WHERE DEPTNO =40);
                
--- DEPTNO와 SAL 중 IN안에 조건이 하나라도 맞는거 출력
SELECT * 
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP GROUP BY DEPTNO);
                        
--부서번호(DEPTNO)가 10번인 사원의 사원번호, 사원명, 부서번호, 부서명, 지역명을 조회한다.
--단 인라인뷰를 사용하여 쿼리를 만든 예제
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROm (SELECT * FROM EMP WHERE DEPTNO=10) E10, (SELECT * FROM DEPT) D 
WHERE E10.DEPTNO = D.DEPTNO;

--EMP, SALGRADE, DEPT 세 개의 테이블에서 데이터를 조회하는 서브쿼리임
SELECT  EMPNO, ENAME, JOB, SAL,
        (SELECT GRADE
            FROM SALGRADE
            WHERE E.SAL BETWEEN LOSAL AND HISAL) AS SALGRADE,
        DEPTNO,
        (SELECT DNAME
            FROM DEPT
            WHERE E.DEPTNO = DEPT.DEPTNO) as DNAME
FROM EMP E;

-- 서브쿼리를 사용함으로 가독성이 떨어지는 것을 WITH 절을 사용해 가독성을 높이는 작업임
WITH
E10 AS (SELECT * FROM EMP WHERE DEPTNO=10),
D AS (SELECT * FROM DEPT)
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM E10,D
WHERE E10.DEPTNO = D.DEPTNO;

--
SELECT P.Professor_ID, P.Name, P.Position, C.Title, C.C_Number
FROM Professor P, Course C
WHERE P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

--------------------------------------------------------------------------
--5교시
/*  1. professor 테이블과 course 테이블을 이용해 교수가 담당하고 있는 과목을 출력
    2. professor 테이블과 course 테이블을 이용해 교수가 담당하고 있는 과목들을 크로스 조인하여 출력
*/

SELECT * from Professor;
SELECT * FROM Course;
--크로스 조인 1
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P, Course C
order by P.Professor_ID;
--크로스조인 2
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P Cross join Course C
order by P.Professor_ID;




/*1. Professor 테이블과 Course 테이블을 이용해 교수가 최소한 한 과목 이상을 담당하고 있는
교수의 교수번호, 교수명, 직위, 과목명, 학점수를 교수번호순으로 출력하시오
*/
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P, Course C
WHERE P.professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

/*
2. SG_Scores 테이블과 Student 테이블, Course 테이블을 이용해 'C0901' 학번의 학년과 성명
학점을 취득한 과목의 과목명과 학점수, 성적을 출력하시오

2번 보충  
SG_SCores 테이블의 학생의 학번 =Score 테이블의 학생의 학번,
    SG_SCores 테이블의 과목ID=student 테이블의 과목 ID
    학번 학년 학생명 과목ID 과목명 점수 학점조회
*/
SELECT  SG.Student_ID, Year, Name, C.Course_ID, Title, Score, Grade
FROM    SG_Scores SG, Student S, Course C
WHERE   SG.student_ID = S.Student_ID
    AND SG.Course_id = C.Course_ID
    AND SG.Student_ID = 'C0901'
Order BY SG.Course_Id;
------------------------------------------------------------------
--6교시
--1. 위의 2개의 쿼리를 Natural join 으로 변경
SELECT  Professor_ID, Name, Position, Title, C_Number
FROM    Professor 
NATURAL JOIN  Course  
ORDER BY Professor_ID;

SELECT  Student_ID, Year, Name, Course_ID, Title, Score, Grade
FROM    SG_Scores 
NATURAL JOIN  Student  
NATURAL JOIN Course
WHERE  Student_ID = 'C0901'
Order BY Course_Id;

--2. 위의 2개의 쿼리를 join ~ using 으로 변경
SELECT  Professor_ID, Name, Position, Title, C_Number
FROM    Professor 
INNER JOIN Course USING(Professor_ID)
ORDER BY Professor_ID;


SELECT  Student_ID, Year, Name, Course_ID, Title, Score, Grade
FROM    SG_Scores 
JOIN  Student using (Student_ID)
JOIN Course using (Course_ID)
WHERE  Student_ID = 'C0901'
Order BY Course_Id;

--3. 위의 2개의 쿼리를 inner join ~ on 으로 변경
SELECT  P.Professor_ID, Name, Position, Title, C_Number
FROM    Professor P 
INNER JOIN Course C ON P.Professor_ID = c.professor_id
ORDER BY Professor_ID;


SELECT  SG.Student_ID, Year, Name, SG.Course_ID, Title, Score, Grade
FROM    SG_Scores SG INNER JOIN  Student S 
            ON (SG.Student_id = S.Student_ID)
            INNER JOIN  Course C 
            ON (SG.Course_ID = C.Course_ID)
WHERE  SG.Student_ID = 'C0901'
Order BY Course_Id;

--1. Professor 테이블의 모든 교수에 대한 교수번호, 교수명, 직위를 출력하되
-- Couse 테이블을 참조하여 교수가 개설하고 있는 과목에 대하여 과목명, 학점수를 출력하시오
SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P, Course C
WHERE   P.Professor_ID = C.Professor_ID(+)
ORDER BY P.Professor_ID;

/* 2. Course 테이블의 모든 개설과목에 대하여 과목명, 학점수를 출력하되
Professor 테이블을 참조하여 담당하고 있는 과목의 교수번호 교수명 직위도 출력하시오
*/

SELECT   Title, C_Number, P.Professor_ID, Name, Position
from    Professor P, Course C
WHERE   P.Professor_ID(+) = C.Professor_ID
ORDER BY P.Professor_ID;

--left ,right 조인

SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P LEFT OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P RIGHT OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

-- left right 두개 합친것 (FULL)
SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P FULL OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;
---------------------------------------------------------------
--7교시
SELECT * FROM DEPARTMENT;
SELECT * FROM Professor;

INSERT INTO Department
VALUES('대학', '대학본부', '765-4000');

INSERT INTO Professor
VALUES('P00','서한식','총장','대학','765-4000',NULL,'총장',NULL);

COMMIT;

--Professor_id, 교수명, DEPT_ID,DUTY, 관리자명이 조회될 수 있도록 한다
SELECT  T1.Professor_ID, T1.Name||' '||T1.POSITION "교수명",
        T1.Dept_ID, T1.Duty, T2.Name||' '||T2.Duty "관리자명"
FROM    Professor T1, Professor T2
WHERE   T1.MGR = T2.Professor_ID
ORDER BY T1.Dept_ID, T1.Professor_ID;

SELECT  T1.Professor_ID, T1.Name||' '||T1.POSITION "교수명",
        T1.Dept_ID, T1.Duty, T2.Name||' '||T2.Duty "관리자명"
FROM    Professor T1 INNER JOIN Professor T2
        ON T1.Mgr = T2.Professor_ID
ORDER BY T1.Dept_ID, T1.Professor_ID;

/*
SG_Scores 테이블로부터 'C0902' 학생의 성적을 이용해 Score_Grade 테이블의 등급 출력
*/

CREATE TABLE Score_Grade(
    LOW     NUMBER(3),
    HIGH    NUMBER(3),
    GRADE   CHAR(2));
    
COMMIT;

INSERT INTO score_grade VALUES(90, 100, 'A');
INSERT INTO score_grade VALUES(80, 89, 'B');
INSERT INTO score_grade VALUES(70, 79, 'C');
INSERT INTO score_grade VALUES(60, 69, 'D');
INSERT INTO score_grade VALUES(0, 59, 'F');

SELECT * FROM score_grade;
COMMIT;

-----------------------------------------------
--8교시
-- 비등가조인 방식으로 데이터 조회
SELECT  SG.Student_ID, SG.Course_ID, SG.Score, G.Grade
FROM    sg_scores SG, score_grade G
WHERE   SG.Score BETWEEN G.Low AND G.HIGH
    AND SG.Student_ID = 'C0902'
ORDER BY SG.Course_ID;

--서브 쿼리를 이용한 조회
SELECT  *
FROM    Course
WHERE   Professor_ID NOT IN(SELECT Professor_ID FROM Professor) OR Professor_ID IS NULL
ORDER BY Course_ID; --과목아이디별로 표현하겠다

--과목을 개설하지 않은 교수를 조회
SELECT  P.Professor_ID, Name, Position, Title, C_Number
FROM    Professor P, Course C
WHERE   P.Professor_ID = C.Professor_ID(+)
    AND Course_ID IS NULL
ORDER BY P.Professor_ID;


/*
 1. Course 테이블과 T_Course 테이블을 모두 합하여 과목코드 순으로 출력하시오.
*/
SELECT  *
FROM Course 
UNION ALL
SELECT  *
FROM T_Course
ORDER BY 1;

 --2. Professor 테이블과 Course 테이블을 이용하여 과목을 개설한 교수의 교수번호를 교수번호순으로 출력하시오.
SELECT  Professor_ID
FROM Professor 
INTERSECT
SELECT  Professor_ID
FROM Course 
ORDER BY 1;

 --3. Student 테이블과 SG_Scores 테이블을 참조하여 학점을 취득하지 못한 학생의 학번을 출력하시오.
 SELECT Student_ID FROM Student
 MINUS
 SELECT Student_ID FROM SG_Scores;
 
 -- EMP와 DEPT 를 참조해 사번 이름 부서번호 부서명 지역명을 출력하시오
 
 SELECT E.EMPNO, E.ENAME, E.DEPTNO , D.DNAME, D.LOC
 FROM   EMP E, DEPT D
 WHERE E.DEPTNO=D.DEPTNO;