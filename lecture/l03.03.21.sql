--서브쿼리를 이용한  테이블 생성하기
--> 테이블을 생성을 하는데 그냥 서브쿼리를 이용하겠다는 거에요

-- 기존 : CREATE TABLE 테이블명 (  컬럼 내용 설정(저장소 타입, 길이 , 제약조건 설정) );
-- 서브쿼리 이용 : CREATE TABLE 테이블명 AS  서브쿼리 > 테이블 복사해서 넣는 것 
-- 
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;
-- 아예 복사하는 > 참조가 아니라  > 
SELECT * FROM EMP_COPY;
--EMPLOYEE에는 PRIMARY가  EMP_ID
-- 근데 가져오면 NOT NULL 빼고는 제약조건을 복사를 안했음.... > 따로 ALTER로 수정을 해줘야한다. > 왜 다른 건 안가지고 오지??
-- COMMENT도 전혀 복사가 안된다. 




--  JOIN으로 
CREATE TABLE EMP_DEP_COPY
AS
SELECT * FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);  -- NULL이 상실되는 것을 막으려고 OUTER으로






--만약 컬럼명/ 컬럼에 설정된 길이만 가져오고 싶으면??
-- 서브쿼리에서 데이터 내용을 필터링해서 틀만 가져오면 됨


CREATE TABLE DEPT_COPY_FRAME
AS
SELECT * 
FROM DEPARTMENT 
WHERE 1 = 0;  -- 전체 행이 무조건 FALSE니까 틀만 가져온다.  > 그냥 FALSE만 의도적으로 만들어주면 된다. 

--WHERE절은 ROW를 필터링하는 (조건으로)


SELECT * 
FROM DEPT_COPY_FRAME;


---- 마무리 > 제약조건을 잘 설정을 해서 테이블을 만드는 것 > 결국 DB를 설계를 해야하고 > 그러려면 추상화가 필요하다. 




--DML구문에 대해서 _ 안의 내용을 조작하는
--INSERT는 한 번에 하나씩 실행하면 하나의 ROW를 추가하는(행의 개수를 증가시키는 구문)
-- INSERT INTO (테이블명) 1. (컬럼명)                                > 저장할 컬럼을 지정 //(무조건 다 채울 필요가 없다는 얘기)//)
--                                       2. (혹은 컬럼명 기재 X)

--   컬럼명을 지정하면 주의할 것이 있다. > 제약조건 > 예를들어 내가 채우고 싶은 컬럼 말고 다른 곳에 NOT NULL이 있으면 그 곳을 채워주지 않고는 절대로 추가가 안됨..
--  >>  NOT NULL이 있으면 그 곳은 무조건 채워야한다.  >> 값을 강제하는 효과가 있다.


        --INSERT문은 테이블에 한 개 ROW를 삽입하는 것 
        -- 한 번에 한 개의 데이터만 삽입이 된다.  >> INSERT INTO ... VALUES(), VALUES()이렇게 안된다.
        -- 1. 컬럼을 지정해서 데이터 삽입                                                       /         2. 전체 컬럼에 데이터를 삽입
        -- INSERT INTO 테이블명( 컬럼명1, 컬럼명2...) VALUES( 값1, 값2......);    /       INSERT INTO 테이블명 VALUES(값1, 값2, .... (모든 컬럼을 순서대로 다 써야함));           
        -- 지정되지 않은 컬럼에 값은 NULL > NOT NULL제약조건 주의!
        
        
SELECT * FROM DEPARTMENT;
--1
INSERT INTO DEPARTMENT(DEPT_ID, DEPT_TITLE, LOCATION_ID) VALUES('D0', '자바연구부', 'L2');

-- 오류 보고 -
-- ORA-12899: VALUE TOO LARGE FOR COLUMN "SANGHYUN"."DEPARTMENT"."DEPT_ID" (ACTUAL: 3, MAXIMUM: 2)    
DESC DEPARTMENT;        
        
SELECT * 
FROM DEPARTMENT
ORDER BY DEPT_ID;        
--2
INSERT INTO DEPARTMENT VALUES('D', '오라클연구부', 'L3');

DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D0';
INSERT INTO DEPARTMENT(DEPT_TITLE, LOCATION_ID) VALUES ('JDBC연구부', 'L5');
--오류 보고 -
--ORA-01400: CANNOT INSERT NULL INTO ("SANGHYUN"."DEPARTMENT"."DEPT_ID")    >> PRIMARY KEY에 NOT NULL + UNIQUE라서 안 들어감 



INSERT INTO DEPARTMENT(DEPT_ID, LOCATION_ID) VALUES ('D0', 'L5');
--제약조건이 DEPT_TITLE에 없어서 들어가죠  NULL이어도


SELECT * 
FROM EMPLOYEE
ORDER BY SALARY DESC;
DESC EMPLOYEE;

INSERT INTO EMPLOYEE VALUES ('223', '김상현', '930710-1023329', 'NEWKAYAK12@GMAIL.COM', '01027114160', 'S1', 'J2', 'S1', 800000, 0.293, '200', '2020/02/28', '2300/02/02', 'Y');

        

UPDATE  EMPLOYEE
SET SALARY = 6000000
WHERE EMP_ID = '223';


-- 추가적인 INSERT활용
-- SUBQUERY사용하여 INSERT
CREATE TABLE INSERT_TEST
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE 1=0;




SELECT * FROM INSERT_TEST;


INSERT INTO INSERT_TEST VALUES ('001' , '유병승', '자바연구부');
INSERT INTO INSERT_TEST (SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
                                FROM EMPLOYEE 
                                JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                                WHERE DEPT_CODE = 'D5');
-- 이러면 기존의 테이블뷰를 테이블로 INSERT
--서브쿼리이용 데이터 넣기  > WHERE로 조건으로 필터링해서 그 뷰를 새로운 테이블로 복사할 수 있음


DELETE FROM INSERT_TEST; --> 전체 삭제


-- 집어 넣을 때 원하는 컬럼을 지정해서 넣을 수 있음> 뭘 이용해서? 서브쿼리를 이용해서
INSERT INTO INSERT_TEST (EMP_ID, EMP_NAME) ( SELECT EMP_ID, EMP_NAME
                                                                    FROM EMPLOYEE
                                                                    WHERE DEPT_CODE = 'D6');
                                                                    -- NOT NULL 제약조건이 있는지 확인해야함 하앙상
                                                                    
 
 
 -- INSERT ALL이라는 명령어가 있다.                    
 -- INSERT ALL : 두 개 이상의 테이블에 값을 넣을 때 이용 > 한 개 쿼리문에서 두 개 테이블에 각각 값을 넣을 때
 
 CREATE TABLE EMP_HIRE_DATE
 AS 
    (SELECT  EMP_ID, EMP_NAME,  HIRE_DATE
      FROM EMPLOYEE
      WHERE 1=9 );


CREATE TABLE EMP_MANAGER
AS 
    (SELECT EMP_ID, EMP_NAME, MANAGER_ID
      FROM EMPLOYEE 
      WHERE 1=9 );
    
SELECT *
FROM EMP_HIRE_DATE;
SELECT *
FROM EMP_MANAGER;



INSERT ALL
--타겟
INTO EMP_HIRE_DATE VALUES( EMP_ID, EMP_NAME, HIRE_DATE)  --24개
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID) --24개
--레퍼런스
SELECT EMP_ID, EMP_NAME, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE;
--서브쿼리의 것을 가져온다. _ 48개 행 이(가) 삽입되었습니다.

--> INTO로 넣을 때 다 갖다 넣고 있네....
-- 조건에 따라 데이터를 각 테이블에 분리하여 저장하기

CREATE TABLE EMP_OLD
AS
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE 1=0;


CREATE TABLE EMP_NEW
AS
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE 1=0;


SELECT *
FROM EMP_OLD;
SELECT * 
FROM EMP_NEW;





INSERT ALL
WHEN HIRE_DATE  < '00/01/01' THEN
    INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, SALARY, HIRE_DATE) 
    
WHEN HIRE_DATE  > '00/01/01' THEN
    INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, SALARY, HIRE_DATE)


SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE;  --24개 행이 삽입 (8개 16개)

SELECT * 
FROM EMP_OLD;
SELECT *
FROM EMP_NEW;


------------------------------- INSERT문 끝 ----------------------------------------------------------
--얘는 그냥 외워서 쓸 수 밖에 없어요.. 어?? 왜이렇게 쓰지... 그냥 그렇게 쓰게 만들어놓은거니까
-- 관용적으로 쓰는거니까... 왜 그러지라고 생각해야하는 부분이 있고 그냥 해야하는 부분이 있는데 여기는 그냥 하는 부분이니까 (표준으로 정해 놓은거니까)





-- UPDATE : ROW를 수정하는 것 한 개 또는 그 이상의 ROW(DATA)를 수정하는 명령어 >
-- UPDATE 테이블명
-- SET 컬럼명 = 수정할 값 [,컬럼명2 = 값2, ......]
-- [WHERE = 조건];  --이긴 하지만 생략을 하지 않는 걸로 왜냐 그러면 다 !!!!!!! 바뀌니까 (전체를 바꿔버릴 수도 있어)


-----잘못 쓰면 데이터 훼손 가능 > 초급 개발자한테 안 맡기는 이유.....


CREATE TABLE DEPT_COPY
AS
(SELECT * FROM DEPARTMENT);

SELECT * FROM DEPT_COPY;

UPDATE DEPT_COPY 
SET DEPT_TITLE = '자바연구부';

ROLLBACK; --하기 싫으면 꼭  WHERE절을 쓴다. 



UPDATE DEPT_COPY 
SET DEPT_TITLE = '자바연구부'
WHERE DEPT_ID = 'D0'; -- 최대한 PRIMARY KEY를 중심으로 왜! UNIQUE&NOTNULL이니까


SELECT * FROM DEPT_COPY;






--다수의 컬럼을 수정 할 때는 쉽표로

UPDATE DEPT_COPY
SET DEPT_TITLE  = 'JDBC 연구부', DEPT_ID = 'K1', LOCATION_ID = 'L4'
WHERE DEPT_ID = 'D';

SELECT * FROM DEPT_COPY;
COMMIT; --하는 순간 롤백이 불가능하다... > 요즘은 데이터가 중요한 시대니까 >백업의 중요성....
ROLLBACK;

--이렇게 특정 컬럼에 값을 수정할 수 있다. 


--UPDATE에서 서브쿼리 이용하기


CREATE TABLE EMP_SALARY
AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, BONUS
FROM EMPLOYEE;

SELECT *
FROM EMP_SALARY;


-- 여기서 방명수의 급여와 보너스를 심봉선의 데이터와 동일하게 수정하고 싶다.

SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '심봉선';
--이걸 하나씩 주입하자고?? 


UPDATE EMP_SALARY
SET  



-- 




