SET SERVEROUTPUT ON

DECLARE
    V_avg           NUMBER(3)   :=0;
    V_Student_ID    VARCHAR2(5) :='C0901';
BEGIN
    SELECT  AVG(Score)   INTO V_avg   
    FROM    SG_Scores
    WHERE   Student_ID = V_Student_ID;
    DBMS_OUTPUT.PUT_LINE(V_Student_ID || '�� ��� ������ ['
    || V_avg || ']�� �Դϴ�.');
END;
/
SET SERVEROUTPUT ON

DECLARE
    v       SG_Scores%ROWTYPE;
    v_cnt   NUMBER(2)   :=0;
BEGIN
    v.Student_ID    :='C0901';
    SELECT COUNT(*), AVG(Score)
        INTO v_cnt, v.Score
    FROM    SG_Scores
    WHERE   Student_ID = v.Student_ID;
    
    IF      v.Score >= 90
    THEN    v.grade :='A';
    ELSIF   v.Score >=80
        THEN v.grade :='B';
        ELSIF v.Score >=70
            THEN v.grade :='C';
            ELSIF v.Score >=60
                THEN v.grade :='D';
                ELSE v.grade :='F';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v.Student_ID || '�� ���� ���� [' || v_cnt || ']�̰� ��� ������ [' ||
                        v.Score || ']�� [' || v.grade || '] ����Դϴ�.');
END;
/

/*===================================
temp ���̺� ������ loop �Լ� ���� ��
=====================================*/
SET SERVEROUTPUT ON

CREATE TABLE TEMP (
    COL1    NUMBER(3),
    COL2    DATE);
    
SET SERVEROUTPUT ON
   
DECLARE
    MAX_No      CONSTANT    POSITIVE    := 10;
    i                       NATURAL     := 0;
BEGIN
    LOOP -- loop���� ������ exit�� �����
        i := i+1;
        EXIT    WHEN    i>MAX_No;
        INSERT INTO TEMP VALUES(i, SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEMP;

/*========================
���� �Լ��� while ȭ
==========================*/
DECLARE
    MAX_No      CONSTANT    POSITIVE    := 10;
    i                       NATURAL     := 0;
BEGIN
    WHILE i<MAX_No LOOP
        i := i+1;
        INSERT INTO TEMP VALUES(i, SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEMP;

/*========================
���� �Լ��� for�� ȭ
==========================*/
DECLARE
    MAX_No      CONSTANT    POSITIVE    := 10;
    i                       NATURAL     := 0;
BEGIN
    FOR i IN 1..MAX_NO LOOP
        INSERT INTO TEMP VALUES(i, SYSDATE);
    END LOOP;
END;
/
SELECT * FROM TEMP;

/*=========================================
2����
==========================================*/
--v_avg : ��հ� ���� ����, v_cnt:����Ǽ� ���庯��, v_Student_ID: �й� ���庯���� ���
--
SET SERVEROUTPUT ON
DECLARE
    v_avg   NUMBER(3)   :=0;
    v_cnt   NUMBER(3)   :=0;
    v_Student_ID    VARCHAR2(5) :='C0902';
BEGIN
    SELECT COUNT(Course_ID), AVG(Score) INTO v_cnt, v.Score
    FROM    SG_Scores
    WHERE   Student_ID = v_Student_ID;
  
    DBMS_OUTPUT.PUT_LINE(v_Student_ID || '�� [' || v_cnt || ']�� ���� ��� ������ [' || v_avg || '] ���Դϴ�.');
END;
/

SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.DISABLE;
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD.');
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('2.HELLO WORLD.');
END;
/
----------------�ٸ� �ǽ�
SET SERVEROUTPUT ON

DECLARE
    v_DEPTNO    NUMBER(2) DEFAULT 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_DEPTNO : '||v_DEPTNO);
END;
/

---- ���� ���� DEFAULT ��� NOT NULL ������ �� ����

DECLARE
    v_DEPTNO    NUMBER(2) NOT NULL :=10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_DEPTNO : '||v_DEPTNO);
END;
/

---- ���� ���� NOT NULL DEFAULT ������ �� ����
DECLARE
    v_DEPTNO    NUMBER(2) NOT NULL DEFAULT 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_DEPTNO : '||v_DEPTNO);
END;
/

--------------------�ٸ� �ǽ�
DECLARE
    v_DEPTNO    DEPT.DEPTNO%TYPE :=50;
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_DEPTNO : '||v_DEPTNO);
END;
/

DECLARE
    v_DEPTNO    DEPT%ROWTYPE;
BEGIN
    SELECT  DEPTNO, DNAME, LOC INTO v_DEPTNO
    FROM    DEPT
    WHERE   DEPTNO = 40;
    DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_DEPTNO.DEPTNO);
    DBMS_OUTPUT.PUT_LINE('DNAME : ' || v_DEPTNO.DNAME);
    DBMS_OUTPUT.PUT_LINE('LOC : ' || v_DEPTNO.LOC);    
END;
/

/*
1. default �� 13�� ����� v_Number ���� ����
�ش� ���� Ȧ�� �̸� 'v_Number�� Ȧ�� �Դϴ�.' �ƴϸ� 'v_Number�� ¦�� �Դϴ�.' ���
*/

DECLARE
   v_Number     NUMBER(3) DEFAULT 13;
BEGIN

IF MOD(v_Number, 2) = 1 THEN
DBMS_OUTPUT.PUT_LINE('v_Number�� Ȧ�� �Դϴ�.');
ELSE
DBMS_OUTPUT.PUT_LINE('v_Number�� ¦�� �Դϴ�.');
END IF;
END;
/

/*
2. default ���� 87�� ����� v_Score ���� ����
�ش� ���� 10���� ���� ��(���������� ���) �� 10�̸� 'A+����'/9�� 'A����' / 8�� 'B����' / 
7�� 'C����' / 6�� 'D����' / �׿ܴ� 'F����'�� ȭ�鿡 ��� �� �� �ֵ��� �Ͻÿ� ( CASE ~ WHEN THEN)
*/
SET SERVEROUTPUT ON;
DECLARE V_SCORE NUMBER(3)  DEFAULT 87;
    BEGIN CASE TRUNC(V_SCORE/10)
        WHEN 10 THEN DBMS_OUTPUT.PUT_LINE('A ����');
        WHEN 9 THEN DBMS_OUTPUT.PUT_LINE('A ����');
        WHEN 8 THEN DBMS_OUTPUT.PUT_LINE('B ����');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('C ����');
        WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('D ����');
        ELSE DBMS_OUTPUT.PUT_LINE('F ����');
    END CASE;
END;
/

/*
3��
*/
SET SERVEROUTPUT ON;
    BEGIN FOR I IN REVERSE 0..4 LOOP
    DBMS_OUTPUT.PUT_LINE('I VALUE : ' || I);
    END LOOP;
END;
/

SET SERVEROUTPUT ON

DECLARE
    TYPE        REC_DEPT    IS RECORD(
        DEPTNO      NUMBER(2)   NOT NULL :=99,
        DNAME       DEPT.DNAME%TYPE,
        LOC         DEPT.LOC%TYPE
        );
        Dept_rec    REC_DEPT;
BEGIN
    Dept_rec.DEPTNO :=99;
    Dept_rec.DNAME :='DATABASE';
    Dept_rec.LOC :='SEOUL';
    DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || Dept_rec.DEPTNO);
    DBMS_OUTPUT.PUT_LINE('DNAME : ' || Dept_rec.DNAME);
    DBMS_OUTPUT.PUT_LINE('LOC : ' || Dept_rec.LOC);
END;
/

CREATE TABLE DEPT_RECORD
AS
    SELECT * FROM DEPT;
    
DECLARE
    TYPE        REC_DEPT    IS RECORD(
        DEPTNO      NUMBER(2)   NOT NULL :=99,
        DNAME       DEPT.DNAME%TYPE,
        LOC         DEPT.LOC%TYPE
        );
        Dept_rec    REC_DEPT;
BEGIN
    Dept_Rec.DEPTNO :=99;
    Dept_Rec.DNAME :='DATABASE';
    Dept_Rec.LOC :='SEOUL';
    
    INSERT INTO DEPT_RECORD
    VALUES Dept_Rec;
END;
/

SELECT * FROM DEPT_RECORD;
/****************************
5����
*******************************/
DECLARE
    TYPE        REC_DEPT    IS RECORD(
        DEPTNO      NUMBER(2)   NOT NULL :=99,
        DNAME       DEPT.DNAME%TYPE,
        LOC         DEPT.LOC%TYPE
        );
        Dept_rec    REC_DEPT;
BEGIN
    Dept_Rec.DEPTNO :=50;
    Dept_Rec.DNAME :='DB';
    Dept_Rec.LOC :='SEOUL';
    
    UPDATE DEPT_RECORD
        SET ROW = dept_Rec
    WHERE DEPTNO = 99;
END;
/
SELECT * FROM DEPT_RECORD;

--�ٸ� �ǽ� 
-------------
DECLARE
    TYPE REC_DEPT   IS RECORD(
        DeptNo  DEPT.DEPTNO%TYPE,
        DName   DEPT.DNAME%TYPE,
        LOC     DEPT.LOC%TYPE
        );

     TYPE REC_EMP  IS RECORD(
        EmpNo   EMP.EMPNO%TYPE,
        EName   EMP.ENAME%TYPE,
        Dinfo   REC_DEPT
        );
        EMP_REC     REC_EMP;
BEGIN
    SELECT E.EMPNO, E.ENAME, D.DEPTNO, D.DNAME, D.LOC
        INTO    EMP_REC.EmpNo, EMP_REC.EName, EMP_REC.Dinfo.DeptNo,
                EMP_REC.Dinfo.DName, EMP_REC.Dinfo.Loc
    FROM        EMP E, DEPT D
    WHERE       E.DEPTNO = D.DEPTNO
        AND     E.EMPNO = '7782';
        
        DBMS_OUTPUT.PUT_LINE('EMPNO :' || EMP_REC.EmpNo);
        DBMS_OUTPUT.PUT_LINE('EName :' || EMP_REC.EName);
        DBMS_OUTPUT.PUT_LINE('DeptNo :' || EMP_REC.Dinfo.DeptNo);
        DBMS_OUTPUT.PUT_LINE('DName :' || EMP_REC.Dinfo.DName);
        DBMS_OUTPUT.PUT_LINE('Loc :' || EMP_REC.Dinfo.Loc);
END;
/

--�ٸ� �ǽ�
------------------------------
DECLARE
    TYPE    ITAB_EX     IS TABLE OF VARCHAR2(20)
        INDEX BY PLS_INTEGER;
    text_arr    ITAB_EX;
BEGIN
    text_arr(1) := '1st data';
    text_arr(2) := '2nd data';
    text_arr(3) := '3rd data';
    text_arr(4) := '4th data';
    
        DBMS_OUTPUT.PUT_LINE('text_arr(1) :'|| text_arr(1));
        DBMS_OUTPUT.PUT_LINE('text_arr(2) :'|| text_arr(2));
        DBMS_OUTPUT.PUT_LINE('text_arr(3) :'|| text_arr(3));
        DBMS_OUTPUT.PUT_LINE('text_arr(4) :'|| text_arr(4));
        
END;
/

/*
================6����====================
*/
DECLARE
    TYPE    REC_DEPT    IS RECORD(
        DEPTNO  DEPT.DEPTNO%TYPE,
        DNAME   DEPT.DNAME%TYPE
        );
        
        TYPE    ITAB_DEPT   IS TABLE OF REC_DEPT
            INDEX BY PLS_INTEGER;
            
        DEPT_ERR    ITAB_DEPT;
        idx     PLS_INTEGER :=0;
BEGIN
    FOR i IN (SELECT DEPTNO, DNAME FROM DEPT) LOOP
        idx := idx+1;
        DEPT_ERR(idx).DEPTNO := i.DEPTNO;
        DEPT_ERR(idx).DNAME := i.DNAME;
        
        DBMS_OUTPUT.PUT_LINE(DEPT_ERR(idx).DEPTNO || ' : ' || DEPT_ERR(idx).DNAME);
        END LOOP;
    END;
    /

---
DECLARE
        TYPE    ITAB_DEPT   IS TABLE OF DEPT%ROWTYPE
            INDEX BY PLS_INTEGER;
            
        DEPT_ERR    ITAB_DEPT;
        idx     PLS_INTEGER :=0;
BEGIN
    FOR i IN (SELECT * FROM DEPT) LOOP
        idx := idx+1;
        DEPT_ERR(idx).DEPTNO := i.DEPTNO;
        DEPT_ERR(idx).DNAME := i.DNAME;
        DEPT_ERR(idx).LOC := i.LOC;
        
        DBMS_OUTPUT.PUT_LINE(DEPT_ERR(idx).DEPTNO || ' : ' || DEPT_ERR(idx).DNAME || ' : ' || DEPT_ERR(idx).LOC);
        END LOOP;
    END;
    /
    
DROP TABLE DEPT_PK;
DROP TABLE DEPT_RECORD;
DROP TABLE DEPT_SEQUENCE;
DROP TABLE EMP_FK;
DROP TABLE T_COURSE;
DROP TABLE TABLE_CHECK;
DROP TABLE TABLE_PK;
DROP TABLE TEMP;

COMMIT;

CREATE TABLE PATIENT(
    Patient_ID          VARCHAR2(6),
    Body_Temp_Deg_C     NUMBER(4,1),
    Body_Temp_Deg_F     NUMBER(4,1),
    INSURANCE           VARCHAR2(1));
    
SELECT * FROM PATIENT;

DECLARE
    v_Patient_ID        patient.patient_id%TYPE;
    v_Temp_Deg_C        NUMBER(4,1) :=0;
    v_Temp_Deg_F        NUMBER(4,1) :=0;
BEGIN
    v_Patient_ID := 'YB0001';--1��°
    v_Temp_Deg_C := 40.0;
    v_Temp_Deg_F := (9.0/5.0)*v_temp_deg_c+32.0;
    
    INSERT INTO patient
        (Patient_ID, BODY_TEMP_DEG_C, BODY_TEMP_DEG_F)
        VALUES
        (v_Patient_ID, v_Temp_Deg_C, v_Temp_Deg_F);

    v_Patient_ID := 'YB0002';--2��°
    v_Temp_Deg_C := 41.0;
    v_Temp_Deg_F := (9.0/5.0)*v_temp_deg_c+32.0;
    
    INSERT INTO patient
        (Patient_ID, BODY_TEMP_DEG_C, BODY_TEMP_DEG_F)
        VALUES
        (v_Patient_ID, v_Temp_Deg_C, v_Temp_Deg_F);
        
                
    END;
    /
SELECT * FROM patient;
ROLLBACK;


/*==================================================
��������
*/

DECLARE
    v_Patient_ID        patient.patient_id%TYPE;
    v_Temp_Deg_C        NUMBER(4,1) :=0;
    --���ν��� �������α׷� --
    PROCEDURE Body_Temp_Change_F(f_Patient_ID VARCHAR2, f_Temp_Deg_C NUMBER) IS
        f_Temp_Deg_F    NUMBER(4,1) :=0;
        
BEGIN
    f_Temp_Deg_F := (9.0/5.0)*f_temp_deg_c+32.0;

    INSERT INTO patient
        (Patient_ID, BODY_TEMP_DEG_C, BODY_TEMP_DEG_F)
        VALUES
        (v_Patient_ID, v_Temp_Deg_C, f_Temp_Deg_F);
                
    END;
BEGIN
    v_Patient_ID := 'YN0001';
    v_Temp_Deg_C := 40.0;
    Body_Temp_Change_F(v_Patient_ID, v_Temp_Deg_C);
    v_Patient_ID := 'YN0002';
    v_Temp_Deg_C := 41.0;
    Body_Temp_Change_F(v_Patient_ID, v_Temp_Deg_C);
    END;
/

--�ٸ� �ǽ�
DECLARE
    v_Deg_C     NUMBER(4,1) :=0;
    v_Deg_F     NUMBER(4,1) :=42;
    --���� �Լ� ���α׷� --
    FUNCTION Temp_Change_C(f_Temp_Deg_F NUMBER)
        RETURN NUMBER IS
            f_Deg_C NUMBER(4,1) :=0;
        BEGIN
            f_Deg_C :=(9.0/5.0) * f_Temp_Deg_F + 32.0;
            RETURN f_Deg_C;
        END;
BEGIN
    v_Deg_C := Temp_Change_C(v_Deg_F);
    DBMS_OUTPUT.PUT_LINE('['||v_Deg_F ||'] ȭ�� �µ��� ���� �µ��� ['||v_Deg_C||']�� �Դϴ�.');
    END;
    /
    
/*=====================================
������
*/
CREATE OR REPLACE PROCEDURE Body_Temp_Change_F
        (f_Patient_ID VARCHAR2, f_Temp_Deg_C Number) IS
    f_Temp_Deg_F    NUMBER(4,1) :=0;
BEGIN
    f_Temp_Deg_F := (9.0/5.0) * f_Temp_Deg_C + 32.0;
    INSERT INTO Patient
        (Patient_ID, Body_Temp_Deg_C, Body_Temp_Deg_F)
        VALUES
            (f_Patient_ID,f_temp_Deg_C, f_Temp_Deg_F);
        COMMIT;
END;
/

EXECUTE Body_Temp_Change_F('YN0005',43.0);

SELECT * FROM Patient;

CREATE OR REPLACE FUNCTION Temp_Change_C(f_Temp_Deg_F NUMBER)
    RETURN NUMBER IS
    f_Deg_C NUMBER(4,1) :=0;
BEGIN
    f_Deg_C :=(5.0/9.0)*(f_Temp_Deg_F-32.0);
    RETURN f_Deg_C;
END;
/

SELECT Patient_ID, Body_Temp_Deg_F,
        Temp_Change_C(Body_Temp_Deg_F)
FROM Patient;

DROP PROCEDURE Body_Temp_Change_F;
DROP FUNCTION TEMP_CHANGE_C;

/*
1. �Լ��� : Member_Gender(Regist_NO),���κ��� : v_Gender(������ 1byte), v_Gender_Name(������, 6byte)
Regist_NO���� ���� ���ڰ�(�ֹι�ȣ)�� �޹�ȣ ù���� �Ѱ��� �����Ͽ� �� ���� '1'�̸� '����','2'�̸� '����'��� ���� ���κ��� v_Gender_Name�� �����ϰ� �� ���� �����ϴ� �Լ� ����
Ȯ�ι�� : SELECT Member_Gender('710000-2******') FROM DUAL;
*/

CREATE OR REPLACE FUNCTION Member_Gender(Regist_NO VARCHAR2)
    RETURN VARCHAR2 IS
    v_Gender        VARCHAR2(1);
    v_Gender_Name   VARCHAR2(6);
    
BEGIN
   v_Gender := SUBSTR(regist_NO, 8 ,1);
   IF v_Gender = '1' THEN v_Gender_Name :='����';
    ELSIF   v_Gender = '2' THEN v_Gender_Name :='����';
    ELSE    v_Gender_Name :=NULL;
    END IF;
    RETURN v_gender_Name;
END;
/

SELECT Member_Gender('710000-2******') FROM DUAL;

