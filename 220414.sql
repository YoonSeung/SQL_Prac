--4��14�� ����� �ǽ�
--Ʈ���� �ǽ�
CREATE TABLE SG_Scores_Change
AS
    SELECt *
    FROM SG_Scores
    WHERE 1<>1;
    
CREATE OR REPLACE TRIGGER SG_Scores_Change_log BEFORE
INSERT ON SG_Scores
FOR EACH ROW
BEGIN
    INSERT INTO SG_Scores_Change
    (Student_ID, Course_ID, Score, Score_Assigned, User_Name, C_DATE)
    VALUES
    (:new.Student_ID, :new.Course_ID, :new.Score, :new.Score_Assigned, '�α׿�:'||USER, SYSDATE);
END;
/

INSERT INTO SG_Scores
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('A1001','L2031',93,'2010/12/21');

SELECT * 
FROM SG_Scores
WHERE Student_ID = 'A1001';

SELECT * FROM SG_Scores_Change;

/*���� �ǽ� */ -- grade �Լ������
CREATE OR REPLACE FUNCTION Grade_Cal(Score Number)
    RETURN VARCHAR2 IS
    v_Grade   SG_Scores.Grade%TYPE ;
BEGIN
    IF Score >95 THEN v_Grade :='A+';
        ELSIF Score >90 THEN v_Grade :='A';
        ELSIF Score >85 THEN v_Grade :='B+';
        ELSIF Score >80 THEN v_Grade :='B';
        ELSIF Score >75 THEN v_Grade :='C+';
        ELSIF Score >70 THEN v_Grade :='C';
        ELSIF Score >65 THEN v_Grade :='D+';
        ELSIF Score >60 THEN v_Grade :='D';
        ELSE    v_Grade :=null;
    END IF;
    RETURN v_Grade;
END;
/

SELECT Grade_Cal(95) FROM DUAL;

CREATE OR REPLACE TRIGGER Grade_Search BEFORE -- grade_SearchƮ���� ����
    INSERT OR UPDATE ON SG_Scores
    FOR EACH ROW
BEGIN
    :new.Grade := Grade_Cal(:new.Score);
END;
/

INSERT INTO SG_Scores
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('A1001','L4011',88,'2010/12/23');

SELECT * 
FROM Sg_Scores_change;

SELECT *
FROM All_Triggers --dbtest �������� ���� Ʈ���� ���κ���
WHERE OWNER = 'DBTEST';

ALTER TRIGGER Grade_Search Disable; --Ʈ���� ���߰� �ؿ� �� �����ϸ� grade�� �ȶ�

INSERT INTO SG_Scores
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('T1001','L1042',77,'2010/12/22');

SELECT *
FROM SG_Scores
WHERE Student_ID = 'T1001';

SELECT *
FROM SG_Scores_Change;

ALTER TRIGGER Grade_Search ENABLE;--Ʈ���� �ٽ� Ȱ��ȭ�ϰ� �ؿ��� �����ϸ� grade�� �ٽ� ��

INSERT INTO SG_Scores
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('T1001','L1051',77,'2010/12/22');

SELECT *
FROM SG_Scores
WHERE Student_ID = 'T1001';

SELECT *
FROM SG_Scores_Change;

/*�ٸ� �ǽ�*/
CREATE VIEW SG_Scores_View
AS
    SELECT *
    FROM SG_Scores;
    
CREATE OR REPLACE TRIGGER SG_Scores_View_Log
    INSTEAD OF INSERT ON Sg_Scores_View
    FOR EACH ROW
BEGIN
    INSERT INTO SG_Scores_Change
    (Student_ID, Course_ID, Score, Score_Assigned, User_Name, C_DATE)
    VALUES
    (:new.Student_ID, :new.Course_ID, :new.Score, :new.Score_Assigned, '�α׿� : '||USER, SYSDATE);
END;
/

INSERT INTO SG_Scores_VIEW
(Student_ID, Course_ID, Score, Score_Assigned)
VALUES
('B1001','L0011',95,'2010/12/23');

SELECT *
FROM SG_Scores_VIEW
WHERE Student_ID = 'B1001';

SELECT *
FROM SG_Scores_Change;

/*���� �ǽ� */

CREATE TABLE EMP_TRG
AS
    SELECT * FROM EMP;
    
CREATE OR REPLACE TRIGGER trg_nodm1_weekend BEFORE
    INSERT OR UPDATE OR DELETE ON EMP_TRG
BEGIN
    IF TO_CHAR(sysdate, 'DY') IN ('��','��') THEN
        IF INSERTING THEN
            raise_application_error(-20000,'�ָ� ��� ���� �߰� �Ұ�');
        ELSIF UPDATING THEN
            raise_application_error(-20001,'�ָ� ��� ���� ���� �Ұ�');
        ELSIF DELETING THEN
            raise_application_error(-20002,'�ָ� ��� ���� ���� �Ұ�');
        ELSE
            raise_application_error(-20003,'�ָ� ��� ���� ���� �Ұ�');
        END IF;
    END IF;
END;
/

UPDATE emp_trg
SET SAL = 3500
WHERE EMPNO = 7782;

SELECT *
FROM EMP_TRG
WHERE EMPNO=7782;

rollback;

/*���� �ǽ� */
CREATE TABLE EMP_TRG_LOG(
    TABLENAME   VARCHAR2(10),
    DEL_TYPE    VARCHAR2(10),
    EMPNO       NUMBER(4),
    USER_NAME   VARCHAR2(30),
    CHANGE_DATE DATE
    );
    
CREATE OR REPLACE TRIGGER Trg_emp_log AFTER
    INSERT OR UPDATE OR DELETE ON EMP_TRG
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO EMP_TRG_LOG
        VALUES('EMP_TRG', 'INSERT', :new.empno, SYS_CONTEXT('USERENV','SESSION_USER'), SYSDATE);
    ELSIF   UPDATING THEN
        INSERT INTO EMP_TRG_LOG
        VALUES('EMP_TRG', 'UPDATE', :old.EMPNO, SYS_CONTEXT('USERENV','SESSION_USER'), SYSDATE);
    ELSIF   DELETING THEN
        INSERT INTO EMP_TRG_LOG
        VALUES('EMP_TRG', 'DELETE', :old.EMPNO, SYS_CONTEXT('USERENV','SESSION_USER'), SYSDATE);
    END IF;
END;
/
INSERT INTO EMP_TRG
VALUES(9999, 'TestEmp', 'CLERK', 7788, TO_DATE('2018-03-03','YYYY-MM-DD'), 1200, null,20);

COMMIT;

SELECT *
FROM EMP_TRG;

SELECT *
FROM EMP_TRG_LOG;

UPDATE
    EMP_TRG
    SET SAL = 1300
WHERE MGR = 7788;

commit;

SELECT *
FROM EMP_TRG
WHERE MGR = 7788;

SELECT *
FROM EMP_TRG_LOG;