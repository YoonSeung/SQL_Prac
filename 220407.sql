--4�� 7�� 1����
-- DECODE �Լ� ������ GROUPING() �Լ��� Ȱ���� ����
select  DECODE(GROUPING(DEPTNO), 1 ,'ALL_DEPT', DEPTNO) AS DEPTNO,
        DECODE(GROUPING(JOB), 1 ,'ALL_JOB', JOB) AS JOB,
        count(*), max(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

--�μ��� ��� �̸��� ������ �����ؼ� ���(LISTAGG)
SELECT  DEPTNO,
        LISTAGG(ENAME, ', ') WITHIN GROUP(ORDER BY SAL DESC) AS ENAMES --�μ��� �׷����Ѵ��� ���� �μ����� ������� �޿� ���������� ���������� �����Ͽ� ����̸��� �����ϰڴ�.
FROM EMP
GROUP BY DEPTNO;

SELECT * FROM EMP;

--PIVOT �Լ��� �̿��� ��å��, �μ��� �ְ� �޿��� 2���� ǥ�� ���(��-> ��)
SELECT *
FROM(SELECT DEPTNO, JOB, SAL FROM EMP) -- EMP���̺��� ��ȣ 3���� ������ ������ ���̺� �����
PIVOT (MAX(SAL)
    FOR DEPTNO IN(10, 20, 30)
)
ORDER BY JOB;

--- DEPTNO�� �������� JOB�� ��� ǥ��
SELECT *
FROM(SELECT DEPTNO, JOB, SAL FROM EMP) -- EMP���̺��� ��ȣ 3���� ������ ������ ���̺� �����
PIVOT (MAX(SAL)
    FOR JOB IN('CLERK' AS CLERK, 'SALESMAN' AS SALESMAN, 'PRESIDENT' AS PRESIDENT, 'MANAGER' AS MANAGER, 'ANALYST' AS ANALYST )
)
ORDER BY DEPTNO; 

--2����
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
1. JONES�� �޿����� ���� �޿��� �޴� ��� ������ ����Ͻÿ�
2. KING���� �ʰ� �Ի��� ��� ������ ����Ͻÿ�
3. �μ���ȣ�� 20�� ����� �� ��ձ޿����� �޿��� �� ���� �޴� ��� ������ ����Ͻÿ�
*/
select * from emp;
/*1��*/
SELECT *
FROM EMP
WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='JONES');

/*2��*/
SELECT *
FROM EMP
WHERE HIREDATE>(SELECT HIREDATE
   FROM EMP
   WHERE ENAME='KING');
   
/*3��*/ 
select *
from emp
where deptno = 20
    and sal > (select avg(sal)
        from emp);

-- 3�� ����
--�μ���ȣ�� 20�� ����� �� ��ձ޿����� �޿��� �� ���� �޴� ����� �����ȣ, ��ì��, �޿�, �μ���ȣ, �μ���, �������� ����Ͻÿ�
SELECT EMPNO, ENAME, JOB, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND E.DEPTNO = 20
    AND E.SAL > (SELECT AVG(SAL)
                FROM EMP);
-- ���� ���� ��� �ٸ� �ڵ�
SELECT E.EMPNO, E.ENAME, E.JOB, E.SAL, E.DEPTNO, D.DNAME, D.LOC
FROM    EMP E INNER JOIN DEPT D
        ON E.DEPTNO = D.DEPTNO
WHERE   E.DEPTNO=20
    AND E.SAL > (SELECT AVG(SAL)
                FROM EMP);
                
--�� �μ��� �ְ� �޿��� ������ �޿��� �޴� ��� ���� ��� (�Ʒ� 3�� ���� ����)
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

/*any ������ �̿��ؼ� 
�μ��� ����� �� �ּ� �޾׺��� ���� �޿��� �޴� ��� ������ ���
*/
SELECT *
FROM EMP
WHERE SAL > any(SELECT MIN (SAL)
            FROM EMP GROUP BY DEPTNO);
-- 30�� �μ��� �ּ� �޿����� ���� �޿��� �޴� ��� ���� ���
SELECT *
FROM EMP
WHERE SAL < ANY(SELECT SAL
            FROM EMP WHERE DEPTNO=30);
--any�����ڸ� �̿��� ������ �����Ҷ�"=" ������ �ϰ� �Ǹ� �ϳ��� ��ġ�ϴ� �����Ͱ� ������
--��� ����ϰ� ">" any �����ھȿ� ��ȸ�� ������ �� ���� ���� �����͸� �������� �� �����ͺ��� 
-- ū �����͸� ����Ѵ�.
-- "<"�� �ݴ�
--���� "="�� �� �� any �� ���� ���

-- all�� 
SELECT *
FROM EMP
WHERE SAL > ALL(SELECT SAL
            FROM EMP WHERE DEPTNO=30);
/*��������
IN , SOME , ANY : ���Ϸ��� �׸��� �ϳ��� ������ �ش��ϴ� ������ �����ϰ��� �� �� ���
ALL ������ : ���Ϸ��� �׸񿡼� ���� ���� �Ǵ� ���� ū ���� ������ �ش� �׸񺸴� ū ��, �Ǵ� ������ 
�����͸� �����ϰ��� �� �� ���
*/

SELECT *
FROM EMP
WHERE EXISTS ( SELECT DNAME
                FROM DEPT
                WHERE DEPTNO =40);
                
--- DEPTNO�� SAL �� IN�ȿ� ������ �ϳ��� �´°� ���
SELECT * 
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP GROUP BY DEPTNO);
                        
--�μ���ȣ(DEPTNO)�� 10���� ����� �����ȣ, �����, �μ���ȣ, �μ���, �������� ��ȸ�Ѵ�.
--�� �ζ��κ並 ����Ͽ� ������ ���� ����
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROm (SELECT * FROM EMP WHERE DEPTNO=10) E10, (SELECT * FROM DEPT) D 
WHERE E10.DEPTNO = D.DEPTNO;

--EMP, SALGRADE, DEPT �� ���� ���̺��� �����͸� ��ȸ�ϴ� ����������
SELECT  EMPNO, ENAME, JOB, SAL,
        (SELECT GRADE
            FROM SALGRADE
            WHERE E.SAL BETWEEN LOSAL AND HISAL) AS SALGRADE,
        DEPTNO,
        (SELECT DNAME
            FROM DEPT
            WHERE E.DEPTNO = DEPT.DEPTNO) as DNAME
FROM EMP E;

-- ���������� ��������� �������� �������� ���� WITH ���� ����� �������� ���̴� �۾���
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
--5����
/*  1. professor ���̺�� course ���̺��� �̿��� ������ ����ϰ� �ִ� ������ ���
    2. professor ���̺�� course ���̺��� �̿��� ������ ����ϰ� �ִ� ������� ũ�ν� �����Ͽ� ���
*/

SELECT * from Professor;
SELECT * FROM Course;
--ũ�ν� ���� 1
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P, Course C
order by P.Professor_ID;
--ũ�ν����� 2
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P Cross join Course C
order by P.Professor_ID;




/*1. Professor ���̺�� Course ���̺��� �̿��� ������ �ּ��� �� ���� �̻��� ����ϰ� �ִ�
������ ������ȣ, ������, ����, �����, �������� ������ȣ������ ����Ͻÿ�
*/
SELECT P.Professor_ID, Name, Position, Title, C_Number
FROM Professor P, Course C
WHERE P.professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

/*
2. SG_Scores ���̺�� Student ���̺�, Course ���̺��� �̿��� 'C0901' �й��� �г�� ����
������ ����� ������ ������ ������, ������ ����Ͻÿ�

2�� ����  
SG_SCores ���̺��� �л��� �й� =Score ���̺��� �л��� �й�,
    SG_SCores ���̺��� ����ID=student ���̺��� ���� ID
    �й� �г� �л��� ����ID ����� ���� ������ȸ
*/
SELECT  SG.Student_ID, Year, Name, C.Course_ID, Title, Score, Grade
FROM    SG_Scores SG, Student S, Course C
WHERE   SG.student_ID = S.Student_ID
    AND SG.Course_id = C.Course_ID
    AND SG.Student_ID = 'C0901'
Order BY SG.Course_Id;
------------------------------------------------------------------
--6����
--1. ���� 2���� ������ Natural join ���� ����
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

--2. ���� 2���� ������ join ~ using ���� ����
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

--3. ���� 2���� ������ inner join ~ on ���� ����
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

--1. Professor ���̺��� ��� ������ ���� ������ȣ, ������, ������ ����ϵ�
-- Couse ���̺��� �����Ͽ� ������ �����ϰ� �ִ� ���� ���Ͽ� �����, �������� ����Ͻÿ�
SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P, Course C
WHERE   P.Professor_ID = C.Professor_ID(+)
ORDER BY P.Professor_ID;

/* 2. Course ���̺��� ��� �������� ���Ͽ� �����, �������� ����ϵ�
Professor ���̺��� �����Ͽ� ����ϰ� �ִ� ������ ������ȣ ������ ������ ����Ͻÿ�
*/

SELECT   Title, C_Number, P.Professor_ID, Name, Position
from    Professor P, Course C
WHERE   P.Professor_ID(+) = C.Professor_ID
ORDER BY P.Professor_ID;

--left ,right ����

SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P LEFT OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P RIGHT OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;

-- left right �ΰ� ��ģ�� (FULL)
SELECT  P.Professor_ID, Name, Position, Title, C_Number
from    Professor P FULL OUTER JOIN Course C
        ON P.Professor_ID = C.Professor_ID
ORDER BY P.Professor_ID;
---------------------------------------------------------------
--7����
SELECT * FROM DEPARTMENT;
SELECT * FROM Professor;

INSERT INTO Department
VALUES('����', '���к���', '765-4000');

INSERT INTO Professor
VALUES('P00','���ѽ�','����','����','765-4000',NULL,'����',NULL);

COMMIT;

--Professor_id, ������, DEPT_ID,DUTY, �����ڸ��� ��ȸ�� �� �ֵ��� �Ѵ�
SELECT  T1.Professor_ID, T1.Name||' '||T1.POSITION "������",
        T1.Dept_ID, T1.Duty, T2.Name||' '||T2.Duty "�����ڸ�"
FROM    Professor T1, Professor T2
WHERE   T1.MGR = T2.Professor_ID
ORDER BY T1.Dept_ID, T1.Professor_ID;

SELECT  T1.Professor_ID, T1.Name||' '||T1.POSITION "������",
        T1.Dept_ID, T1.Duty, T2.Name||' '||T2.Duty "�����ڸ�"
FROM    Professor T1 INNER JOIN Professor T2
        ON T1.Mgr = T2.Professor_ID
ORDER BY T1.Dept_ID, T1.Professor_ID;

/*
SG_Scores ���̺�κ��� 'C0902' �л��� ������ �̿��� Score_Grade ���̺��� ��� ���
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
--8����
-- ������ ������� ������ ��ȸ
SELECT  SG.Student_ID, SG.Course_ID, SG.Score, G.Grade
FROM    sg_scores SG, score_grade G
WHERE   SG.Score BETWEEN G.Low AND G.HIGH
    AND SG.Student_ID = 'C0902'
ORDER BY SG.Course_ID;

--���� ������ �̿��� ��ȸ
SELECT  *
FROM    Course
WHERE   Professor_ID NOT IN(SELECT Professor_ID FROM Professor) OR Professor_ID IS NULL
ORDER BY Course_ID; --������̵𺰷� ǥ���ϰڴ�

--������ �������� ���� ������ ��ȸ
SELECT  P.Professor_ID, Name, Position, Title, C_Number
FROM    Professor P, Course C
WHERE   P.Professor_ID = C.Professor_ID(+)
    AND Course_ID IS NULL
ORDER BY P.Professor_ID;


/*
 1. Course ���̺�� T_Course ���̺��� ��� ���Ͽ� �����ڵ� ������ ����Ͻÿ�.
*/
SELECT  *
FROM Course 
UNION ALL
SELECT  *
FROM T_Course
ORDER BY 1;

 --2. Professor ���̺�� Course ���̺��� �̿��Ͽ� ������ ������ ������ ������ȣ�� ������ȣ������ ����Ͻÿ�.
SELECT  Professor_ID
FROM Professor 
INTERSECT
SELECT  Professor_ID
FROM Course 
ORDER BY 1;

 --3. Student ���̺�� SG_Scores ���̺��� �����Ͽ� ������ ������� ���� �л��� �й��� ����Ͻÿ�.
 SELECT Student_ID FROM Student
 MINUS
 SELECT Student_ID FROM SG_Scores;
 
 -- EMP�� DEPT �� ������ ��� �̸� �μ���ȣ �μ��� �������� ����Ͻÿ�
 
 SELECT E.EMPNO, E.ENAME, E.DEPTNO , D.DNAME, D.LOC
 FROM   EMP E, DEPT D
 WHERE E.DEPTNO=D.DEPTNO;