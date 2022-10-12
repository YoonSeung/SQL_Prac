CREATE OR REPLACE FUNCTION Member_YYMM(Timestamp DATE)
    RETURN VARCHAR2 IS
    v_Months    NUMBER(3);
    v_YY        NUMBER(3);
    v_MM        NUMBER(3);
    v_Between   VARCHAR2(20);
BEGIN
    v_Months    := FLOOR(MONTHS_BETWEEN(SYSDATE, Timestamp));
    v_YY        := TRUNC(v_Months / 12);  --�� ���ϱ�
    v_MM        := MOD(v_Months,12); --������ ���ϱ�
    v_Between   := To_CHAR(v_YY,'99') || '��' || To_CHAR(v_MM, '999') || '����';
    RETURN v_Between;
END;
/

SELECT Member_YYMM('2020/03/13') FROM DUAL;

/*�ٸ��ǽ�*/

CREATE OR REPLACE PACKAGE Example IS
    PROCEDURE Body_Temp_Change_F
        (f_Patient_ID IN VARCHAR2, f_Temp_Deg_C In NUMBER);
    FUNCTION Temp_Change_C
        (f_Temp_Deg_F IN NUMBER)
        RETURN Number;
    END;
/
--��Ű�� ���� ����
CREATE OR REPLACE PACKAGE BODY Example IS
    p_Count     NUMBER(3)       :=0;
    zip_Code    VARCHAR2(9);
    I           BINARY_INTEGER  :=0;
    K CONSTANT POSITIVE         :=100;
    TYPE Record_Type IS RECORD(
        v_Dept_ID   Department.Dept_ID%TYPE,
        v_Dept_Name Department.Dept_Name%TYPE);
    PROCEDURE Body_Temp_Change_F
        (f_Patient_ID VARCHAR2, f_Temp_Deg_C NUMBER) IS
        f_Temp_Deg_F NUMBER(4,1) :=0;
        BEGIN
            f_Temp_Deg_F :=(9.0/530) * f_Temp_Deg_C+32.0;
            INSERT INTO Patient
            (Patient_ID, Body_Temp_Deg_C, Body_Temp_Deg_F)
            VALUES
            (f_Patient_ID, f_Temp_Deg_C, f_Temp_Deg_F);
            COMMIT;
        END;
    FUNCTION Temp_Change_C (f_Temp_Deg_F NUMBER)
        RETURN NUMBER IS
        f_Deg_C NUMBER(4,1) :=0;
        BEGIN
            f_Deg_C := (5.0/9.0)*(f_Temp_Deg_F - 32.0);
            RETURN f_Deg_C;
        END;
    END;
/

SELECT Patient_ID, Body_Temp_Deg_F, Example.Temp_Change_C(Body_Temp_Deg_F)
FROM patient;

/*���� �ǽ�*/
CREATE OR REPLACE PROCEDURE pro_noparam
IS
    v_EMPNO     NUMBER(4)   :=7788;
    v_ENAME     VARCHAR2(10);
BEGIN
    v_ENAME :='SCOTT';
    DBMS_OUTPUT.PUT_LINE('v_EMPNO : '|| v_EMPNO);
    DBMS_OUTPUT.PUT_LINE('v_ENAME : '|| v_ENAME);
END;
/

SET SERVEROUTPUT ON;

EXECUTE pro_noparam;

SELECT TEXT
FROM USER_SOURCE
WHERE NAME = 'PRO_NOPARAM';

DROP PROCEDURE pro_noparam;
----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pro_param_in
(param1 IN NUMBER, param2 NUMBER, param3 NUMBER :=3, param4 NUMBER DEFAULT 4)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('param1 : ' || param1);
    DBMS_OUTPUT.PUT_LINE('param2 : ' || param2);
    DBMS_OUTPUT.PUT_LINE('param3 : ' || param3);
    DBMS_OUTPUT.PUT_LINE('param4 : ' || param4);
END;
/

EXECUTE pro_param_in(1,2,9,8);
EXECUTE pro_param_in(1,2); -- �� �ֳ� �̹� ���� ���ν��� �����Ҷ� 3,4 �� ����Ʈ�� �־����
EXECUTE pro_param_in(param1=>10, param2=>20);

CREATE OR REPLACE PROCEDURE pro_param_out
(in_empno IN EMP.EMPNO%TYPE, out_ename OUT EMP.ENAME%TYPE, out_sal OUT EMP.SAL%TYPE)
IS
BEGIN
    SELECT ENAME, SAL INTO out_ename, out_sal 
    FROM EMP
    WHERE EMPNO = in_empno;
    
END pro_param_out;
/

DECLARE
    v_ename     EMP.ENAME%TYPE;
    v_sal       EMP.SAL%TYPE;
BEGIN
    pro_param_out(7782,v_ename,v_sal);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||v_ename);
    DBMS_OUTPUT.PUT_LINE('SAL : '||v_sal);
END;
/

/*�ٸ� �ǽ�*/
CREATE OR REPLACE PROCEDURE pro_param_inout
(inout_no IN OUT NUMBER)
IS
BEGIN
    inout_no := inout_no *2;
END pro_param_inout;
/

DECLARE
    no NUMBER;
BEGIN
    no :=5;
    pro_param_inout(no);
    DBMS_OUTPUT.PUT_LINE('NO : '|| no);
END;
/

/*CREATE OR REPLACE PROCEDURE pro_err -- ������ �Ϻη� ���� �� ���� �ؿ� �ǽ��� ����
IS
    err_no  NUMBER;
BEGIN
    err_no =100;
    DMBS_OUTPUT.PUT_LINE('err_no : '|| err_no);
END pro_err;
/

SHOW ERRORS; --���� ����

SELECT * -- where�� ������ ���� ���� Ȯ���ϱ�
FROM USER_ERRORS
WHERE NAME = 'PRO_ERR';
*/
/*�����ǽ�*/

CREATE OR REPLACE FUNCTION func_aftertax(
    sal IN NUMBER --in �ǹ�  : �Լ� �����Ҷ� ������ ���� �޾Ƽ� ���������� ���� ����
    )
    RETURN NUMBER
IS
    tax NUMBER := 0.05;
BEGIN
    RETURN(ROUND(sal - (sal*tax)));
END;
/

SELECT func_aftertax(3000) FROM DUAL;

SELECT EMPNO, ENAME, func_aftertax(SAL) AS AFTERTAX
FROM EMP;

DROP FUNCTION func_aftertax;

/*�����ǽ�*/
CREATE OR REPLACE PACKAGE pkg_example
IS
    spec_no     NUMBER :=10;
    FUNCTION    func_aftertax(sal NUMBER) RETURN NUMBER;
    PROCEDURE   peo_emp(in_empno IN EMP.EMPNO%TYPE);
    PROCEDURE   pro_dept(in_deptno IN DEPT.DEPTNO%TYPE);
END;
/

SELECT TEXT
FROM USER_SOURCE
WHERE TYPE = 'PACKAGE' AND NAME = 'PKG_EXAMPLE';

CREATE OR REPLACE PACKAGE BODY PKG_EXAMPLE
IS
     body_no NUMBER :=10;
     FUNCTION func_aftertax(sal NUMBER) RETURN NUMBER
     IS
        tax NUMBER :=0.05;
    BEGIN
        RETURN (ROUND(sal - (sal*tax)));
    END func_aftertax;
        
    PROCEDURE peo_emp(in_empno IN EMP.EMPNO%TYPE)
        IS
            out_ename   EMP.ENAME%TYPE;
            out_sal     EMP.SAL%TYPE;
        BEGIN
            SELECT ENAME, SAL INTO out_ename, out_sal
            FROM EMP
            WHERE EMPNO=in_empno;
            
            DBMS_OUTPUT.PUT_LINE('ENAME : '||out_ename);
            DBMS_OUTPUT.PUT_LINE('SAL : '||out_sal);
        END peo_emp;
        
        PROCEDURE pro_dept(in_deptno IN DEPT.DEPTNO%TYPE)
            IS
                out_dname      DEPT.DNAME%TYPE;
                out_loc        DEPT.LOC%TYPE;
            BEGIN
                SELECT DNAME, LOC INTO out_dname, out_loc
                FROM DEPT
                WHERE DEPTNO = in_deptno;
                DBMS_OUTPUT.PUT_LINE('DNAME : '|| out_dname);
                DBMS_OUTPUT.PUT_LINE('LOC : '|| out_loc);
            END pro_dept;
    END;
    /
    
BEGIN
    pkg_example.peo_emp(7782);
    pkg_example.pro_dept(10);
    DBMS_OUTPUT.PUT_LINE('after-tax : ' || pkg_example.func_aftertax(5000));
END;
/

/*���� �ǽ�*/
CREATE OR REPLACE PACKAGE pkg_overload
IS
    PROCEDURE   pro_emp(in_empno IN EMP.EMPNO%TYPE);
    PROCEDURE   pro_emp(in_ename IN EMP.ENAME%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_overload
IS
    PROCEDURE   pro_emp(in_empno IN EMP.EMPNO%TYPE)
        IS
            out_ename   EMP.ENAME%TYPE;
            out_sal     EMP.SAL%TYPE;
        BEGIN
            SELECT ENAME, SAL INTO out_ename, out_sal
            FROM    EMP
            WHERE   EMPNO = in_empno;
            
             DBMS_OUTPUT.PUT_LINE('ename : ' ||out_ename);
             DBMS_OUTPUT.PUT_LINE('sal : ' ||out_sal);
        END pro_emp;
        
    PROCEDURE   pro_emp(in_ename IN EMP.ENAME%TYPE)
        IS
            out_ename   EMP.ENAME%TYPE;
            out_sal     EMP.SAL%TYPE;
        BEGIN
            SELECT ENAME, SAL INTO out_ename, out_sal
            FROM    EMP
            WHERE   ENAME = in_ename;
            
             DBMS_OUTPUT.PUT_LINE('ename : ' ||out_ename);
             DBMS_OUTPUT.PUT_LINE('sal : ' ||out_sal);
        END pro_emp;   
END;
/
BEGIN
    pkg_overload.pro_emp(7782);
    pkg_overload.pro_emp('FORD');
END;
/
/*
���� ���� �ð�
*/

SET SERVEROUTPUT ON;

BEGIN
    INSERT INTO Department
    VALUES('�İ�', '��ǻ�Ͱ��а�','765-4200');
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_On_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('<�ߺ��� �ε��� ���� �߻�!!!!>');
    WHEN OTHERS THEN
        NULL;
END;
/

SELECT * FROM Department;

BEGIN
    UPDATE  Course
    SET     Course_Fees = '�︸��'
    WHERE   Course_ID='L1031';
    COMMIT;
EXCEPTION
    WHEN Invalid_Number THEN
        DBMS_OUTPUT.PUT_LINE('<�߸��� ���� ���� ���!!!>');
    WHEN OTHERS THEN
        NULL;
END;
/

INSERT INTO SG_Scores
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('B1001','L0013',107,'2010/12/29');

COMMIT;

DECLARE
    Over_Score      EXCEPTION;
    v_Score         SG_Scores.Score%TYPE;
BEGIN
    FOR Loop_rec IN (SELECT * FROM SG_Scores) LOOP
        IF LOOP_rec.Score > 100
            THEN v_Score := Loop_rec.Score;
                RAISE Over_score;
        END IF;
    END LOOP;
EXCEPTION
    WHEN    Over_Score THEN 
        DBMS_OUTPUT.PUT_LINE(v_Score ||'������ 100�� �ʰ� �Դϴ�.');
END;
/

DECLARE
    v_Title         Course.Title%TYPE;
    v_Professor_ID  Professor.Professor_ID%TYPE :='P12';
BEGIN
    SELECT Title INTO v_Title
    FROM    Professor JOIN course USING(Professor_ID)
    WHERE   Professor_ID = v_Professor_ID;
    DBMS_OUTPUT.PUT_LINE(v_Professor_ID ||'������ ['||v_Title||']�� �����մϴ�.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SLQCODE : '||TO_CHAR(SQLCODe));
        DBMS_OUTPUT.PUT_LINE('SLQERRM : '||SQLERRM);
END;
/

SELECT * FROM Course
WHERE Professor_ID = 'P12';

/*�ٸ��ǽ�
*/
DECLARE
    v_dept      Department%ROWTYPE;
    CURSOR      Get_Dept    IS
        SELECT  * FROM Department
        ORDER BY Dept_ID;

BEGIN
    OPEN Get_Dept;
    LOOP
        FETCH Get_Dept INTO v_Dept;
        Exit    WHEN    Get_Dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_Dept.Dept_ID || ' : ' || v_Dept.Dept_Name);
    END LOOP;
    CLOSE get_Dept;
END;
/
    
DECLARE
    CURSOR Get_Dept IS
        SELECT * FROM Department
        ORDER BY Dept_ID;
BEGIN
    FOR LOOP_Rec IN Get_Dept LOOP
        DBMS_OUTPUT.PUT_LINE(Get_Dept%ROWCOUNT || '��° ����� ���� ' || Loop_rec.Dept_ID || ' : ' ||Loop_Rec.Dept_Name);
    END LOOP;
END;
/

/*���� ���� */
--Ŀ���� : c1, Dept ���̺� DEPTNO�� '40'�� �����͸� ��ȸ�� Ŀ���� ���� �� �Ʒ��� ���� ���
/*
    DEPTNO : 40
    DNAME : OPERATIONS
    LOC : BOSTON
    */
 DECLARE
    v_dept      Dept%ROWTYPE;
    CURSOR      c1    IS
        SELECT  * FROM DEPT
        WHERE DEPTNO = 40;
BEGIN
    OPEN c1;
        FETCH  c1 INTO v_Dept;
        DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_Dept.Deptno);
        DBMS_OUTPUT.PUT_LINE('DNAME : ' || v_Dept.DNAME);
        DBMS_OUTPUT.PUT_LINE(' LOC : ' || v_Dept.LOC);
    CLOSE c1;
END;
/       
  
--��ü �� ������ �ϴ°�
DECLARE
    v_dept      Dept%ROWTYPE;
    CURSOR      c1    IS
        SELECT  * FROM DEPT
        ORDER BY Deptno;
BEGIN
    OPEN c1;
    LOOP
        FETCH  c1 INTO v_Dept;
        Exit    WHEN   c1%NOTFOUND; --�߰����� ���ϸ� ���� ������
        DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_Dept.Deptno ||', DNAME : ' || v_Dept.DNAME||', LOC : ' || v_Dept.LOC);
    END LOOP;
    CLOSE c1;
END;
/   

DECLARE
    CURSOR      c1    IS
        SELECT  DEPTNO, DNAME, LOC
        FROM DEPT;
BEGIN
    FOR c1_rec IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || c1_rec.Deptno ||', DNAME : ' || c1_rec.DNAME||', LOC : ' || c1_rec.LOC);
    END LOOP;
END;
/    

/*�ٸ��ǽ�*/
DECLARE
    v_DEPT_ROW      DEPT%ROWTYPE;
    
    CURSOR c1(p_deptno DEPT.DEPTNO%TYPE) IS
        SELECT *
        FROM DEPT
        WHERE DEPTNO = p_deptno;
BEGIN
    OPEN c1(10);
    LOOP
        FETCH c1 INTO v_DEPT_ROW;
        Exit WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('10�� �μ� - DEPTNO :'||v_DEPT_ROW.DEPTNO||', DNAME : '||v_DEPT_ROW.DNAME||', LOC : '||v_DEPT_ROW.LOC);
        END LOOP;
    CLOSE c1;
    
    OPEN c1(20);
    LOOP
        FETCH c1 INTO v_DEPT_ROW;
        Exit WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('10�� �μ� - DEPTNO :'||v_DEPT_ROW.DEPTNO||', DNAME : '||v_DEPT_ROW.DNAME||', LOC : '||v_DEPT_ROW.LOC);
        END LOOP;
    CLOSE c1;    
END;
/

/*������ �ð� */
DECLARE
    v_DEPTNO      DEPT.DEPTNO%TYPE;
    
    CURSOR c1(p_deptno DEPT.DEPTNO%TYPE) IS
        SELECT *
        FROM DEPT
        WHERE DEPTNO = p_deptno;
BEGIN
    v_DEPTNO := &INPUT_DEPTNO;
    FOR c1_rec IN c1(v_DEPTNO) LOOP
        DBMS_OUTPUT.PUT_LINE('DEPTNO :'||c1_rec.DEPTNO||', DNAME : '||c1_rec.DNAME||', LOC : '||c1_rec.LOC);
     END LOOP;
END;
/

-- �ٸ� �ǽ� --
DECLARE
    v_wrong NUMBER;

BEGIN
    SELECT DNAME INTO v_wrong
    FROM DEPT
    WHERE DEPTNO = 10;
EXCEPTION
    -- SELECT INTO ��� ���� ���� ���� ���    
    -- ���, ��ȯ, �߸�, ���� ���� ������ �߻��ؾ� ��� (��¹��� : ' ����ó�� : ��ġ �Ǵ� �� ���� �߻�')
    -- �� �̿��� ���� �߻����� ��� (��¹��� : '����ó�� : ���� ���� �� �����߻�')
WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('����ó�� : �䱸���� ���� ���� ���� �߻�');
         
WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('����ó�� : ��ġ �Ǵ� �� ���� �߻�');

WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('����ó�� : ���� ���� �� �����߻�');
END;
/

DECLARE
    v_wrong NUMBER;
BEGIN
    SELECT DNAME INTO v_wrong
    FROM DEPT
    WHERE DEPTNO = 10;
EXCEPTION
    -- '���� ó�� : ���� ���� ���� �߻�'
    -- SQLCODE : �����ڵ尡 ���ü� �ֵ��� 
    --SQLERRM : ���� ������ ��µ� �� �ֵ���
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('���� ó�� : ���� ���� ���� �߻�');
        DBMS_OUTPUT.PUT_LINE('SLQCODE : '||TO_CHAR(SQLCODe));
        DBMS_OUTPUT.PUT_LINE('SLQERRM : '||SQLERRM);
END;
/