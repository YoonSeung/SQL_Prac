SELECT *
FROM EMPLOYEES;

SELECt * 
FROM DEPARTMENTS;

SELECT EMPLOYEE_ID, FIRST_NAME ||' '||LAST_NAME AS "NAME",
        SALARY, JOB_ID, HIRE_DATE, MANAGER_ID
FROM    EMPLOYEES;

--사원정보(Employees)테이블에서 사원의 이름과 성은 Name, 업무는 Job, 급여는 Salary,
--연봉에 $100 보너스를 추가하여 계산한 값은 Increase Ann_Salary, 급여에 $100보너스를 추가하여 계산한 연봉은 Increase Salary라는 별칭을 붙여 출력하라
select  first_name || ' ' || last_name "Name", job_id "Job", salary "Salary",
        (salary*12+100) "Increase Ann_Salary", 12*(salary+100) "Increase Salary"
from employees;

--원정보(Employees)테이블에서 모든 사원의 성(last_name)과 연봉을 "성:1 Year Salary = $연봉" 형식으로 출력하고, 1 Year Salary라는 별칭을 붙여 출력하시오

select last_name || ': 1 Year Salary = $' ||salary*12 as "1 Year Salary"
from employees;

--부서별로 담당하는 업무를 한번씩만 출력하시오
select distinct department_id, job_id
from employees;

/*사원정보테이블에서 급여가 $7,000 ~ $10,000 범위 이외인 사람의 이름과 성(Name) 및 급여를 급여가 적은 순서로 출력
*/
select first_name ||' '|| last_name "Name", salary "Salary"
from employees 
WHERE  NOT (SALARY  BETWEEN 7000 AND 10000)
ORDER BY SALARY;

/*사원의 성중 'e' 및 'o'글자가 포함된 사원을 출력하시오 이때 머리글은 'e or 0 name이라 출력하시오*/
select employee_id as "e or o Name"
from employees
where last_name like '%e%' or last_name like '%o%';

/*
현재 날짜 타입을 날짜 함수를 통해 확인하고, 2006년 05월 20일부터 2007년 05월 20일 사이에 고용된 사원들의 이름과 성(Name), 업무, 입사일을 출력하시오. 단, 입사일이 빠른 순으로 정렬.
*/
select first_name ||' '|| last_name "Name", job_id, hire_date
from employees
where hire_date between '06/05/20' and '07/05/20'
order by hire_date ;

/*수당을 받는 모든 사원의 이름과 성(Name), 급여, 업무, 수당율을 출력하시오. 급여가 큰 순서대로 정렬하고 같으면 수당율이 큰 순서대로 정렬.
*/
select first_name ||' '|| last_name "Name", salary , job_id , commission_pct 
from employees
where commission_pct is not null
order by salary, commission_pct desc;

/*
60번 IT 부서 사원의 급여를 12.3% 인상해 정수만 표시하는 보고서 작성, 보고서는 사원번호, 성과 이름(Name으로) 급여, 인상된 급여(Increase Salary)순으로 출력
반올림 ; Round
*/
select employee_id, last_name ||' '||  first_name as "Name" , salary, Round(salary*1.123,0) "Increase Salary"
from employees
where department_id = 60;

/*
각 사원의 성이 's'로 끝나는 사원의 이름과 업무를 이래의 예와 같이 출력
출력시 이름 ( first_name) 과 성(last_name) 은 첫 글자가 대문자, 업무는 모두 대문자로 출력하고 머리글은 Employee JOBs로 표시
*/
select INITCAP(first_name ||' '|| last_name || 'is a ' || UPPER(JOB_ID))as "Employee JOBs."
FROM    EMPLOYEES WHERE SUBSTR(LAST_NAME, -1, 1) = 's';

/*
사원이름과 성(name), 급여, 수당여부에 따른 연봉을 포함 출력/ 수당여부는 수당이 있으면 salarty + commision, 없으면 salary only라 표시, 별칭은 적절히/ 또한 출력시 연봉이 높은 순
*/

select last_name ||' '||  first_name as "Name", Salary, 
        (salary*12)+(salary*12*NVL(COMMISSION_PCT,0)) "Annual Salary",
        NVL2(commission_pct, 'Salary + commission','salary only') "Commission"
From employees
order by salary desc;

/*
모든 사원의 이름과 성(name), 입사일 그리고 입사일이 어떤 요일이었는지 출력
이때 주( week)의 시작인 일요일부터 출력되도록 정렬
*/

select first_name ||' ' || last_name as "NAME", hire_date,
        TO_CHAR(hire_date, 'DAY') as "Day of the week"
FROM employees
order by TO_CHAR(hire_date,'d');

/*모든 사원은 직속 상사 및 직속 직원을 갖는다. 단 최상위 또는 최하위 직원은 직속 상사 및 직원이 없다.
소속된 사원들 중 어떤 사원의 상사로 근무중인 사원의 총 수를 출력하시오
COUNT 쓰기
*/
select COUNT(DISTINCT MANAGER_ID) "Count manager"
FROM EMPLOYEES;

/*
사원이 소속된 부서별로 급여 합계, 급여 평균, 급여 최댓값, 급여 최솟값을 집계하고자 한다. 계산된 출력값은 여섯 자리와 세 자리 구분기호,
$표시와 함께 아래와 같이 출력하시오. 단, 부서에 소속되지 않은 사원에 대한 정보는 제외하고, 출력 시 머리글은 다음 그림처럼 별칭(alias)처리
그룹핑
*/
select department_id, TO_CHAR(SUM(salary), '$999,999.00') as "SUM SALARY",
        TO_CHAR(AVG(salary),'$999,999.00') as "AVG SALARY",
        TO_CHAR(MAX(salary),'$999,999.00') as "MAX SALARY",
        TO_CHAR(MIN(salary),'$999,999.00') as "MIN SALARY"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;

/*
사원들의 업무별 전체 급여 평균이 $10,000보다 큰 경우를 조회하여 업무별 급여 평균을 출력
단 업무에 사원(CLERK)이 포함된 경우는 제외하고 전체 급여 평균이 높은 순서대로 출력
*/
select JOB_ID, AVG(salary) as "AVG salary"
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE '%CLERK%'
GROUP BY JOB_ID
HAVING AVG(salary)>10000
ORDER BY AVG(salary) DESC;

/*
HR 스키마에 존재하는 Employees, Departments, Locations 테이블 구조 파악 후 Oxford에 근무하는 사원의 이름과 성(name)
이때 첫번째 열은 회사이름인 Han-Bit이라는 상수값 출력
*/
select 'Han-Bit', E.first_name ||' '|| E.last_name "Name", E.job_id,
        D.Department_Name, L.city
FROM    Employees E, Departments D, Locations L
WHERE   E.Department_ID = D.Department_ID AND D.Location_ID = L.Location_ID
        AND L.city = 'Oxford';