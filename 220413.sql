CREATE OR REPLACE FUNCTION Member_YYMM(Timestamp DATE)
    RETURN VARCHAR2 IS
    v_Months    NUMBER(3);
    v_YY        NUMBER(3);
    v_MM        NUMBER(3);
    v_Between   VARCHAR2(20);
BEGIN
    v_Months    := FLOOR(MONTHS_BETWEEN(SYSDATE, Timestamp));
    v_YY        := TRUNC(v_Months / 12);  --몫만 구하기
    v_MM        := MOD(v_Months,12); --나머지 구하기
    v_Between   := To_CHAR(v_YY,'99') || '년' || To_CHAR(v_MM, '999') || '개월';
    RETURN v_Between;
END;
/

SELECT Member_YYMM('2020/03/13') FROM DUAL;

/*다른실습*/

CREATE OR REPLACE PACKAGE Example IS
    PROCEDURE Body_Temp_Change_F
        (f_Patient_ID IN VARCHAR2, f_Temp_Deg_C In NUMBER);
    FUNCTION Temp_Change_C
        (f_Temp_Deg_F IN NUMBER)
        RETURN Number;
    END;
/
--패키지 본문 생성
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

/*다음 실습*/
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
EXECUTE pro_param_in(1,2); -- 됨 왜냐 이미 위에 프로시저 생성할때 3,4 에 디폴트값 넣어놔서
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

/*다른 실습*/
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

/*CREATE OR REPLACE PROCEDURE pro_err -- 오류가 일부로 나게 한 거임 밑에 실습을 위해
IS
    err_no  NUMBER;
BEGIN
    err_no =100;
    DMBS_OUTPUT.PUT_LINE('err_no : '|| err_no);
END pro_err;
/

SHOW ERRORS; --오류 보기

SELECT * -- where로 지정한 곳의 에러 확인하기
FROM USER_ERRORS
WHERE NAME = 'PRO_ERR';
*/
/*다음실습*/

CREATE OR REPLACE FUNCTION func_aftertax(
    sal IN NUMBER --in 의미  : 함수 실행할때 데이터 값을 받아서 저장형으로 쓰는 변수
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

/*다음실습*/
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

/*다음 실습*/
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
점심 이후 시간
*/

SET SERVEROUTPUT ON;

BEGIN
    INSERT INTO Department
    VALUES('컴공', '컴퓨터공학과','765-4200');
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_On_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('<중복된 인덱스 예외 발생!!!!>');
    WHEN OTHERS THEN
        NULL;
END;
/

SELECT * FROM Department;

BEGIN
    UPDATE  Course
    SET     Course_Fees = '삼만원'
    WHERE   Course_ID='L1031';
    COMMIT;
EXCEPTION
    WHEN Invalid_Number THEN
        DBMS_OUTPUT.PUT_LINE('<잘못된 숫자 예외 방생!!!>');
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
        DBMS_OUTPUT.PUT_LINE(v_Score ||'점으로 100점 초과 입니다.');
END;
/

DECLARE
    v_Title         Course.Title%TYPE;
    v_Professor_ID  Professor.Professor_ID%TYPE :='P12';
BEGIN
    SELECT Title INTO v_Title
    FROM    Professor JOIN course USING(Professor_ID)
    WHERE   Professor_ID = v_Professor_ID;
    DBMS_OUTPUT.PUT_LINE(v_Professor_ID ||'교수는 ['||v_Title||']를 강의합니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SLQCODE : '||TO_CHAR(SQLCODe));
        DBMS_OUTPUT.PUT_LINE('SLQERRM : '||SQLERRM);
END;
/

SELECT * FROM Course
WHERE Professor_ID = 'P12';

/*다른실습
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
        DBMS_OUTPUT.PUT_LINE(Get_Dept%ROWCOUNT || '번째 인출된 값은 ' || Loop_rec.Dept_ID || ' : ' ||Loop_Rec.Dept_Name);
    END LOOP;
END;
/

/*다음 교시 */
--커서명 : c1, Dept 테이블 DEPTNO가 '40'인 데이터를 조회해 커서로 생성 후 아래와 같이 출력
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
  
--전체 다 나오게 하는것
DECLARE
    v_dept      Dept%ROWTYPE;
    CURSOR      c1    IS
        SELECT  * FROM DEPT
        ORDER BY Deptno;
BEGIN
    OPEN c1;
    LOOP
        FETCH  c1 INTO v_Dept;
        Exit    WHEN   c1%NOTFOUND; --발견하지 못하면 빠져 나가라
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

/*다른실습*/
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
        DBMS_OUTPUT.PUT_LINE('10번 부서 - DEPTNO :'||v_DEPT_ROW.DEPTNO||', DNAME : '||v_DEPT_ROW.DNAME||', LOC : '||v_DEPT_ROW.LOC);
        END LOOP;
    CLOSE c1;
    
    OPEN c1(20);
    LOOP
        FETCH c1 INTO v_DEPT_ROW;
        Exit WHEN c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('10번 부서 - DEPTNO :'||v_DEPT_ROW.DEPTNO||', DNAME : '||v_DEPT_ROW.DNAME||', LOC : '||v_DEPT_ROW.LOC);
        END LOOP;
    CLOSE c1;    
END;
/

/*마지막 시간 */
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

-- 다른 실습 --
DECLARE
    v_wrong NUMBER;

BEGIN
    SELECT DNAME INTO v_wrong
    FROM DEPT
    WHERE DEPTNO = 10;
EXCEPTION
    -- SELECT INTO 결과 행이 여러 개일 경우    
    -- 산술, 변환, 잘림, 제약 조건 오류가 발생해쓸 경우 (출력문장 : ' 예외처리 : 수치 또는 값 오류 발생')
    -- 그 이외의 오류 발생했을 경우 (출력문장 : '예외처리 : 사전 정의 외 오류발생')
WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리 : 요구보다 많은 추출 오류 발생');
         
WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('예외처리 : 수치 또는 값 오류 발생');

WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외처리 : 사전 정의 외 오류발생');
END;
/

DECLARE
    v_wrong NUMBER;
BEGIN
    SELECT DNAME INTO v_wrong
    FROM DEPT
    WHERE DEPTNO = 10;
EXCEPTION
    -- '예외 처리 : 사전 정의 오류 발생'
    -- SQLCODE : 오류코드가 나올수 있도록 
    --SQLERRM : 오류 내용이 출력될 수 있도록
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리 : 사전 정의 오류 발생');
        DBMS_OUTPUT.PUT_LINE('SLQCODE : '||TO_CHAR(SQLCODe));
        DBMS_OUTPUT.PUT_LINE('SLQERRM : '||SQLERRM);
END;
/