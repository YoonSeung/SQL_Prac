CREATE TABLE  Professor (
    Professor_ID VARCHAR2(3)    PRIMARY KEY,
    Name         VARCHAR2(20)   NOT NULL,
    Position     VARCHAR2(10)   NOT NULL,
    Dept_ID      VARCHAR2(10),
    Telephone    VARCHAR2(12) UNIQUE);
    
    COMMIT;
    
INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p12', '���', '�α���', '�İ�', '555-1234');

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p41', '�ȿ�ȫ', '�α���', '�濵', '555-1234'); 
--TelePhone�� ����ũ�� �����Ǿ��ֱ⶧���� ������ ���� �߰��Ϸ��ϸ� ������ ��.

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p41', '�ȿ�ȫ', '�α���', '�濵', null);

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p32', '�迵��', '������', 'ȸ��', null);
-- ������ null�� ���� ���°��̱� ������ �߰��� �����ϴ�.
COMMIT;

SELECT * FROM Professor;

DROP table Professor;
commit;

CREATE TABLE Professor(
    Professor_ID    VARCHAR2(3)     PRIMARY KEY,
    Name            VARCHAR2(20)    NOT NULL,
    Position        VARCHAR2(10)    NOT NULL constraint Prof_ck
        CHECK (Position in('����','�α���','������','���Ӱ���')),
    Dept_ID         VARCHAR2(10),
    Telephone       VARCHAR2(12)    UNIQUE);
    
commit;

INSERT INTO Professor(Professor_ID, Name, Position, Dept_ID, Telephone)
VALUES('P12','������','�α���','�İ�','555-1234');
commit;

INSERT INTO Professor(Professor_ID, Name, Position, Dept_ID, Telephone)
VALUES('P81','���ػ�','���ӱ���','�İ�','555-4567');

SELECT * FROM Professor;

-----------------------------------------------------------------------
CREATE TABLE Course(
    Course_ID       VARCHAR2(5)     PRIMARY KEY,
    Title           VARCHAR2(20)    NOT NULL,
    C_Number        NUMBER(1)       DEFAULT 3,
    Professor_ID    VARCHAR2(3),
    Course_Fees     NUMBER(7));

commit;

INSERT INTO Course
(Course_ID, Title, Professor_ID, Course_fees)
VALUES
('L1031','SOL','p12',30000);

COMMIT;

SELECT * FROM Course;

-----------------------------------------------------
--ũ�� ����
ALTER TABLE Professor
modify (POSITION VARCHAR2(15));

commit;

DESCRIB Professor;
-----------------------------------------------------

ALTER TABLE Professor
ADD (   Email   VARCHAR2(60),
        Duty    VARCHAR2(10),
        Mgr     VARCHAR2(3));

commit;

DESCRIB Professor;

ALTER TABLE Department
modify (Dept_Name VARCHAR2(15));

commit;

DESCRIB Department;
/*
-----------------------------------------
*/
ALTER SESSION SET TIME_ZONE ='9:0';
ALTER SESSION SET NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

SELECT CURRENT_DATE, ADD_months(CURRENT_DATE,10) FROM DUAL;

SELECT * FROM Student;

ALTER SESSION SET NLS__DATE_FORMAT = "YY/MM/DD";

select round(current_date),trunc(current_date)from dual;

/*
Student ���̺��� �ֹε�Ϲ�ȣ�� �̿��Ͽ� ��������� �����ϰ�, ��¥�� �����ͷ� ��ȯ�Ͽ�
����Ͻÿ�.
*/
SELECT Student_ID, Name, ID_Number, To_DATE(SUBSTR(ID_Number,1,6), 'RRMMDD') "�������"
FROM Student;

/*
 1. ���� ��¥�� �ð��� ��YYYY-MM-DD HH24:MI:SS FF3�� �������� ����Ͻÿ�.
 
 2. Student ���̺��� ���г�¥(I_Date) Į���� �����Ͽ� ��RRRR/MM/DD (DAY)�� �������� ��
���Ͻÿ�.
 3. SG_Scores ���̺��� ����(Score)�� 98�� �̻����ڿ� ���Ͽ� ���� ��� ���ڸ�
��YYYY/MM/DD�� ������ ���������� ��ȯ ����Ͻÿ�
����ؾ� �� �׸� : �л� ID, �̸� , ��������(����), ��������(������ �־��� ���ڷ�)
�л�ID, ����ID, ����, �����������(����), �����������(������ �־��� ������ ���ڷ�)
*/
SELECT STUDENT_ID, COURSE_ID, SCORE,  SCORE_ASSIGNED, TO_CHAR(SCORE_ASSIGNED, 'YYYY/MM/DD') "�����������"
FROM sg_scores
WHERE SCORE>=98
ORDER BY SCORE_ASSIGNED;

/*
��) 1. SG_Scores ���̺�κ��� ������ 98�� �̻��� ������ ���������� �����Ͽ� ����Ͻÿ�.
 2. SG_Scores ���̺��� ������ 98�� �̻��� �࿡ ���Ͽ� ������ ��S999��, ��099.99�� ��������
���ڿ��� ��ȯ�Ͻÿ�.
 3. Course ���̺��� �߰� �����Ḧ ���ڿ��� ��ȯ�Ͽ� ��999,999��, ��L999,999��, ��9.99EEEE�� ����
���� ����Ͻÿ�.
�л� ID , ����ID,����, ����,���ڷ� ��ȯ�Ǿ��� ����
�л� ID , ����ID,����, ����,���ڷ� ��ȯ�Ǿ��� ����('S999'), ���ڷ� ��ȯ�Ǿ��� ����("B999
.9'), ���ڷ� ��ȯ�Ǿ��� ����('099.99')
*/
SELECT Student_ID, Name, I_Date, TO_CHAR(I_Date, 'RRRR/MM/DD (DAY)') "��������"
FROM Student;

SELECT Student_ID, Course_ID, Score, to_char(Score, 's999'), to_char(Score, 'B999.9'),
    to_char(Score, '099.99')
FROM SG_scores
WHERE Score >=98
ORDER BY Score DESC;
