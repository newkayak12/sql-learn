
-- 0304

-- 배운 내용 : VIEW, SEQUENCE, INDEX, PL/SQL




-- VIEW : RESULTSET으로 만들어진 가상의 테이블 
-- SELECT문으로 실제테이블에서 데이터를 가져와 사용한다
-- VIEW는 OBJECT로 DDL구문을 이용하여 생성, 수정, 삭제한다

-- CREATE VIEW VIEW명칭 AS SELECT문

CREATE VIEW V_EMPLOYEEALL
AS SELECT * 
    FROM EMPLOYEE  
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN JOB USING(JOB_CODE);
-- "insufficient privileges"
-- VIEW를 생성하려면 권한을 부여해야함 ( CREATE VIEW 권한 )

GRANT CREATE VIEW TO KH;

-- 권한부여되니까 view 생성된다. 

-- VIEW를 생성하고나면 VIEW명칭을 FROM절에 사용하여 테이블처럼 사용이 가능

SELECT *
FROM V_EMPLOYEEALL;

-- 위의 구문은
-- SELECT * 
-- FROM ( SELECT... 인라인뷰 
-- 와 동일 


-- 저장된 VIEW 확인하기

SELECT *
FROM USER_VIEWS;

-- VIEW를 만들어놓고 VIEW이름으로 사용하면 편하다. 



CREATE VIEW V_EMP_UNION

    AS SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        
        UNION
        
        SELECT DEPT_TITLE, 10
        FROM DEPARTMENT;
    
    
    
CREATE VIEW V_EMP_AVG
AS SELECT DEPT_CODE, FLOOR(AVG(SALARY)) AS 평균
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    
    UNION 
    
    SELECT JOB_CODE, FLOOR(AVG(SALARY)) AS 평균
    FROM EMPLOYEE
    GROUP BY JOB_CODE
    
    UNION
    
    SELECT '총평균', FLOOR(AVG(SALARY)) AS 평균
    FROM EMPLOYEE;
    
SELECT *
FROM V_EMP_AVG;
    
    
    
    
    
-- VIEW 삭제하기

DROP VIEW V_EMP_UNION;

SELECT * 
FROM USER_VIEWS;





-- VIEW 특징

-- 1. 컬럼, 산술연산까지 포함 할 수 있다. 단 산술연산시에는 반드시 별칭을 부여해야함 

CREATE VIEW V_EMP_SALARY
AS SELECT EMP_NAME, (SALARY + ( SALARY * NVL(BONUS, 0) ) )*12 AS 연봉
    FROM EMPLOYEE;

SELECT *
FROM V_EMP_SALARY;


-- VIEW도 권한을 부여해서 이용가능하게 만들 수 있다.

-- QWER계정으로전환 
SELECT * 
FROM KH.EMPLOYEE; -- 접근 불가 


SELECT *
FROM KH.DEPARTMENT; -- 접근 가능 



-- DBA계정으로 전환
GRANT SELECT ON KH.V_EMPLOYEEALL TO QWER;

-- QWER계정으로전환
SELECT * 
FROM KH.V_EMPLOYEEALL; -- 조회 가능 

SELECT *
FROM KH.JOB; -- 조회 불가 





-- VIEW로 DML 활용하기 
-- DML : INSERT, UPDATE, DELETE 
-- 가능하면 실제 테이블에 있는 값이 변경된다 
-- VIEW는 실제테이블과 링크(연결)되어있어 값을 수정하면 실제테이블의 값이 변경된다

-- 만약 가상컬럼(실제테이블에 존재하지 않는 컬럼)이 존재한다면 DML쓸 수 없다 

SELECT *
FROM V_EMP_SALARY;

UPDATE V_EMP_SALARY 
SET 연봉 = 200000000;
-- "virtual column not allowed here" 
-- 연봉은 실제테이블에 없는 컬럼이야 
-- 가상컬럼에 값을 수정할 수 없어~



UPDATE V_EMP_SALARY
SET EMP_NAME = '테스트'; -- 24개 행 업데이트 

SELECT *
FROM V_EMP_SALARY; -- 이름이 다 바뀌었다!!( 실제테이블의 EMP_NAME 값이 변경됨) 

ROLLBACK;




DELETE FROM V_EMP_SALARY
       WHERE EMP_NAME = '고두밋';

SELECT *
FROM V_EMP_SALARY; -- 고두밋 행이 사라졌다



-- 가상테이블 생성
CREATE VIEW V_EMP
    AS SELECT EMP_ID, EMP_NO, EMP_NAME, EMAIL, PHONE, JOB_CODE, SAL_LEVEL
        FROM EMPLOYEE;
        
INSERT INTO V_EMP 
        VALUES('500', '960626-2022002', '김예진', '12-47@gmail.com', '01012341234', 'J2', 'S3');

SELECT *
FROM V_EMP;


-- 실제테이블 조회

SELECT *
FROM EMPLOYEE; -- 김예진 행이 추가되어있다. 대신에 추가하지 않은 컬럼의 값은 null이 되어있다. 


-- NOT NULL제약조건이 있으면 추가 불가능


UPDATE V_EMP
SET DEPT_CODE = 'D5'
WHERE EMP_NAME = '김예진';
-- 오류 "DEPT_CODE": invalid identifier 
-- view에는 이 컬럼이 없으니까 불가능 





-- DML구문 조작이 불가능한 경우
-- 1. VIEW에서 정의하고 있지 않은 컬럼을 조작하는 경우
-- 2. VIEW에 포함되지 않은 컬럼중 베이스(실제 테이블)가 되는 컬럼이 NOT NULL제약조건 걸려있을때 
-- 3. 산술연산으로 구성된 컬럼(가상 컬럼)
-- 4. 그룹함수 또는 GROUP BY 절이 포함된 VIEW 
-- 5. DISTINCT를 포함하고 있는 경우
-- 6. JOIN을 통해 여러테이블을 연결하고 있는 경우 (예외 있음)





-- 뷰 옵션
-- 1. OR REPLACE 
-- 덮어쓰기 
-- 테이블과 뷰.. 오브젝트는 이름이 중복되어서는 안돼

CREATE VIEW V_EMP_SALARY
    AS SELECT * FROM EMPLOYEE;
    --  "name is already used by an existing object" : 이미 존재하는 뷰 
    
CREATE OR REPLACE VIEW V_EMP_SALARY
    AS SELECT * FROM EMPLOYEE;
    
-- 없으면 생성하고, 있으면 덮어쓰기 하라 

SELECT *
FROM V_EMP_SALARY;


-- 2. FORCE / NOFORCE 
-- 실제 테이블이 없어도 먼저 VIEW를 생성할 수 있게 해주는 옵션

CREATE VIEW V_FORCETEST
    AS SELECT A, B, C FROM NOTHINGBETTER;
    --M"table or view does not exist"
    
CREATE FORCE VIEW V_FORCETEST
    AS SELECT A, B, C FROM NOTHINGBETTER; -- 생성 가능
    
SELECT *
FROM V_FORCETEST; 
    
CREATE TABLE NOTHINGBETTER(
    A NUMBER,
    B NUMBER, 
    C NUMBER
);
    
SELECT *
FROM V_FORCETEST;     
    
    
    
    
    
-- 3. WITH CHECK OPTION 
-- SELECT문의 WHERE절에서 사용한 컬럼을 수정하지 못하게 하는 옵션 

CREATE OR REPLACE VIEW V_CHECKOPTION
    AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5' WITH CHECK OPTION;

SELECT *
FROM V_CHECKOPTION;

UPDATE V_CHECKOPTION 
    SET DEPT_CODE = 'D6'; 
-- WHERE절에서 WITH CHECK OPTION으로 사용한 컬럼의 값을 수정하는것은 불가능 

ROLLBACK;


UPDATE V_CHECKOPTION 
    SET SALARY = 6000000 
    WHERE EMP_ID = 215;
-- SALARY는 WITH CHECK OPTION 없으니까 값 변경 가능 

ROLLBACK;



-- 4. WITH READ ONLY
-- VIEW자체를 수정 못하게 차단하는 옵션 

CREATE OR REPLACE VIEW V_READ
    AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D5' WITH READ ONLY;
        
UPDATE V_READ SET SALARY = 10000000000; -- V_READ는 읽기 전용이라 수정 불가능

SELECT *
FROM V_READ;



-- 시퀀스
-- SEQUENCE
-- 자동번호부여기
-- CREATE SEQUENCE 시퀀스명 [옵션...]

-- 시퀀스 작동 예약어 :  시퀀스명.NEXTVAL, 시퀀스명.CURRVAL

CREATE SEQUENCE SEQ_BASIC;

--시퀀스 이용 (실행할 때마다 1씩 증가하며 번호 부여 -> 중복 되지 않음 )
SELECT SEQ_BASIC.NEXTVAL
FROM DUAL;

-- 현재 값 확인하고싶으면
SELECT SEQ_BASIC.CURRVAL
FROM DUAL;


-- 옵션 주기 
CREATE SEQUENCE SEQ_OPTION
    START WITH 100
    INCREMENT BY 10;
    
SELECT SEQ_OPTION.NEXTVAL
FROM DUAL;


CREATE SEQUENCE SEQ_OPTION2
    START WITH 60
    INCREMENT BY 6
    MAXVALUE 90
    MINVALUE 0
    CYCLE
    NOCACHE;
    -- CYCLE하려면 최대최소값 필요, 캐시값 필요 
    
SELECT SEQ_OPTION2.NEXTVAL
FROM DUAL;
-- 90이 넘어가면 다시 0부터 시작 


-- 노사이클 

CREATE SEQUENCE SEQ_OPTION3
    START WITH 60
    INCREMENT BY 6
    MAXVALUE 90
    MINVALUE 0
    NOCYCLE
    NOCACHE;
    
    
SELECT SEQ_OPTION3.NEXTVAL
FROM DUAL; 
-- MAX값에 다다르면 더이상 증가하지 않고 멈춤 



-- 시퀀스 이용
CREATE TABLE BOARD(
    BOARD_NO NUMBER PRIMARY KEY,
    BOARD_TITLE VARCHAR2(200) NOT NULL,
    BOARD_CONTENT VARCHAR2(800), 
    BOARD_WRITER VARCHAR2(20) REFERENCES EMPLOYEE(EMP_ID),
    BOARD_DATE DATE
);

CREATE SEQUENCE SEQ_BOARD_NO;

INSERT INTO BOARD VALUES(SEQ_BOARD_NO.NEXTVAL, '예진씨 글', '상현씨 좀 700', '200', SYSDATE);

SELECT *
FROM BOARD;

INSERT INTO BOARD VALUES(SEQ_BOARD_NO.NEXTVAL, '예진씨 글2', '예진이는 안700', '201', SYSDATE);

DROP TABLE BOARD;


-- 시퀀스 정보 조회

SELECT *
FROM USER_SEQUENCES;




-- 시퀀스 번호 형식 변경
SELECT 'B_' || SEQ_BOARD_NO.NEXTVAL
FROM DUAL;




-- 시퀀스 수정하기
-- ALTER 이용

ALTER SEQUENCE SEQ_BOARD_NO
    MAXVALUE 100;
    
SELECT *
FROM USER_SEQUENCES;



-- 시퀀스 삭제 
-- DROP 이용
DROP SEQUENCE SEQ_OPTION;



-- NEXTVAL, CURRVAL
-- CURRVAL는 동일세션에서 NEXTVAL을 한번이라도 실행 한 후 조회할 수 있다. 

CREATE SEQUENCE SEQ_TEST;

SELECT SEQ_TEST.CURRVAL
FROM DUAL; -- 불가능



SELECT SEQ_TEST.NEXTVAL
FROM DUAL;

SELECT SEQ_TEST.CURRVAL
FROM DUAL; -- 이제야 가능 



--  NEXTVAL, CURRVAL를 사용할 수 없는 구문

-- VIEW의 SELECT구문
-- DISTINCT가 포함된 SELECT문 
-- GROUP BY, HAVING, ORDER BY가 있는 SELECT문
-- SELECT, UPDATE, DELETE 서브쿼리
-- CREATE TABLE, ALTER TABLE의 DEFAULT값에 못 씀 









-- INDEX : 전체적인 DBMS의 성능향상을 위해 설정

SELECT *
FROM USER_INDEXES;

-- 컬럼을 조회
SELECT *
FROM USER_IND_COLUMNS;


SELECT *
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME = '송종기';

CREATE INDEX IND_EMPLOYEE ON EMPLOYEE(EMP_NAME);

-- 검색속도가 살짝 빨라지는 효과

SELECT *
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME = '송종기';


-- 인덱스 삭제
DROP INDEX IND_EMPLOYEE;


-- 여러개 컬럼에 인덱스를 부여
CREATE INDEX IND_EMPLOYEE_COM ON EMPLOYEE(EMP_NAME, DEPT_CODE);

SELECT *
FROM EMPLOYEE
WHERE EMP_NAME = '박나라' AND DEPT_CODE = 'D5';









-- PL/SQL 구문

-- 유형
-- 1. 익명 블록 : 이름이 없어서 재호출이 불가능 
-- 2. 프로시져, 함수 : 이름이 있어서 재호출이 가능함 


-- 구조 

-- DECLARE  선언부
-- 변수를 선언 

-- BEGIN  실행부
-- 제어문, 반복문, 함수

-- EXCEPTION 예외처리부
-- 예외 발생 상황 

-- END;
-- / (PL/SQL구문이 끝났다는 표시)




SET SERVEROUTPUT ON;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('나의 첫 PL/SQL');
END;
/



DECLARE 
    VID VARCHAR2(20); -- 변수선언 
BEGIN
    SELECT EMP_ID
    INTO VID
    FROM EMPLOYEE 
    WHERE EMP_NAME = '이오리';
    
    DBMS_OUTPUT.PUT_LINE( 'VID : ' || VID );
END;
/

-- PL/SQL에서 SELECT문을 쓸 땐 INTO를 써야한다 
-- EMPLOYEE 테이블의 EMP_NAME = '이오리'인 EMP_ID을 셀렉해서 변수 VID에 집어넣는다 



-- 변수 선언하기 
-- 변수명 [CONSTANT] 자료형(바이트) [NOT NULL]
-- 변수명 자료형 := 초기값;

DECLARE
    V_EMPNO NUMBER;
    V_EMPNAME VARCHAR2(20);
    TEST_NUM NUMBER := 10 + 30;
BEGIN
    V_EMPNO := 999;
    V_EMPNAME := '차태현';
    DBMS_OUTPUT.PUT_LINE('사번 : ' || V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || V_EMPNAME);
    DBMS_OUTPUT.PUT_LINE('번호 : ' || TEST_NUM);
END;
/



-- 변수 자료형타입 알아보자

-- 자료형은 기본자료형(oracle 자료형)과 복합자료형으로 구분된다

-- 기본자료형 : NUMBER, VARCHAR2, DATE, BOOLEAN, BINARY, INTEGER...
-- 복합자료형 : 레코드, 커서, 컬렉션 ...

-- 변수의 종류 : 일반변수, 참조형 변수(테이블의 컬럼에 지정된 자료형을 가져와 사용)


-- 참조형 변수 
-- 1. %TYPE : 지정한 테이블의 컬럼의 자료형을 참조하는 레퍼런스 자료형

DECLARE 
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    V_SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, SALARY
    INTO V_EMP_ID, V_SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = 200; -- VARCHAR2여도 저절로 형변환 되니까 ㄱㅊ 
    DBMS_OUTPUT.PUT_LINE(V_EMP_ID || ' ' || V_SALARY);
END;
/


-- 2. %ROWTYPE : 테이블에 지정되어있는 한개의 ROW의 모든 컬럼을 가져오는 자료형 

DECLARE
    VEMP EMPLOYEE%ROWTYPE; -- VEMP는 한개의 ROW를 담는 변수 
BEGIN 
    SELECT *
    INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_NAME = '송종기';

    DBMS_OUTPUT.PUT_LINE(VEMP.EMP_ID || VEMP.EMP_NAME || VEMP.SALARY );
END;
/

-- VEMP를 하나의 객체처럼 볼 수 도 있음  -> .으로 접근가능하니까 
 
 
 

-- 3. RECORD : 클래스(객체)같은 존재
-- 테이블에서 컬럼의 타입을 가져와서 한 묶음으로 만들 수 있음. 

-- MY_RECORD : 자료형(타입) 

DECLARE

    TYPE MY_RECORD IS RECORD( -- 괄호 안에 자료형 선언 
    
        ID EMPLOYEE.EMP_ID%TYPE,
        NAME EMPLOYEE.EMP_NAME%TYPE,
        TITLE DEPARTMENT.DEPT_TITLE%TYPE
    );
    
    MY MY_RECORD; -- MY는 변수명 
    
BEGIN 

    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    INTO MY
    FROM EMPLOYEE 
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_NAME = '전지연';

    DBMS_OUTPUT.PUT_LINE(MY.ID || ' ' || MY.NAME || ' ' || MY.TITLE);
    
END;
/




-- 4. 컬렉션 자료형
-- 컬렉션은 자바의 배열과 같은 형태를 가지고 있다 
-- 선언방식은 레코드와 유사하나, 컬렉션은 배열형태니까 인덱스가 있어야 한다. 

-- VA_TYPE : 자료형(타입)

DECLARE

    TYPE VA_TYPE IS VARRAY(5) OF VARCHAR2(10); -- 문자열을 저장할 수 있는 자리 5개 짜리 배열 
    
    V_VA VA_TYPE;
    V_CNT NUMBER := 0;
    
BEGIN 

    V_VA := VA_TYPE('FIRST', 'SECOND', 'THIRD', '', '');
    
    LOOP   
    
        V_CNT := V_CNT + 1;
        IF V_CNT > 5 THEN EXIT;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(V_CNT || ' ' || V_VA(V_CNT));
        
    END LOOP;
    
END;
/




-- 5. TABLE 자료형 배열 --배열길이 지정 없이 

DECLARE 

    TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE
    INDEX BY BINARY_INTEGER;
    
    EMP_ID_TABLE EMP_ID_TABLE_TYPE;
    I BINARY_INTEGER := 0;
    
BEGIN 

    FOR K IN (SELECT EMP_ID FROM EMPLOYEE) LOOP
    
        I := I + 1;
        EMP_ID_TABLE(I) := K.EMP_ID;
        
    END LOOP;
    
    FOR J IN 1..I LOOP
    
        DBMS_OUTPUT.PUT_LINE(EMP_ID_TABLE(J));
        
    END LOOP;
    
END;
/
    
SET SERVEROUTPUT ON;

-- PL/SQL구문에서 SELECT문 사용하기
-- PL/SQL 구문에서 조회한 결과를 변수에 저장하고 활용하기 위해서 SELECT문을 사용
-- PL/SQL구문에서 SELECT문 사용할 때는 반드시 INTO를 사용하여 대입해야한다 

DECLARE 

    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    
BEGIN

    SELECT EMP_ID
    FROM EMPLOYEE
    WHERE EMP_NAME = '방명수';
    
END;
/
-- 오류 

DECLARE 

    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    
BEGIN

    SELECT EMP_ID
    INTO EMP_ID
    FROM EMPLOYEE
    WHERE EMP_NAME = '방명수';
    
END;
/




-- PL/SQL구문을 이용하여 INSERT문 처리하기

-- 테스트용 ( 더미데이터 생성해놓고 여기서 처리하거나 .. 이런저런것을 해볼수 있다)
BEGIN

    FOR K IN 1..10 LOOP
    
        -- INSERT INTO MEMBER VALUES('USER00', 'USER00', '유저공공');
        INSERT INTO MEMBER VALUES('USER0' || K, 'USER0' || K, '유저공' || K);
        
        COMMIT;
        
    END LOOP;
    
END;
/


SELECT *
FROM MEMBER;

SELECT *
FROM DEPARTMENT;




-- 1. 사원번호를 입력받아 사원의 사원번호, 이름, 부서코드, 부서명 출력
-- 각 컬럼별 변수를 생성하기

SELECT *
FROM EMPLOYEE;

DECLARE
    -- E_EMP_ID VARCHAR2(3);
    --E_EMP_NAME VARCHAR2(20);
    --E_DEPT_CODE CHAR(2);
    --E_DEPT_TITLE VARCHAR2(35);
    
    E_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    E_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    E_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    E_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO E_EMP_ID, E_EMP_NAME, E_DEPT_CODE, E_DEPT_TITLE
    FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || E_EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || E_EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE : ' || E_DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : ' || E_DEPT_TITLE);
END;
/
    
-- 선생님 풀이
DECLARE 

    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTCODE EMPLOYEE.DEPT_CODE%TYPE;
    VDEPTTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    
BEGIN

    SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPID, VEMPNAME, VDEPTCODE, VDEPTTITLE
    FROM EMPLOYEE
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE(VEMPID);
    DBMS_OUTPUT.PUT_LINE(VEMPNAME);
    DBMS_OUTPUT.PUT_LINE(VDEPTCODE);
    DBMS_OUTPUT.PUT_LINE(VDEPTTITLE);
END;
/

-- 2. 사원번호를 입력받아 해당 사원의 정보(한 행)를 한 변수에 모두 입력받아 
-- 사번, 이름, 주민번호, 급여를 출력

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    -- SELECT EMP_ID, EMP_NAME, EMP_NO, SALARY
    SELECT *
    INTO E
    FROM EMPLOYEE 
    -- WHERE EMP_ID = '205';
    WHERE EMP_ID = '&EMP_ID';

    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO : ' || E.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || E.SALARY);
END;
/


-- 3. EMPLOYEE테이블에서 사번 마지막 번호를 구한 뒤, +1한 사번에 사용자로부터 입력받은
-- 이름, 주민번호, 전화번호, 직급코드(J5), 급여등급(S5)를 등록하는 PL/SQL문을 작성해라 

-- 엠퍼샌드 연산 
-- 예를들어
-- begin    
    -- INSERT INTO MEMBER VALUES('&아이디', '&비밀번호', '&이름');
    -- COMMIT;
-- END;
--/

DECLARE
    
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VEMP_NO EMPLOYEE.EMP_NO%TYPE;
    VDEPTCODE EMPLOYEE.DEPT_CODE%TYPE;
    VPHONE EMPLOYEE.PHONE%TYPE;
    VSAL_LEVEL EMPLOYEE.SAL_LEVEL%TYPE;
    
BEGIN
    
    SELECT EMP_NAME, EMP_NO, DEPT_CODE, PHONE, SAL_LEVEL
    INTO VEMPNAME, VEMP_NO, VDEPTCODE, VPHONE, VSAL_LEVEL
    FROM EMPLOYEE
    WHERE EMP_NO = '&사번';
    
    

END;
/


-- 선생님 풀이 
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE
BEGIN
    SELECT MAX(EMP_ID)
    INTO ID
    FROM EMPLOYEE
    
    INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, PHONE, JOB_CODE, SAL_LEVEL)
    VALUES(ID+1, '&이름', '&주민번호', '&전화번호', '&직책코드', '&급여코드');
    COMMIT;
END;
/
    
SELECT *
FROM EMPLOYEE;
    








