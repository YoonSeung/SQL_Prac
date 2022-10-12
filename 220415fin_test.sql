--��� ���� �ټ����̻��� �μ��� �μ��̸��� ������� ��� �̶� ������� ���������� 
SELECT d.department_name, COUNT(E.EMPloyee_ID)
FROM EMPLOYEES E, Departments D
where E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.department_name
HAVING COUNT(E.EMPLOYEE_ID) >=5
ORDER BY COUNT(E.EMPLOYEE_ID) DESC;

----------------ȫ�浿 ��տ���    �����Ѵ� ����� �̸��� ���� �빮�ڷ� ����Ͻÿ�
SELECT E.FIRST_NAME || '' || E.LAST_NAME || 'report to' ||
        UPPER(M.FIRST_NAME || '' || M.LAST_NAME) AS "EMPLYOEE vs Manager"
        FROM employees E, employees M
        WHERE e.manager_id = m.employee_id(+);
--------------Trunnker ������� �޿��� ���� �ް��ִ� ����� �̸��� �� ���� �޿� ���
SELECT FIRST_NAME || '' || LAST_NAME as "NAME" , JOB_ID,
        SALARY
FROM EMPLOYEES
WHERE SALARY>(SELECT salary from employees Where LAST_NAME='Tucker');
---------------���� �޿� �Ի��� ���
SELECT FIRST_NAME || '' || LAST_NAME as "NAME" , JOB_ID, Salary, HIRE_DATE
FROM EMPLOYEES
WHERE SALARY IN (SELECT MIN(SALARY)
                    FROM employees GROUP BY department_id);
-------�޿�, �μ���ȣ, ������ ���
SELECT FIRST_NAME || ''|| LAST_NAME AS "NAME", Salary, DEPARTMENT_ID, JOB_ID
FROM  employees E
where SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES
                WHERE DEPARTMENT_ID = e.department_id);
----------�����̸��� ���� o �� �����ϴ� ������ ����ִ� �����

SELECT employee_id, FIRST_NAME || ''|| LAST_NAME AS "NAME",JOB_ID, HIRE_DATE
FROM employees
WHERE department_id IN(SELECT department_id
                        FROM departments
                        WHERE LOCATION_ID IN(SELECT LOCATION_ID
                                            FROM LOCATIONS WHERE CITY LIKE 'O%'));
-----��� ����� ������ ����Ͻÿ�

SELECT FIRST_NAME || ''|| LAST_NAME AS "NAME",JOB_ID,Salary,DEPARTMENT_ID,
            (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEES
            WHERE DEPARTMENT_ID= DEPARTMENT_ID) AS "department ACG Salary"
FRoM EMPloyees E ;

-------�������� �̿��Ͽ� �ߺ��� ��������� �ѹ��� ǥ���Ͻÿ�
SELECT EMPLOYEE_ID, JOB_ID
FROM EMPLOYEES
UNION
SELECT EMPLOYEE_ID, JOB_ID
FROM JOB_HISTORY;

----------������ ������� ���� �̷� ��ü�� ������ ���ߴ�
SELECT employee_id, JOB_ID, DEPARTMENT_ID
FROM EMPLOYEES
UNION ALL
SELECT employee_id, JOB_ID, DEPARTMENT_ID
FROM job_history
ORDER BY EMPLOYEE_ID;

--����������� ���� ������ �����ִ� ����� �����ȣ�� ������ ���

SELECT EMPLOYEE_ID, JOB_ID
FROM employees
INTERSECT
SELECT EMPLOYEE_ID, JOB_ID
FROM job_history;

------
SELECT employee_id, JOB_ID, NULL AS "SART DATE", NULL AS "END DATE"
FROM employees
WHERE employee_id=176
UNION
SELECT employee_id, JOB_ID, START_DATE, END_DATE
FROM JOB_HISTORY
WHERE EMPLOYEE_ID=176;
----------
SELECT employee_id
FROM employees
MINUS
SELECT employee_id
FROM JOB_HISTORY;

-----�޿� �λ� ����ڴ� ȸ���� ���� (Distinct job_id)�� ���� 5���������� ���ϴ� ����� �ش�ȴ�
/*SELECT Employee_id, Last_Name || '' || First_Name as "Name", Job_Id, Salary,
        CASE Job_id WHEN 'HR_REP'   THEN 1.10*Salaryy
        CASE Job_id WHEN 'MK_REP'   THEN 1.12*Salaryy
        CASE Job_id WHEN 'PR_REP'   THEN 1.15*Salaryy
        CASE Job_id WHEN 'SA_REP'   THEN 1.18*Salaryy
        CASE Job_id WHEN 'IT_REP'   THEN 1.20*Salaryy
        ELSE SALARY
    END "New Salary"
FROM EMPLOYEEs;
*/
/*SELECT Employee_id, Last_name ||''|| First_Name AS"NAEM", Job_id, Salary,
        DEcode(JOB_ID, 'HR_REP',1.10*Salary,'MK_REP', 1.12*Salary, 'PR_REP', 1.15*Salary,
        'SA_REP',1.18*Salary, 'IT_PROG', 1.20*Salary, Salary)"New Salary"
        FROM EMPLOYEES;*/

-------------------------------------


sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '01', COUNT(*),0)) as "1MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '02', COUNT(*),0)) as "2MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '03', COUNT(*),0)) as "3MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '04', COUNT(*),0)) as "4MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '05', COUNT(*),0)) as "5MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '06', COUNT(*),0)) as "6MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '07', COUNT(*),0)) as "7MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '08', COUNT(*),0)) as "8MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '09', COUNT(*),0)) as "9MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '10', COUNT(*),0)) as "10MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '11', COUNT(*),0)) as "11MONTH"
sum(DECODE(TO_CHAR(HIRE_DATE, 'mm'), '12', COUNT(*),0)) as "12MONTH"
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE,'MM')
ORDER BY TO_CHAR(HIRE_DATE,'MM');

FROM EMP

SELECT LAST_NAME || 'report to ' || PRIOR LAST_NAME "Walk"
FROM EMPLOYEES
START WITH LAST_NAME = 'King'
CONNECT BY PRIOR EMPLOYEE_ID = Manager_ID;

SELECT PRIOR LAST_NAME || ' report to ' || LAST_NAME "Walk"
FROM EMPLOYEES
START WITH LAST_NAME = 'Olson'
CONNECT BY EMPLOYEE_ID = PRIOR Manager_ID;