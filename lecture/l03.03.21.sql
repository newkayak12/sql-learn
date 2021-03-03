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
SET  (SALARY, BONUS) = (  SELECT SALARY, BONUS 
                                        FROM EMPLOYEE
                                        WHERE EMP_NAME = '심봉선') 
WHERE EMP_NAME = '방명수';


SELECT *
FROM EMP_SALARY;

--임시환 사원의 직급을 과장, 부서를 해외영업 3부로 변경하는 쿼리를 작성

SELECT *
FROM DEPARTMENT;--D7
SELECT *
FROM JOB;  --J5

UPDATE EMP_SALARY
SET DEPT_CODE= 'D7', JOB_CODE= 'J5'
WHERE EMP_NAME = '임시환';


UPDATE EMP_SALARY
SET DEPT_CODE= (SELECT JOB_CODE       FROM JOB       WHERE JOB_NAME = '과장'),
        JOB_CODE= (SELECT DEPT_ID            FROM DEPARTMENT        WHERE DEPT_TITLE = '해외영업3부')
WHERE EMP_NAME = '임시환';

SELECT * 
FROM EMP_SALARY;

-- 
--위의 작업을 한 번에

UPDATE EMP_SALARY
SET (JOB_CODE, DEPT_CODE) = (SELECT JOB_CODE, DEPT_CODE 
                                            FROM JOB CROSS 
                                            JOIN DEPARTMENT
                                            WHERE JOB_NAME = '과장' AND DEPT_TITLE = '해외영업3부')
WHERE EMP_NAME = '임시환';                                            


-- 크로스 조인하면 다 연결되니까 그 중에 조건에 맞는 애를 끌어내면 됨 > 자주쓰면 따로 테이블로 빼놓고 써도 될듯???

--DELETE : 조건에 맞는 ROW(DATA)를 삭제하는 명령어...
-- DELETE FROM 테이블 [WHERE]
-- WHERE이 없으면 전체 삭제 / WHERE이 있으면 WHERE조건이 TRUE로 반환되는 ROW를 삭제




DELETE 
FROM EMP_SALARY;

ROLLBACK;


DELETE 
FROM EMP_SALARY
WHERE BONUS IS NULL;

ROLLBACK;

SELECT *
FROM EMP_SALARY;

-- DELETE사용시 주의할 점 : 외래키 제약 조건 , 삭제 대상의 ROW가 다른테이블에서 참조되고 있으면 삭제 불가능 (옵션으로 NULL OR CASCADE로 삭제가능)

-- TRUNCATE ROW를 삭제 : DELETE보다 속도가 빠름 BUT 트렌젝션 작업단위로 안 묶여서 ROLLBACK이 불가능
CREATE TABLE  TRUNC_TEST
AS
(SELECT * FROM EMP_SALARY);

SELECT *
FROM TRUNC_TEST;

TRUNCATE TABLE TRUNC_TEST;
--TABLE TRUNC_TEST이(가) 잘렸습니다.

ROLLBACK;


SELECT *
FROM TRUNC_TEST;
--롤백 안 됨...




--웹보단 DB를 가져와서 사용하는 > MERGE : 두 테이블을 합칠 때 사용하는 명령어


    CREATE TABLE TBL_MERGE01 (
    
    ID VARCHAR2 (20),
    NAME VARCHAR2 (20)
    
    );
    
    CREATE TABLE TBL_MERGE02 (
    
    ID VARCHAR2 (20),
    NAME VARCHAR2 (20)
    
    );
    
    
    SELECT * 
    FROM TBL_MERGE01;
      SELECT * 
    FROM TBL_MERGE02;
    
    INSERT INTO TBL_MERGE01 VALUES ('USR01', '유병승');
    INSERT INTO TBL_MERGE01 VALUES ('USR02', '김상현');
    INSERT INTO TBL_MERGE02 VALUES ('USR03', '김태희');
    INSERT INTO TBL_MERGE02 VALUES ('USR02', '김예진');
    
    
    --MERGE 01/ 02를 합치고 싶은건데
    
    MERGE INTO TBL_MERGE01
    USING TBL_MERGE02 ON (TBL_MERGE01.ID = TBL_MERGE02.ID) --주로 PK를 넣겠지
    WHEN MATCHED THEN   --같을 때 /다를 때  기준을 잡아줘야지₩
            UPDATE SET TBL_MERGE01.NAME = TBL_MERGE02.NAME --동일 값이 있으면 TBL_MERGE02를 반영
    WHEN NOT MATCHED THEN
            INSERT VALUES (TBL_MERGE02.ID, TBL_MERGE02.NAME);
            
            DROP TABLE TBL_MERGE01;
            DROP TABLE TBL_MERGE02;
            
            --2개 행 이(가) 병합되었습니다.
    
    
    -- 여기까지 DML > 그냥 정해진 대로 쓰면 되는거니까...
    
    
    
    -- DDL (ALTER/DROP)
    
    -- 테이블을 수정할 수 있게
    --ALTER는 꼭 테이블에 한한게 아니라 오브젝트 (*********************다시 찾아서 작성요망 ********************)
    
    
    
    --ALTER : 테이블 등 오라클 객체를 수정하는 명령어
    -- 컬럼을 추가, 삭제, 컬럼명 변경/ 자료형 변경/ DEFAULT값 주기
    -- 제약조건 변경, 추가/삭제, 이름변경
    
    
    
    
    CREATE TABLE TBL_USER_ALTER(
    
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20)
    
    );
    
    
    
    SELECT *
    FROM TBL_USER_ALTER;
    
    --컬럼 추가하기 ALTER를 사용
    -- ALTER TABLE 테이블명  ADD( 변수명, 데이터형, 제약조건);
    ALTER TABLE TBL_USER_ALTER 
    ADD(USER_NAME VARCHAR2(20));
    
    INSERT INTO TBL_USER_ALTER VALUES(1,'ADMIN','1234','관리자');
    
    --기존 데이터가 있는 상태에서 테이블에 컬럼을 추가하면? 
    -- NO    ID       PWD      NAME   ???
    -- 1	ADMIN	1234	관리자
    
    ALTER TABLE TBL_USER_ALTER
    ADD(NICK_NAME VARCHAR2(20));
    --   NO    ID         PWD      NAME   NICKNAME
    --   1	ADMIN	1234	관리자	(NULL)
    
    
    --이미 데이터가 있는 곳에서 제약조건을 설정하면??
    
    ALTER TABLE TBL_USER_ALTER
    ADD(EMAIL VARCHAR2(50) NOT NULL);
 --   오류 보고 -
--ORA-01758: TABLE MUST BE EMPTY TO ADD MANDATORY (NOT NULL) COLUMN
--01758. 00000 -  "TABLE MUST BE EMPTY TO ADD MANDATORY (NOT NULL) COLUMN"
--*CAUSE:    
--*ACTION:
-- 데이터가 있는 상태에서 컬럼 만들면 NULL로 시작하니까 NOT NULL이 안되는 거고
DELETE FROM TBL_USER_ALTER;

INSERT INTO TBL_USER_ALTER VALUES(1,'ADMIN','1234','관리자','관리', 'ADMIN@HOT.COM');
 
 SELECT *
 FROM TBL_USER_ALTER;
 
 ALTER TABLE TBL_USER_ALTER
 ADD (AGE NUMBER DEFAULT 0 NOT NULL);
 -- ADD(변수명/ 데이터형/ DEFAULT 디폴트값( 값이 없을 경우 NULL이 아니라) /NOT NULL);  >이러면 중간에 컬럼 추가 가능하지 NOT NULL이 있는
 
 INSERT INTO TBL_USER_ALTER
 (USER_NO, USER_ID, USER_NAME, EMAIL) VALUES(2, 'USER00', 'U00', 'U00@U.COM');  -- >이렇게 AGE지정 안하면. 디폴트 값들어감
 
 DELETE
 FROM TBL_USER_ALTER
 WHERE USER_ID = 'USER00';
 
 INSERT INTO TBL_USER_ALTER VALUES(3,'USER01', 'USER01', '영일', '영일영일', 'A@COM',20);
    
    
   
 SELECT *
 FROM TBL_USER_ALTER;
 
 
 --기존 테이블에 컬럼 추가.....!
 
 
 --ALTER로 제약조건을 추가해보기  
 
 ALTER TABLE TBL_USER_ALTER
 ADD UNIQUE(USER_ID);
 -- 할 수는 있는데 추천은 안 함 > 제약조건 명칭이 자동으로 부여되서 구별하기 힘들다는 단점이 있음
 
 ALTER TABLE TBL_USER_ALTER
 ADD CONSTRAINT UQ_NAME UNIQUE(USER_NAME);
 --이렇게 제약조건 명칭 주는걸 추천
 
 SELECT *
 FROM TBL_USER_ALTER;
 
 
 
 --제약조건 삭제
 ALTER TABLE TBL_USER_ALTER
 DROP CONSTRAINT UQ_NAME;
 -- DROP CONSTRAINT (제약조건이름( CONSTRAINT_NAME));
 
 --컬럼명 수정하기
 ALTER TABLE TBL_USER_ALTER 
 RENAME COLUMN USER_PWD TO PASSWORD;
 
 
 SELECT *
 FROM TBL_USER_ALTER;
 
 ALTER TABLE TBL_USER_ALTER
 RENAME CONSTRAINT SYS_C0016320 TO PK_TBL_USER_NO;
 
 --컬럼에 대한 타입을 변경하기!!!!!!!!!!
 --MODIFY 쿼리문을 사용
 ALTER TABLE TBL_USER_ALTER
 MODIFY USER_NAME VARCHAR2 (200);
 
 --잘 바뀜...
 DESC TBL_USER_ALTER;
 
 
 --기존 데이터 길이보다 줄이면??
  ALTER TABLE TBL_USER_ALTER
 MODIFY USER_NAME VARCHAR2 (2);
 
 --명령의 549 행에서 시작하는 중 오류 발생 -
-- ALTER TABLE TBL_USER_ALTER
-- MODIFY USER_NAME VARCHAR2 (2)
--오류 보고 -
--ORA-01441: CANNOT DECREASE COLUMN LENGTH BECAUSE SOME VALUE IS TOO BIG
--01441. 00000 -  "CANNOT DECREASE COLUMN LENGTH BECAUSE SOME VALUE IS TOO BIG"
--*CAUSE:    
--*ACTION:

--데이터가 없으면 상관이 없는데 데이터가 이미 있으면 문제가 된다. 
SELECT *
FROM TBL_USER_ALTER;

--NOT NULL 제약조건 TBL_USER_ALTER에 USER_NAME컬럼에 
--ALTER TABLE TBL_USER_ALTER
--ADD CONSTRAINT NN_USER_NAME NOT NULL (USER_NAME);


-- NULL에 대한 제약 조건은 DEFAULT로 설정이 되어있으므로.... > 설정되어 있는 것을 변경해야한다(DEFAULT : NULL ABLE)

ALTER TABLE TBL_USER_ALTER
MODIFY USER_NAME CONSTRAINT NN_USER_NAME NOT NULL;
--NOT NULL은 MODIFY로 해야한다. 이미 있기 떄문에


--컬럼을 삭제하는 것

SELECT *
FROM TBL_USER_ALTER;



ALTER TABLE TBL_USER_ALTER
DROP COLUMN USER_NAME;


--테이블 명칭 바꾸기

ALTER TABLE TBL_USER_ALTER
RENAME TO CHANGE_TABLE;

DESC TBL_USER_ALTER;
--오류:
--ORA-04043: TBL_USER_ALTER 객체가 존재하지 않습니다.

DESC CHANGE_TABLE;


-- 얘는 그냥 RENAME 해서 써도 ㅇ된다.

RENAME CHANGE_TABLE TO TBL_USER_ALTER;

DESC CHANGE_TABLE;
--오류:
--ORA-04043: CHANGE_TABLE 객체가 존재하지 않습니다.

DESC TBL_USER_ALTER;




--마지막으로 DROP 으로 테이블 삭제하기

DROP TABLE TBL_USER_ALTER;
--참조관계 (외래키 주의)
ROLLBACK;

SELECT *
FROM TBL_USER_ALTER;


    CREATE TABLE TBL_USER(
    EMP_ID VARCHAR2(20) REFERENCES EMP_DEP_COPY(EMP_ID)
    );
    DROP TABLE TBL_USER;
    
    ALTER TABLE EMP_DEP_COPY ADD CONSTRAINT UQ_EMP_ID UNIQUE(EMP_ID);
    
    SELECT *
    FROM TBL_USER;
    DROP TABLE EMP_DEP_COPY;
    
    
--명령의 632 행에서 시작하는 중 오류 발생 -
--    DROP TABLE EMP_DEP_COPY
--오류 보고 -
--ORA-02449: UNIQUE/PRIMARY KEYS IN TABLE REFERENCED BY FOREIGN KEYS
--02449. 00000 -  "UNIQUE/PRIMARY KEYS IN TABLE REFERENCED BY FOREIGN KEYS"
--*CAUSE:    AN ATTEMPT WAS MADE TO DROP A TABLE WITH UNIQUE OR
--           PRIMARY KEYS REFERENCED BY FOREIGN KEYS IN ANOTHER TABLE.
--*ACTION:   BEFORE PERFORMING THE ABOVE OPERATIONS THE TABLE, DROP THE
--           FOREIGN KEY CONSTRAINTS IN OTHER TABLES. YOU CAN SEE WHAT
--           CONSTRAINTS ARE REFERENCING A TABLE BY ISSUING THE FOLLOWING
--           COMMAND:
--           SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = "TABNAM";

    
    --그래서 외래키를 사용하면 이렇게 안 지워진다는 소리임...
    --그래서 자식을 지우고 부모를 지우면 되겠죠?
    -- 근데 그렇게 안하고
    DROP TABLE EMP_DEP_COPY CASCADE CONSTRAINT;
    -- 외래키가 사라짐..
    
    SELECT * 
    FROM EMP_DEP_COPY;
    
    
    
    
--여기까지 DDL구문 이것들을 잘 정리해야하빈다.



-------DCL(DATA CONTROL LANGUAGE) : 데이터 제어 언어 : DB에 대한 보안/ 무결성/ 복구 등 DBMS를 제어하기 위한 언어
--------> 권한 부여(GRANT/ REVOKE) / (TCL이라고도 부름)트렌젝션 관리(COMMIT/ ROLLBACK)


-- GRANT : 사용자에게 권한/ ROLE(를)을 부여하는 명령어이다. 
-- GRANT 권한/ ROLE이름 TO 사용자 계정[WITH ADMIN OPTION: 관리자 권한 주는 것]

CREATE USER QWER IDENTIFIED BY QWER;
GRANT CREATE SESSION TO QWER; --DOCKER DBA  --여기에서는 실제 권한 명으로 권한을 부여한거고
GRANT CONNECT TO QWER; --여기에서는 ROLE로 지정된 권한을 부여

--사용자에게 부여된 권한 조회
-- 실제 권한 명으로 조회
SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE='QWER';


--ROLE을 조회
SELECT *
FROM DBA_ROLE_PRIVS
WHERE GRANTEE= 'KH';

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE= 'KH';




SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE='QWER';

SELECT *
FROM DBA_
WHERE PRIVILEGE= 'CREATE SESSION';



SELECT * FROM USER_ROLE_PRIVS;


--QWER 계정에는 CREATE SESSION 권한만 부여가 되어있음
-- 접속만 가능

    CREATE TABLE TEST(

        NAME VARCHAR2(20)


    );
    
    
    GRANT CREATE TABLE TO QWER;
    --ALTER USER QWER QUOTA UNLIMITED ON USERS;
    ALTER USER QWER DEFAULT TABLESPACE USERS; -- TALBE SPACE에 대한 영역 확보
    
    
    
    SELECT * 
    FROM DBA_SYS_PRIVS
    WHERE GRANTEE = 'CONNECT';
    
    SELECT * FROM DBA_SYS_PRIVS
    WHERE GRANTEE = 'RESOURCE';
    
    --권한을 부여하여 다른 계정에 있는 테이블을 이용하게 만들기
    --원래는 계정별로 자기 공간이 있고 침범하지 못한다고 했는데,  단 권한이 부여되면 접근할 수 있다.
    
    
    SELECT *
    FROM KH.DEPARTMENT;
    -- 권한이 없어서 접근이 안됨
    
    GRANT SELECT ON KH.DEPARTMENT TO QWER;  --DBA(SYSTEM으로)
     
     SELECT *
    FROM KH.DEPARTMENT;
    --실행 됨
    
    INSERT INTO KH.DEPARTMENT VALUES ('K2', '백수부', 'L3');
    
    GRANT INSERT ON KH.DEPARTMENT TO QWER;
    
    --권한이 다 따로 있음
    
    SELECT *
    FROM DEPARTMENT; -- KH에는 반영이 안되네..?
    
    SELECT *
    FROM KH.DEPARTMENT; --여기에는 있는데??
    COMMIT;
    
    --- 트렌젝션 때문에 COMMIT을 안했잖아... > 변경사항에 대해서 COMMIT전까지는 반영 X
    
    
    --커밋을 하니까 KH에도 반영되네...
    
    -- REVOKE로 권한을 회수할 수 있다.
    REVOKE INSERT ON KH.DEPARTMENT FROM QWER;
    INSERT INTO KH.DEPARTMENT VALUES ('K3', '백수부2', 'L3');
    
 --   명령의 766 행에서 시작하는 중 오류 발생 -
--INSERT INTO KH.DEPARTMENT VALUES ('K3', '백수부2', 'L3')
--오류 발생 명령행: 766 열: 20
--오류 보고 -
--SQL 오류: ORA-01031: INSUFFICIENT PRIVILEGES
--01031. 00000 -  "INSUFFICIENT PRIVILEGES"
--*CAUSE:    AN ATTEMPT WAS MADE TO PERFORM A DATABASE OPERATION WITHOUT
--          THE NECESSARY PRIVILEGES.
--*ACTION:   ASK YOUR DATABASE ADMINISTRATOR OR DESIGNATED SECURITY
--          ADMINISTRATOR TO GRANT YOU THE NECESSARY PRIVILEGES


-- 한 번에 권한을 부여하고 뺏는
    GRANT INSERT, SELECT, UPDATE, DELETE, ON KH.EMPLOYEE TO QWER;
    REVOKE INSERT, SELECT, UPDATE, DELETE ON KH.EMPLOYEE FROM QWER;

-- A계좌에서 ...................... B계좌로 이체를 합니다.
-- A에서 -100을 업데이트하면 B에서도 +100으로 UPDATE를 하죠
-- 만약 +100에서 에러가 나면 100원이 공중분해 되죠
--그래서 A의 업뎃과 B 업뎃을 하나의 작업단위로 묶어서 둘 중 하나라도 에러가 나면 원상태로 돌리는거죠
-- A/B에서 에러 안나면 작업을 확정한다. >>>
-- 트랜젝션의 예시죠
---


---트렌젝션이라는 것은 : 작업의 한 개 단위를 의미한다. 취소되면 모두 취소/ 정상 작동하면 okay
-- 트렌젝션은 INSERT,UPDATE,DELETE > 테이블의 데이터를 조작할 때 사용
-- commit/rollback
create table tbl_user(
emp_id varchar2 (20)
);

--kh
select * from tbL_user;
insert into tbl_user values('USER01');
insert into tbl_user values('USER02');
insert into tbl_user values('USER03');
commit;
update tbl_user set emp_id = 'TEST';
rollback;


select * from kh.tbl_user;
insert into kh.tbl_user values('USER04');
insert into kh.tbl_user values('USER05');
insert into kh.tbl_user values('USER06');
commit;

--commit을 하기 전까지 임시로 가지고 있다.

-- 업뎃/ 삽입/ 수정에 대해서 항상 트렌젝션처리를...
grant connect to QWER;