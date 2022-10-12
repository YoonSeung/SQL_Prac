SELECT *
FROM EMPLOYEES;

SELECt * 
FROM DEPARTMENTS;

SELECT EMPLOYEE_ID, FIRST_NAME ||' '||LAST_NAME AS "NAME",
        SALARY, JOB_ID, HIRE_DATE, MANAGER_ID
FROM    EMPLOYEES;

--�������(Employees)���̺��� ����� �̸��� ���� Name, ������ Job, �޿��� Salary,
--������ $100 ���ʽ��� �߰��Ͽ� ����� ���� Increase Ann_Salary, �޿��� $100���ʽ��� �߰��Ͽ� ����� ������ Increase Salary��� ��Ī�� �ٿ� ����϶�
select  first_name || ' ' || last_name "Name", job_id "Job", salary "Salary",
        (salary*12+100) "Increase Ann_Salary", 12*(salary+100) "Increase Salary"
from employees;

--������(Employees)���̺��� ��� ����� ��(last_name)�� ������ "��:1 Year Salary = $����" �������� ����ϰ�, 1 Year Salary��� ��Ī�� �ٿ� ����Ͻÿ�

select last_name || ': 1 Year Salary = $' ||salary*12 as "1 Year Salary"
from employees;

--�μ����� ����ϴ� ������ �ѹ����� ����Ͻÿ�
select distinct department_id, job_id
from employees;

/*����������̺��� �޿��� $7,000 ~ $10,000 ���� �̿��� ����� �̸��� ��(Name) �� �޿��� �޿��� ���� ������ ���
*/
select first_name ||' '|| last_name "Name", salary "Salary"
from employees 
WHERE  NOT (SALARY  BETWEEN 7000 AND 10000)
ORDER BY SALARY;

/*����� ���� 'e' �� 'o'���ڰ� ���Ե� ����� ����Ͻÿ� �̶� �Ӹ����� 'e or 0 name�̶� ����Ͻÿ�*/
select employee_id as "e or o Name"
from employees
where last_name like '%e%' or last_name like '%o%';

/*
���� ��¥ Ÿ���� ��¥ �Լ��� ���� Ȯ���ϰ�, 2006�� 05�� 20�Ϻ��� 2007�� 05�� 20�� ���̿� ���� ������� �̸��� ��(Name), ����, �Ի����� ����Ͻÿ�. ��, �Ի����� ���� ������ ����.
*/
select first_name ||' '|| last_name "Name", job_id, hire_date
from employees
where hire_date between '06/05/20' and '07/05/20'
order by hire_date ;

/*������ �޴� ��� ����� �̸��� ��(Name), �޿�, ����, �������� ����Ͻÿ�. �޿��� ū ������� �����ϰ� ������ �������� ū ������� ����.
*/
select first_name ||' '|| last_name "Name", salary , job_id , commission_pct 
from employees
where commission_pct is not null
order by salary, commission_pct desc;

/*
60�� IT �μ� ����� �޿��� 12.3% �λ��� ������ ǥ���ϴ� ���� �ۼ�, ������ �����ȣ, ���� �̸�(Name����) �޿�, �λ�� �޿�(Increase Salary)������ ���
�ݿø� ; Round
*/
select employee_id, last_name ||' '||  first_name as "Name" , salary, Round(salary*1.123,0) "Increase Salary"
from employees
where department_id = 60;

/*
�� ����� ���� 's'�� ������ ����� �̸��� ������ �̷��� ���� ���� ���
��½� �̸� ( first_name) �� ��(last_name) �� ù ���ڰ� �빮��, ������ ��� �빮�ڷ� ����ϰ� �Ӹ����� Employee JOBs�� ǥ��
*/
select INITCAP(first_name ||' '|| last_name || 'is a ' || UPPER(JOB_ID))as "Employee JOBs."
FROM    EMPLOYEES WHERE SUBSTR(LAST_NAME, -1, 1) = 's';

/*
����̸��� ��(name), �޿�, ���翩�ο� ���� ������ ���� ���/ ���翩�δ� ������ ������ salarty + commision, ������ salary only�� ǥ��, ��Ī�� ������/ ���� ��½� ������ ���� ��
*/

select last_name ||' '||  first_name as "Name", Salary, 
        (salary*12)+(salary*12*NVL(COMMISSION_PCT,0)) "Annual Salary",
        NVL2(commission_pct, 'Salary + commission','salary only') "Commission"
From employees
order by salary desc;

/*
��� ����� �̸��� ��(name), �Ի��� �׸��� �Ի����� � �����̾����� ���
�̶� ��( week)�� ������ �Ͽ��Ϻ��� ��µǵ��� ����
*/

select first_name ||' ' || last_name as "NAME", hire_date,
        TO_CHAR(hire_date, 'DAY') as "Day of the week"
FROM employees
order by TO_CHAR(hire_date,'d');

/*��� ����� ���� ��� �� ���� ������ ���´�. �� �ֻ��� �Ǵ� ������ ������ ���� ��� �� ������ ����.
�Ҽӵ� ����� �� � ����� ���� �ٹ����� ����� �� ���� ����Ͻÿ�
COUNT ����
*/
select COUNT(DISTINCT MANAGER_ID) "Count manager"
FROM EMPLOYEES;

/*
����� �Ҽӵ� �μ����� �޿� �հ�, �޿� ���, �޿� �ִ�, �޿� �ּڰ��� �����ϰ��� �Ѵ�. ���� ��°��� ���� �ڸ��� �� �ڸ� ���б�ȣ,
$ǥ�ÿ� �Բ� �Ʒ��� ���� ����Ͻÿ�. ��, �μ��� �Ҽӵ��� ���� ����� ���� ������ �����ϰ�, ��� �� �Ӹ����� ���� �׸�ó�� ��Ī(alias)ó��
�׷���
*/
select department_id, TO_CHAR(SUM(salary), '$999,999.00') as "SUM SALARY",
        TO_CHAR(AVG(salary),'$999,999.00') as "AVG SALARY",
        TO_CHAR(MAX(salary),'$999,999.00') as "MAX SALARY",
        TO_CHAR(MIN(salary),'$999,999.00') as "MIN SALARY"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;

/*
������� ������ ��ü �޿� ����� $10,000���� ū ��츦 ��ȸ�Ͽ� ������ �޿� ����� ���
�� ������ ���(CLERK)�� ���Ե� ���� �����ϰ� ��ü �޿� ����� ���� ������� ���
*/
select JOB_ID, AVG(salary) as "AVG salary"
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE '%CLERK%'
GROUP BY JOB_ID
HAVING AVG(salary)>10000
ORDER BY AVG(salary) DESC;

/*
HR ��Ű���� �����ϴ� Employees, Departments, Locations ���̺� ���� �ľ� �� Oxford�� �ٹ��ϴ� ����� �̸��� ��(name)
�̶� ù��° ���� ȸ���̸��� Han-Bit�̶�� ����� ���
*/
select 'Han-Bit', E.first_name ||' '|| E.last_name "Name", E.job_id,
        D.Department_Name, L.city
FROM    Employees E, Departments D, Locations L
WHERE   E.Department_ID = D.Department_ID AND D.Location_ID = L.Location_ID
        AND L.city = 'Oxford';