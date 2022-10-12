--22�� 4�� 8�� 
--1����
/*  EMP, DEPT ���̺� ���
1.�޿��� 3000 �̻��� ����� �����ȣ, �̸�, �޿�, �μ���ȣ, �μ���, ���� ���
2. �����ȣ, �����, ����� �Ŵ��� ��ȣ�� �Ŵ����� ���
3.�����ȣ, �����, ����� �Ŵ��� ��ȣ�� �Ŵ������� ����ϴµ� �Ŵ����� ���� �����
����� �� �ֵ��� �Ͻÿ�
4.�޿��� 3000������ ����� �����ȣ, �����, ����, �Ŵ�����ȣ, �Ի��� �޿�
�߰� ����, �μ���ȣ, �μ���, �������� ����Ͻÿ�(JOIN ~ ON ���)
5. 1���� JOIN ~ USING�� ����� ���
    */
    
--1��--
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND SAL>=3000;

--2��--
SELECT  E1.EMPNO, E1.ENAME, E1.MGR, E2.EMPNO AS MGR_EMPNO, E2.ENAME AS MGR_ENAME
FROM    EMP E1, EMP E2
WHERE   E1.MGR = E2.EMPNO;

--3��--
SELECT  E1.EMPNO, E1.ENAME, E1.MGR, E2.EMPNO AS MGR_EMPNO, E2.ENAME AS MGR_ENAME
FROM    EMP E1, EMP E2
WHERE   E1.MGR = E2.EMPNO(+)
ORDER BY E1.EMPNO;

--4��--
SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE E.SAL <=3000
ORDER BY E.DEPTNO, E.EMPNO;

--5��
SELECT EMPNO, ENAME, SAL, DEPTNO, DNAME, LOC
FROM EMP JOIN DEPT USING (DEPTNO)
WHERE SAL >=3000;

CREATE TABLE T_Course
AS
    SELECT * FROM Course
    WHERE 10=20;
    
SELECT * from T_Course;
/*=================================================*/
--2����
/*
1.T_Course ���̺� ���ο� ������ �߰��Ͻÿ�. �����ڵ�� 'L1061'�̰� ������� 'ERP�� ��'
3�����̸�, ��米���� 'p12'�̰�, �߰� ������� 50000���̴�.
2.T_Course ���̺� �����ڵ�� 'L1062'�̰�, ������� '�׷�����',3�����̸�, ��米���� 'p13
�߰� ������� 40000��
3.�й��� 'B0901'�� 'L1051'������ 85���� ���� ���� ��� ��¥�� 2010�� 6�� 28���̴�. 
�������� SG_Scores ���̺� �Է�
4. 'C0901'�� '������' �л��� ID_Number Į���� ���� Ű(Unique) ��������(SYS_C0017694)��
�ߺ��� �����͸� ã�� ������ �Է��Ͻÿ�
������ '�İ�',�г��� 2�г��̸� �й��� 'C0901', �л����� '������',Id_Number�� '911109-2******',
�̸����� 'c0931@cyber.ac.kr�� �߰�
���� ������ �߻��ϰ� �Ǹ� ������ �߻��Ǿ��� �÷����� ������ �ٽ� �����͸� �߰��ض�
*/
--1��--
INSERT INTO T_Course VALUES ('L1061','ERP�ǹ�',3,'P12',50000);
--2��--
INSERT INTO T_Course VALUES ('B0901','�׷�����',3,'P13',40000);
commit;
--3��--
INSERT INTO SG_Scores VALUES ('B0901','L1051',85,null,'2010/06/28');
commit;
SELECT * from SG_Scores;
--4��--
INSERT INTO Student(Dept_ID, Year, Student_ID, Name, ID_Number, Email)
VALUES('�İ�',2,'C0901','������','911109-2******','c0931@cyber.ac.kr');

SELECT * FROM Student
WHERE ID_Number = '911109-2******';

SELECT * FROM Student
WHERE student_ID = 'C0901';

INSERT INTO Student(Dept_ID, Year, Student_ID, Name, ID_Number, Email)
VALUES('�İ�',2,'C0931','������','911119-2******','c0931@cyber.ac.kr');

commit;
SELECT * FROM Student;

--2010�� 6�� 28�Ͽ� ����� 'C0931'�й��� 'L1031'������ 97���� �����Ͽ� �߰� �Է��ϰ��� 
--INSERT INTO ���̺���Ѵ�. ���� ���� �Է��ϴ����� ������ �߰��Ͻÿ�
--�����Ǿ��ִ� ���̺� Į�� �߰��ϱ�
ALTER TABLE SG_Scores
ADD(User_Name Varchar2(25) Default '����Ŭ����:'||User,
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
    
    
--���̺� �ȿ� �÷� ����
DELETE FROM T_Course WHERE professor_id = 'p13';
    
--�й��� 'C0901'�̰�, �����ڵ尡 'L1041'�� ������ 85���� 105������ �߸� �Է��Ͽ���. Sg_Scores���̺� 
--������ �����Ͻÿ�
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
. Cours ���̺��� �����ڵ�(Course_ID)�� ��L0012���̰�, �����(Title)�� �����а� ���࡯�� ����
�� �����Ͻÿ�
*/
DELETE FROM Course WHERE Course_ID = 'L0012' AND title ='���а� ����';
select * from Course;
commit;
/*
Computer_Student ���̺��� ��� ���� �����Ͻÿ�.(TRUNCATE TABLE ��ɾ� ���)
*/
TRUNCATE TABLE COMPUTER_Student;

/*
================================================================
*/
--5����
--Course_Temp ���̺��� ����
--Course ���̺��� �÷��� type�� ��ġ 
--�� Course ���̺��� �����ʹ� ����

CREATE TABLE Course_Temp
AS
    SELECT * FROM Course
    WHERE 1<>1;

DESCRIB Course_Temp;
commit;

INSERT INTO Course_Temp VALUES ('L1031','SQL����', 3,'P12',50000);
INSERT INTO Course_Temp VALUES ('L1032','JAVA', 3,'P13',30000);
INSERT INTO Course_Temp VALUES ('L1043','JSP ���α׷���', 3,NULL,50000);
INSERT INTO Course_Temp VALUES ('L1033','�������α׷�', 3,'P23',40000);
INSERT INTO Course_Temp VALUES ('L4011','�濵�����ý�', 3,'P41',30000);
INSERT INTO Course_Temp VALUES ('L4012','����������', 3,'P51',50000);

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
    WHERE Dept_ID='�İ�';
    
    SELECT * FROM Computer_Student
    WHERE Dept_ID='�İ�';
    
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

--EMP_TEMP ���̺� �����ϵ� EMP ���̺� ���� ������ ���� x

CREATE TABLE EMP_TEMP
AS
    SELECT * FROM EMP
       WHERE 1<>1;
       
SELECT * FROM EMP_TEMP;

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (9999,'ȫ�浿', 'PRESIDENT', NULL, '2001/01/01', 5000, 1000, 10);

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (2111,'�̼���', 'MANAGER', 9999, '07/01/2001', 4000, NULL, 20);

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (2111,'�̼���', 'MANAGER', 9999, 
        TO_DATE('07/01/2001', 'DD/MM/YYYY'), 4000, NULL, 20);
        
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (3111,'��û��', 'MANAGER', 9999, SYSDATE, 4000, NULL, 30);        
SELECT * FROM EMP_TEMP;

commit;



INSERT INTO EMP_TEMP
    SELECT DEPT_ID, Year, Student_ID, Name, ID_Number, Email
    FROm Student
    WHERE Dept_ID='�İ�';
    
--EMP_TEMP ���̺� SALGRADE ���̺��� grade�� 1�� �ش��ϴ� �޿��� �������ִ� 
--�����͵鸸 �����Ѵ�.

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    SELECT  E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
    FROM   SALGRADE SG, EMP E
    WHERE   E.SAL BETWEEN SG.losal AND SG.hisal
        and SG.Grade=1;

SELECT * FROM EMP_TEMP;
commit;

--DEPT_TEMP2 ���̺� ����
--DEPT ���̺�� ������ ���̺�� ����(�����͵�)

CREATE TABLE DEPT_TEMP2
AS
SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP2;
COMMIT;
/*
======================================================================
1. DEPT_TEMP2 ���̺��� �μ���ȣ�� 40���� �μ��� �μ����� "DATABASE",
�������� "SEOUL"�� �����Ͻÿ�
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

/*����
UPDATE DEPT_TEMP2
set  DNAME = 'DATABASE' , LOC = 'SEOUL'
WHERE  DEPTNO=40;
*/

/*
2.DEPT_TEMP2 ���̺��� �μ���ȣ�� 40���� �μ��� �μ����� DEPT ���̺��� �μ���ȣ�� 
40���� �ش��ϴ� �μ������� �����ϰ� �������� DEPT ���̺��� �μ���ȣ�� 40�� �μ���ȣ��
�������� �����Ͻÿ�
*/
update DEPT_TEMP2
SET (DNAME, LOC) = (SELECT DNAME, LOC
            FROM DEPT
            WHERE DEPTNO = 40)
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TEMP2 WHERE DEPTNO =40;

/*
3. DEPT_TEMP2 ���̺��� �μ���ȣ�� DEPT ���̺��� �μ����� "OPERATIONS"�� �ش��ϴ�
�μ��� �������� "SEOUL"�� �����Ͻÿ�
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
1.JOB�� 'MANAGER'�� �����͸� �����Ͻÿ�(EMP_TEMP2 ���̺�)
*/
DELETE 
FROM EMP_TEMP2 
WHERE JOB='MANAGER';

SELECT * FROM EMP_TEMP2;
/*
2.����� 3�̰� �μ���ȣ�� 30�� ����� ã�Ƽ� �����Ͻÿ� SALGRADE ���̺� Ȱ��)
*/
DELETE
 FROM   EMP_TEMP2
 WHERE  DEPTNO = 30 and ( SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
                from SALGRADE SG, EMP_TEMP2 E
               WHERE E.SAL BETWEEN SG.losal AND SG.hisal
                and SG.Grade=3);
--����
DELETE
FROM EMP_TEMP2
WHERE EMPNO IN (SELECT E.EMPNO
                FROM EMP_TEMP2 E, SALGRADE S
                WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
                AND S.GRADE =3
                AND DEPTNO =30);
SELECT * FROM EMP_TEMP2;
/*
EMP_TEMP2 ���̺� ������ ��� ����
*/
DELETE FROM EMP_TEMP2;
SELECT * FROm EMP_TEMP2;
commit;

/*
==============================������===================================
*/
CREATE INDEX Student_Name
ON  Student(Name);

SELECT * FROM Student;

COMMIT;

DROP INDEX Student_Name;
