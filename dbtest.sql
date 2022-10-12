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
('p12', '김명석', '부교수', '컴공', '555-1234');

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p41', '안영홍', '부교수', '경영', '555-1234'); 
--TelePhone이 유니크로 지정되어있기때문에 동일한 값을 추가하려하면 오류가 뜸.

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p41', '안영홍', '부교수', '경영', null);

INSERT INTO Professor(
PROFESSOR_ID, Name, Position, Dept_ID, TelePhone)
VALUES
('p32', '김영진', '조교수', '회계', null);
-- 하지만 null은 값이 없는것이기 때문에 추가가 가능하다.
COMMIT;

SELECT * FROM Professor;

DROP table Professor;
commit;

CREATE TABLE Professor(
    Professor_ID    VARCHAR2(3)     PRIMARY KEY,
    Name            VARCHAR2(20)    NOT NULL,
    Position        VARCHAR2(10)    NOT NULL constraint Prof_ck
        CHECK (Position in('교수','부교수','조교수','전임강사')),
    Dept_ID         VARCHAR2(10),
    Telephone       VARCHAR2(12)    UNIQUE);
    
commit;

INSERT INTO Professor(Professor_ID, Name, Position, Dept_ID, Telephone)
VALUES('P12','김은석','부교수','컴공','555-1234');
commit;

INSERT INTO Professor(Professor_ID, Name, Position, Dept_ID, Telephone)
VALUES('P81','강준상','전임교수','컴공','555-4567');

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
--크기 변경
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
Student 테이블의 주민등록번호를 이용하여 생년월일을 추출하고, 날짜형 데이터로 변환하여
출력하시오.
*/
SELECT Student_ID, Name, ID_Number, To_DATE(SUBSTR(ID_Number,1,6), 'RRMMDD') "생년월일"
FROM Student;

/*
 1. 현재 날짜와 시간을 ‘YYYY-MM-DD HH24:MI:SS FF3’ 형식으로 출력하시오.
 
 2. Student 테이블의 입학날짜(I_Date) 칼럼을 참조하여 ‘RRRR/MM/DD (DAY)’ 형식으로 출
력하시오.
 3. SG_Scores 테이블의 성적(Score)이 98점 이상인자에 대하여 성적 취득 일자를
‘YYYY/MM/DD’ 형식의 문자형으로 변환 출력하시오
출력해야 할 항목 : 학생 ID, 이름 , 입학일자(원본), 입학일자(형식이 주어진 문자로)
학생ID, 과목ID, 점수, 점수취득일자(원본), 점수취득일자(형식이 주어진 형태의 문자로)
*/
SELECT STUDENT_ID, COURSE_ID, SCORE,  SCORE_ASSIGNED, TO_CHAR(SCORE_ASSIGNED, 'YYYY/MM/DD') "점수취득일자"
FROM sg_scores
WHERE SCORE>=98
ORDER BY SCORE_ASSIGNED;

/*
예) 1. SG_Scores 테이블로부터 점수가 98점 이상의 점수를 문자형으로 변경하여 출력하시오.
 2. SG_Scores 테이블의 성적이 98점 이상인 행에 대하여 성적을 ‘S999’, ‘099.99’ 형식으로
문자열로 변환하시오.
 3. Course 테이블의 추가 수강료를 문자열로 변환하여 ‘999,999’, ‘L999,999’, ‘9.99EEEE’ 형식
으로 출력하시오.
학생 ID , 과목ID,점수, 점수,문자로 변환되어진 점수
학생 ID , 과목ID,점수, 점수,문자로 변환되어진 점수('S999'), 문자로 변환되어진 점수("B999
.9'), 문자로 변환되어진 점수('099.99')
*/
SELECT Student_ID, Name, I_Date, TO_CHAR(I_Date, 'RRRR/MM/DD (DAY)') "입학일자"
FROM Student;

SELECT Student_ID, Course_ID, Score, to_char(Score, 's999'), to_char(Score, 'B999.9'),
    to_char(Score, '099.99')
FROM SG_scores
WHERE Score >=98
ORDER BY Score DESC;
