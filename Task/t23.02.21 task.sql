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





