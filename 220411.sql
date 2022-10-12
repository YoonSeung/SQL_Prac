--22��4�� 11�� ������
/*
 1. SG_Scores ���̺�κ��� ��C0901�� �л��� ����[�й�, �����ڵ�, �����, ����]�� ����Ͻÿ�.
*/
SELECT * 
FROM SG_Scores
WHERE Student_ID='C0901';

--Score_List view ����
--��, SG_Scores�� Coures �� �� ���� ���̺��� �й�, �����ڵ�, �����, ���� ������ ������ view ����
CREATE View Score_List
AS
    SELECT  Student_ID, Course_ID, Title, Score
    FROM    SG_Scores Join Course Using(Course_ID);
    
DESCRIB Score_List;

/*
 3. Course ���̺�� Professor ���̺�κ��� ������ ��� ���� ���� ����ϴ� �並 �����ϰ�, 
�� ��κ��� ������ȣ, ������, ���� ���� ����Ͻÿ�.
*/
CREATE VIEW Professor_Course_Count
(Professor_ID, Name, Course_Cnt)
AS
    SELECT  Professor_ID, Name, COUNT(*)
    FROM   Professor Join Course USING(Professor_ID)
    GROUP BY Professor_ID, Name;

 /*
 4. Student ���̺�κ��� ���İ����а� �л��� ���� Student_Computer �並 �����ϰ�, ��κ�
�� (�а��ڵ�, �г�, �й�, ����, �ֹε�Ϲ�ȣ, ��ȭ��ȣ)�� ����Ͻÿ�.
*/
CREATE View Student_Computer
AS
    SELECT  DEPT_ID, Year, Student_ID, Name, ID_Number, Telephone
    FROM    Student
    WHERE   DEPT_ID = '�İ�';
    
-- (�߰�����) �信 ���� ���� �� Ȯ��
INSERT INTO Student_Computer
VALUES('�İ�', 2, 'C0905', '���̳�', '910909-2******','011-999-1111');

SELECT * FROM Student_Computer
WHERE Student_ID = 'C0905';

--�信 ��������ϸ� ���̺��� ������ �� ( �䰡 ���̺�� �Ѱ��� ����Ǿ���������)
SELECT * FROM Student
WHERE Student_ID = 'C0905';

-- �ݴ��� ��쵵 ���� ( ���̺� ���� �߰��ϰ� �並 Ȯ��)
INSERT INTO Student (Dept_ID, Year, Student_ID, Name, ID_Number, Telephone)
VALUES('�İ�', 3, 'C0932', '������', '940909-2******','011-999-1111');

SELECT * FROM Student_Computer
WHERE Student_ID = 'C0932';

/*
========================<2����>================================
*/
SELECT * FROM USER_VIEWS; --���� �ý��ۿ� ������ �� ��� ����

/*
6. Student_Computer �並 �����Ͻÿ�
*/
DROP VIEW Student_Computer;

/*
SG_Scores ���̺��� ������ ������ ������������ ���
1 �������� ����� ���� ���� �� 10��(1�� ~ 10��)�� �й�, ����, �����, ������, ����, ����� ���
*/
SELECT  Student_ID, Course_ID, Title, C_number, Score, Grade
FROM    sg_scores Join Course Using(Course_ID)
Order by Score DESC, C_Number DESC; --DESC �� ��������

SELECT ROWNUM "����", a.*
FROM    (   SELECT  SG.Student_ID, Name, Title, C_Number, Score, Grade
            FROM    SG_Scores SG Join Course C
                        ON (SG.Course_ID = C.Course_ID)
                        Join Student S
                        ON (SG.Student_id = S.Student_ID)
            Order BY SG.Score DESC, C_Number DESC) a
WHERE   ROWNUM<=10;

/*
�� Ŀ�������� ������ 21 ~ 30 � �ش��ϴ� �л��� ��ȸ
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
==============<3����>=============================
*/
--DEPT_SEQ ������ ���� �� Ȱ��
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
(CONCAT('C', LTRIM(TO_CHAR(ST_SEQ.NEXTVAL, '0999'))),'&�а�','&�г�','&����','&�ֹι�ȣ','&�����ּ�');

DROP SEQUENCE DEPT_SEQ;


SELECT * FROM TAB;

SELECT * FROM USER_CATALOG;

SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'PROFESSOR'; -- ��ҹ��� �����ϴϱ� ���� �Ұ�

COLUMN CONSTRAINT_NAME FORMAT A14
COLUMN SEARCH_CONDITION FORMAT A14
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'COURSE';

--����Ű�� ��Ȱ��ȭ ��Ŵ
ALTER TABLE Professor
DISABLE CONSTRAINT PROFESSOR_FK;

INSERT INTO professor
(Professor_ID, Name, Position, DEPT_ID, Telephone, Email)
VALues('S11', '���ι�', '����', '����', '123-4567', null);

SELECT * FROM Professor;

--����Ű�� Ȱ��ȭ ��Ŵ ( �����㲨�� �ֳ� �̹� ����Ű ���� ���� �����س��� �ȵ� )
ALTER TABLE Professor
ENABLE CONSTRAINT PROFESSOR_FK;

-- �Ʒ� ���� ������ ���� �ڵ� �����ϸ� �� 
DELETE FROM Professor
WHERE Professor_ID = 'S11';

SELECT * FROM Professor;

SELECT * 
FROM USER_INDEXES;

SELECT * 
FROM USER_IND_COLUMNS;

--EMP ���̺� �޿� Į���� IDX_EMP_SAL ��� �ε��� ����
-- ������ �ε��� Ȯ��
-- ������ �ε��� ����
CREATE INDEX IDX_EMP_SAL
ON  EMP(SAL);

SELECT * 
FROM USER_IND_COLUMNS
WHERE INDEX_NAME = 'IDX_EMP_SAL';

DROP INDEX IDX_EMP_SAL;

--EMP ���̺��� �����ȣ, �����, ��å, �μ���ȣ�� ������ 'VW_EMP20' �� ����
--�� �μ���ȣ�� 20�� �����θ� �����Ǵ� ���
CREATE VIEW VW_EMP20
AS
    SELECT EMPNO, ENAME , JOB, DEPTNO
    FROM   EMP
    WHERE DEPTNO = 20;

SELECT * FROM VW_EMP20;
--emp ���̺� ������ ��ȸ�ϵ� �� �տ� ROWNUM�� ǥ���Ǿ� ��ȸ�� �Ǿ�� �ϰ�,
-- �޿��� ������������ ���ĵǾ� ȭ�鿡 ��ȸ ���(�ζ��κ�)

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
========================<5����>==================================
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

--������ ����
ALTER SEQUENCE SEQ_DEPT
    INCREMENT BY 3
    MAXVALUE 99
    CYCLE;
    
SELECT * FROM USER_SEQUENCES;

INSERT INTO DEPT_SEQUENCE
(DEPTNO, DNAME, LOC)
VALUES
(SEQ_DEPT.nextval,'JSP','SEOUL');

--������ ���� �� ���� Ȯ��
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
SET     LOGIN_ID='TEST_ID_03' -- 01�δ� �ȵ� �ֳ� �̹� 01 �� �ֱ⶧����
WHERE LOGIN_ID IS NULL;

ALTER TABLE TABLE_UNIQUE
MODIFY(TEL UNIQUE); -- ������ �ߺ��� ���� ������ �ȵ�

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
=========================<6����>===================================
*/

ALTER TABLE TABLE_UNIQUE2 -- �������� �̸� ����
RENAME CONSTRAINT TBLUNQ2_TEL_UNQ TO TEL_UNQ;

SELECT*
FROm USER_CONSTRAINTS
WHERE TABLE_NAME = 'TABLE_UNIQUE2';

ALTER TABLE TABLE_UNIQUE2 -- �������� ����
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
('TEST_ID_01','PWD02','010-234-2345');  -- ������ ID�� �����̸Ӹ� Ű

SELECT * FROM TABLE_PK;

INSERT INTO TABLE_PK
(LOGIN_ID, LOGIN_PWD, TEL)
VALUES
(NULL,'PWD01','010-123-1234'); -- �����̸Ӹ�Ű�� null���̿��� ����

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
���̺�� : TABLE_CHECK
�÷� : LOGIN ID, LOGIN_PWD, TEL / VARCHAR2(20) LOGIN_ID �� PRIMARY KEy
LOGIN_PWD �÷� CHECK ���������� �����ϴµ� �ش� �÷��� ����Ǵ� �����Ͱ� 3�ڸ��̻� ����������
�� �� �ֵ��� check �������� ����
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
VALUES('TEST_ID2','12','010-123-2323'); -- ������ ��й�ȣ �������Ƕ���

SELECT * FROM TABLE_CHECK;

--tel �÷��� default�� ����� ���� '010-000-0000'�� ����

ALTER TABLE TABLE_CHECK
MODIFY TEL Default '010-000-0000';

ALTER TABLE TABLE_CHECK
ADD COMM VARCHAR2(20) DEFAULT 'COMM';

DESCRIB TABLE_CHECK;


INSERT INTO TABLE_CHECK
VALUES('TEST_ID5','1234',default, default);

