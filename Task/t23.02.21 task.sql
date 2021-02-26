-- BASIC SELECT 1.
SELECT  *
FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME,  CATEGORY
FROM TB_DEPARTMENT;

-- BASIC SELECT 2.
SELECT DEPARTMENT_NAME||'의 정원은' AS "학과별 ", CAPACITY||'명 입니다.' AS "정원"
FROM TB_DEPARTMENT;



SELECT *
FROM TB_STUDENT;


-- BASIC SELECT 3.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 001 AND ABSENCE_YN ='Y';


--BASIC SELECT 4. 

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079','A513090','A513091', 'A513110', 'A513119');

--BASIC SELECT 5.
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;


--BASIC SELECT 6.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--BASIC SELECT 7.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

SELECT *
FROM TB_STUDENT;

--BASIC SELECT 8
SELECT *
FROM TB_CLASS;

SELECT CLASS_NO
FROM TB_CLASS
WHERE  PREATTENDING_CLASS_NO IS NOT NULL;

--BASIC SELECT 9
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;

--BASIC SELECT 10
SELECT STUDENT_ADDRESS
FROM TB_STUDENT;


SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE  ABSENCE_YN != 'Y' AND  SUBSTR(STUDENT_ADDRESS, 1,3) = '전주시';



--ADDITIONAL SELECT - FUNCTION

--ADDITIONAL SELECT 1.
SELECT STUDENT_NO, STUDENT_NAME, TO_CHAR(ENTRANCE_DATE, 'RRRR-MM-DD')
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY 3;


--ADDITIONAL SELECT 2.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___' ;



--ADDITIONAL SELECT 3.
SELECT * 
FROM TB_PROFESSOR;

SELECT TO_DATE( SUBSTR(PROFESSOR_SSN, 1,6), 'RR/MM/DD')
FROM TB_PROFESSOR;


SELECT PROFESSOR_NAME AS "이름", EXTRACT(YEAR FROM SYSDATE) - ( TO_NUMBER( SUBSTR(PROFESSOR_SSN, 1,2))+
CASE 
    WHEN SUBSTR(PROFESSOR_SSN,8,1) IN (1,2) THEN 1900
    ELSE 2000
END) AS "나이"     

FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) = 1
ORDER BY 2 ;


SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME = '제상철';





--ADDITIONAL SELECT 4.
    
SELECT SUBSTR(PROFESSOR_NAME, 2, 2) AS "이름"
FROM TB_PROFESSOR;



--ADDITIONAL SELECT 5.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE(( EXTRACT(YEAR FROM SYSDATE)+2000 )-( TO_NUMBER( SUBSTR(STUDENT_SSN, 1,2))+
CASE 
    WHEN SUBSTR(STUDENT_SSN,8,1) IN (1,2) THEN 1900
    ELSE 2000
END))>19
ORDER BY 2;


SELECT ENTRANCE_DATE
FROM TB_STUDENT;


--ADDITIONAL SELECT 6. : QUESTION


SELECT  TO_CHAR( TO_DATE('2020/12/25', 'RRRR/MM/DD '), 'DAY' )
FROM DUAL;

--ADDITIONAL SELECT 7.
SELECT TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD'), 
TO_DATE('99/10/11', 'RR/MM/DD'), TO_DATE('49/10/11', 'RR/MM/DD')
FROM DUAL;



--ADDITIONAL SELECT 8.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE('A%');




--ADDITIONAL SELECT 9.
SELECT ROUND(AVG( POINT ),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';



--ADDITIONAL SELECT 10.
SELECT *
FROM TB_DEPARTMENT;

SELECT *
FROM TB_STUDENT
ORDER BY DEPARTMENT_NO;

SELECT *
FROM TB_CLASS;

SELECT DISTINCT DEPARTMENT_NO, COUNT(STUDENT_NAME)
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;


--ADDITIONAL SELECT 11.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

--ADDITIONAL SELECT 12.

SELECT *
FROM TB_GRADE;

SELECT   DECODE(SUBSTR(TERM_NO, 1, 4) ,'2001', '2001', '2002', '2002', '2003', '2003', '2004', '2004') AS "년도"
            , ROUND(AVG(POINT),1)AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY DECODE(SUBSTR(TERM_NO, 1, 4) ,'2001', '2001', '2002', '2002', '2003', '2003', '2004', '2004');

--ADDITIONAL SELECT 13.

SELECT DEPARTMENT_NO"학과코드명", COUNT(DECODE( ABSENCE_YN , 'Y',1,'N',NULL))AS"휴학생 수"
FROM TB_DEPARTMENT JOIN TB_STUDENT USING(DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
ORDER BY 1,2;


--ADDITIONAL SELECT 14.
SELECT STUDENT_NAME AS "이름", COUNT(STUDENT_NAME) AS "동명이인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT (STUDENT_NAME) >=2
ORDER BY 1;

--ADDITIONAL SELECT 15.
SELECT TERM_NO
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113';

SELECT SUBSTR(TERM_NO, 1,4) AS "년도", NVL2 (SUBSTR(TERM_NO, 5,2), SUBSTR(TERM_NO, 5,2), '총 평점')AS "학기" , ROUND(AVG(POINT),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO='A112113'
GROUP BY ROLLUP ( SUBSTR(TERM_NO, 1,4),SUBSTR(TERM_NO, 5,2) )
ORDER BY 1,2;




--함수 _  Join
--1
select emp_name as "이름", email  as "이메일", length(email) as "이메일 길이"
from employee;







--2. 

select emp_name as "직원명" , to_char(to_date(substr(emp_no, 1, 2), 'rr'), 'rrrr') as"년생" , nvl2( bonus , bonus , 0)
from employee
where substr(emp_no, 1, 2) between 60 and 69;


--3
select count(*)||'명'
from employee
where phone not like ('010%') or phone is null;

--null/ 010아닌사람 3사람씩 6명
select phone
from employee;


--4 
select emp_name as "직원명", extract(year from hire_date)||'년 '||extract(month from hire_date)||'월' as "입사 년/월"
from employee;

--5
select emp_name, Rpad(substr(emp_no, 1,8),14,'*')
from employee;

--6 
select emp_name, job_code,   Nvl(to_char((salary*(1+bonus)*12), '999,999,999,999'), to_char(salary*12,'999,999,999') )as "연봉"
from employee;

--7 
select emp_id, emp_name, dept_code
from employee
where dept_code in ('D5', 'D9')  and extract(year from Hire_date) = 2004;


--8
select emp_name, hire_date,   floor(sysdate-hire_date)||'일'
from employee;


--9 *************************아... 진짜.. 

select count('1'), count('2'), count('3'), count('4'), count('5'), count('6'), count('7')
from (

                select case
                                when extract(year from hire_date) = '1998' then '1'
                                when extract(year from hire_date) = '1999' then '2'
                                when extract(year from hire_date) = '2000' then '3'
                                when extract(year from hire_date) = '2001' then '4'
                                when extract(year from hire_date) = '2002' then '5'
                                when extract(year from hire_date) = '2003' then '6'
                                when extract(year from hire_date) = '2004' then '7'
                                else '0'
                            end
                from employee
                
)
where ;

select decode(1998 is null, 0, count(*))

from (
                select      count(decode(extract(year from hire_date), '1998' , '1')) as "1998"
                             count(decode(extract(year from hire_date) ,'1999', '2') )as "1999",
                             count( decode(extract(year from hire_date) ,'2000', '3')) as "2000",
                             count( decode(extract(year from hire_date) ,'2001', '4')) as "2001",
                               count( decode(extract(year from hire_date) ,'2002', '5')) as "2002",
                                count( decode(extract(year from hire_date) ,'2003', '6')) as "2003",
                                 count( decode(extract(year from hire_date) ,'2004', '7')) as "2004"
                from employee
                
        ) 
        
 having         ;
select extract(year from hire_date) from employee;


-------------------------------------------------------------------------
select 
            count(decode(extract(year from hire_DATE), '1998' , '1')) as "1998년",
            count(decode(extract(year from hire_DATE), '1999' , '1')) as "1999년",
            count(decode(extract(year from hire_DATE), '2000' , '1')) as "2000년",
            count(decode(extract(year from hire_DATE), '2001' , '1')) as "2001년",
            count(decode(extract(year from hire_DATE), '2002' , '1')) as "2002년",
            count(decode(extract(year from hire_DATE), '2003' , '1')) as "2003년",
            count(decode(extract(year from hire_DATE), '2004' , '1')) as " 2004년",
            count(emp_name) as "전체 직원수"
            
FROM EMPLOYEE;            


------------------------ 이거  --------------------------------------




--10
select emp_name, dept_title
from employee join department on (dept_code = dept_id)
where dept_code in ('D5', 'D6', 'D9')
order by 2;


--11
select dept_code, count(*), round(avg(salary))
from employee
where job_code != 'J1'
group by dept_code;


--12
select extract(year from hire_date), count(*)
from employee
where job_code != 'J1'
group by extract(year from hire_date)
order by 1;


--13
select decode(substr(emp_no,8,1),'1','남','2','여', '3','남', '4','여'), round(avg(salary)), sum(salary), count(emp_name)
from employee
group by decode(substr(emp_no,8,1),'1','남','2','여', '3','남', '4','여')
order by 4;

--15
select decode(substr(emp_no,8,1),'1','남','2','여', '3','남', '4','여'), count(emp_name)
from employee
group by decode(substr(emp_no,8,1),'1','남','2','여', '3','남', '4','여')
order by 1;

--15 
select dept_code, count(emp_name)
from employee
group by dept_code
having count(emp_name) > 3;

--16
select JOB_CODE, DEPT_CODE, count(emp_name)
from employee
group by  job_code, dept_code
having count(emp_name) >= 3;

--17
select manager_id, count(emp_name)
from employee
where manager_id is not null
group by manager_id
having count(emp_name) >=2
order by 1;

--18
select dept_title, local_name
from department join location on (local_code = location_id);

--19 
select local_name, national_name
from location join national using (national_code);
