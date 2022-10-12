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

/* Student ���̺� ����*/    
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

/*professor ���̺����*/                  
CREATE TABLE Professor(
Professor_ID     VARCHAR2(3),
NAME            VARCHAR2(10)        NOT NULL,
Position        VARCHAR2(20)        NOT NULL    CONSTRAINT Prof_ck
                CHECK (Position in ('����','����','�α���','������','���Ӱ���')),
Dept_ID         VARCHAR2(10),
Telephone       VARCHAR2(12)        UNIQUE,
Email           VARCHAR2(20)        UNIQUE,
Duty            VARCHAR2(10),
Mgr             VARCHAR2(3),
CONSTRAINT  Professor_pk    PRIMARY KEY(Professor_ID),
CONSTRAINT  Professor_fk    FOREIGN KEY(Dept_ID)
            REFERENCES      Department);

/*course ���̺����*/            
CREATE TABLE Course(
Course_ID       VARCHAR2(5),
Title           VARCHAR2(20)    NOT NULL,
C_Number        NUMBER(1)       NOT NULL,
Professor_ID    VARCHAR2(3),
Course_Fees     NUMBER(7),
CONSTRAINT  Course_pk   PRIMARY KEY(Course_ID),
CONSTRAINT  Course_fk   FOREIGN KEY(Professor_ID)
            REFERENCES Professor);
            
/*course ���̺����*/  
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
INSERT INTO department VALUES ('�İ�','��ǻ�Ͱ��а�','765-4100');
INSERT INTO department VALUES ('����','������Ű��а�','765-4200');
INSERT INTO department VALUES ('�濵','�濵�а�','765-4400');
INSERT INTO department VALUES ('����','���������а�','765-4500');

INSERT INTO Student  VALUES
('�İ�','1','C1001','�����','920101-1******','����� ���ı�', '01-932-9999', 
 'c1001@cyber.ac.kr',Null,'2010/03/01');
INSERT INTO Student  VALUES
('�İ�','1','C1002','������','920521-2******','������ �����', '041-343-8838',
 'c10032cyber.ac.kr','H', '2010/03/01');
INSERT INTO Student  VALUES
('�İ�','2','C0901','������','911109-2******','�뱸�� ������', Null,          
 'c0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('�İ�','2','C0902','���ֿ�','920917-1******','�泲 ���ؽ�',   '010-555-1616',          
 'c0902@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('�İ�','3','C0801','�ѿ���','900708-1******','�λ�� ������', '016-999-0101',          
 'c0801@cyber.ac.kr',Null,'2008/03/05');
INSERT INTO Student  VALUES
('�İ�','3','C0802','�����','890205-2******','����� ��������','010-333-0707',         
 'c0802@cyber.ac.kr',Null,'2008/03/05');
INSERT INTO Student  VALUES
('����','1','T1001','�躴ȣ','891124-1******','�뱸�� �޼���',  '011-222-0303',         
  Null,              Null,'2010/03/05');
INSERT INTO Student  VALUES
('����','2','T0901','������','901117-1******','�泲 õ�Ƚ�',    Null,          
 't0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('�濵','1','B1001','�����','930422-2******','����� ����',  Null,
  Null,              Null,'2010/03/05');
INSERT INTO Student  VALUES
('�濵','2','B0901','���','761225-1******','������ ������',  Null,         
 'b0901@cyber.ac.kr',Null,'2009/03/06');
INSERT INTO Student  VALUES
('����','1','A1001','�̹̳�','901217-2******','���� �����',    '010-888-5050',         
  Null, Null,'2008/03/05');

/**********************************************************
*  Professor ���̺� �ߺ� ������
***********************************************************/
INSERT INTO Professor VALUES
 ('P11', '�ű��', '����',    '�İ�','765-4111','ksshin@cyber.ac.kr','�а���','P00');
INSERT INTO Professor VALUES
 ('P12', '�̴�ȣ', '�α���',  '�İ�','765-4112','dhlee@cyber.ac.kr', Null,    'P11');
INSERT INTO Professor VALUES
 ('P13', '���ҿ�', '���Ӱ���','�İ�','765-4113','syyoo@cyber.ac.kr',Null,    'P11');
INSERT INTO Professor VALUES
 ('P21', '������', '�α���',  '����','765-4211','jspark@cyber.ac.kr','�а���','P00');
INSERT INTO Professor VALUES
 ('P22', '���ϴ�', '������',  '����','765-4212','hnkim@cyber.ac.kr',  Null,    'P21');
INSERT INTO Professor VALUES
 ('P23', '�̻���', '���Ӱ���','����','765-4213','shlee@cyber.ac.kr', Null,    'P21');
INSERT INTO Professor VALUES
 ('P41', '�ȿ�ȫ', '�α���',  '�濵','765-4411','yhahn@cyber.ac.kr','�а���', 'P00');
INSERT INTO Professor VALUES
 ('P51', '�Կ���', '�α���',  '����','765-4511','yaham@cyber.ac.kr','�а���', 'P00');

/**********************************************************
*  Course ���̺� �ߺ� ������
***********************************************************/
INSERT INTO Course VALUES ('L1011','��ǻ�ͱ���',    2,'P11',Null);
INSERT INTO Course VALUES ('L1012','��������',      2, Null,20000);
INSERT INTO Course VALUES ('L1021','�����ͺ��̽�',  2,'P12',Null);
INSERT INTO Course VALUES ('L1022','������Ű���',  2,'P21',Null);
INSERT INTO Course VALUES ('L1031','SQL',           3,'P12',30000);
INSERT INTO Course VALUES ('L1032','�ڹ����α׷���',3,'P13',Null);
INSERT INTO Course VALUES ('L1041','��ǻ�ͳ�Ʈ��ũ',2,'P21',Null);
INSERT INTO Course VALUES ('L1042','Delphi',        3,'P13',50000);
INSERT INTO Course VALUES ('L1051','����������',    2,'P11',Null);
INSERT INTO Course VALUES ('L1052','���ڻ�ŷ�',    3,'P22',30000);
INSERT INTO Course VALUES ('L2031','�����̷�',      3,'P23',50000);
INSERT INTO Course VALUES ('L0011','TOEIC����',     2, Null,Null);
INSERT INTO Course VALUES ('L0012','���а� ����',   2, Null,Null);
INSERT INTO Course VALUES ('L0013','���а���',      2, Null,Null);

/**********************************************************
*  SG_Scores ���̺� �ߺ� ������
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

