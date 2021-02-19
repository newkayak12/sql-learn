--02월 18일 (목)
--1. job_name
select job_code
from job;

--2. department
select * 
from department;

--3 name, email, phone, hiredate
select emp_name, email, phone, hire_date 
from employee;

--4 hdate, sal, name
select emp_name, hire_date,salary 
from employee;

--5 sal >2500000 name, sal,lev
select emp_name, sal_level
from employee
where salary >= 2500000;

--6 sal 350만 이상 , jcode j3 name, phone
select emp_name, phone
from employee
where (salary > 3500000) and job_code = 'J3';

--7 이름 연봉 총수령액(보너스 포함) 실수령액 (총 수령액 - (월급 * 세금 3%)) 출력되게 하라
select emp_name as "이름"  ,salary* 12 as "연봉" ,  (salary* (1 + bonus) ) *12 as "총수령액" , ((salary* (1 + bonus) ) *12 -(salary*0.03)) as "실수령액"
from employee;

--????8 이름/근무일수
select  emp_name as "성명" ,  (sysdate - hire_date) as "근무일수"
from employee ;

--LocalDate ld = new LocalDate.now();


--?????9 20년 이상 근속자 이름 월급 보너스율
select emp_name, salary, bonus
from employee
where (sysdate - hire_date) > 20*365;

--10 
select *
from employee
where hire_date between '90/01/01' and '01/01/01';

--11
select *
from employee
where emp_name like '%이%';

--12
select emp_name
from employee
where emp_name like '%연';

--13
select emp_name,phone
from employee
where not phone like '010%';

--14
select *
from employee
--where email like '____/_% , ecape '/' and 
--          dept_code in (D9,D6 and
--            hire_date between '90/01/01' and '00/12/01' and
--         salary >2700000;
where (email like '____/_%' escape '/') AND 
            (dept_code IN ('D9', 'D6')) AND
            (hire_date between '90/01/01' and '00/12/01') AND
            (salary >2700000);
            
          
            
--15
select *
from employee
where (dept_code is null) AND (bonus is not null);


--16 
select emp_name
from employee
where (manager_id is null) AND (dept_code is null);



select * from tab;
select * from bonus;
select * from dept;
select * from emp;
select * from salgrade;


