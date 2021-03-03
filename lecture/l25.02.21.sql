--사원명, 부서명, 직책명, 급여, 보너스
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY, BONUS, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별"
FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
                        JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE = 'D6';



SELECT * 
FROM (
            SELECT EMP_NAME AS "사원명", DEPT_TITLE AS "부서명", JOB_NAME AS "직책명" , SALARY AS "월급", BONUS AS "보너스", DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS "성별"
            FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
                                     JOIN JOB USING(JOB_CODE)
            WHERE DEPT_CODE IN ('D5','D6')                         
            
        )
WHERE 사원명 = '유재식' ;


--FROM절에서 불러서 WHERE에서 필터링하고 SELECT으로 쏴주기 때문에 바뀌는 그대로 써야한다. WHERE EMP_NAME = '유재식'; 은 안나온다. 
 
 
 
 --TOP-N분석
 -- 급여를 가장 많이 받는 3명, 댓글이 가장 많은 10개 -> 이런거 구할 때
 -- TOP_N으로 ROW의 순서를 매긴다.  > 이 순서를 가지고 페이징처리를 한다. 
 SELECT *
 FROM EMPLOYEE;
 
 -- 1등부터 3등까지 가져오세요... 어떻게?? 그리고 뭘 기준으로??? 순서란게 있긴해??
 -- 2가지 방법
 
 -- 1. ROWNUM : 기본 오라클이 제공하는 컬럼 -> 모든 테이블에 자동으로 설정된다! ROW의 순서   >  METADATA를 갖고 있다고 생각하는게 맞나?
 -- 2. 함수를 이용해서 : 오라클이 제공하는 TOPN이라는 함수를 이용해서 가져온다. 
 
 
 SELECT ROWNUM, E.* 
 FROM EMPLOYEE E
 ORDER BY E.EMP_NAME;
 
 --ROWnum이 보니까 고정숫자네? 기본키를 기준으로 잡나봐???
 
 SELECT ROWNUM, E.*
 FROM EMPLOYEE E
 WHERE ROWNUM BETWEEN 1 AND 10;
 --ROWNUM을 이용할 때 문제가 있다. 
 
 -- 급여를 가장 많이 받는 3명의 사원을 조회하시오
 -- 이름/급여
 -----------------------------------------------------------------------------------------------------
 SELECT    S.*
 
 FROM (
                SELECT  EMP_NAME,  SALARY 
                FROM EMPLOYEE 
                ORDER BY SALARY DESC
            ) S        
 
 WHERE ROWNUM BETWEEN 1 AND 3;
 
 SELECT EMP_NAME, SALARY
 FROM EMPLOYEE
 ORDER BY SALARY DESC;
 -----------------------------------------------------------------------------------------------------
 -- SELECT에서 FROM절을 가져오고 WHERE을 하는데 FROM절에 대한 기본적인 데이터를 가져올 때 ROWNUM을 부여
 
 
 --ROWNUM을 이용해서 순서를 적용할 때는 INLINEVIEW를 이용함
 
 SELECT ROWNUM, E. *
 
 FROM ( SELECT ROWNUM, EMP_NAME, SALARY
            FROM EMPLOYEE ORDER BY SALARY DESC
        ) E;
            
            -- 그니까 애초에 테이블 내부(INLINE)에서 SORT를 하고 그 순서대로 SELECT 를 할 때 다시 그 순서대로 ROWNUM을 부여한다.
            -- 부여 순서가 그러니까 테이블을 읽고 ROWNUM을 부여한다.
            


--ROWNUM활용
--D5부서의 연봉 많이 받는 순서로 3

SELECT E.EMP_NAME AS "이름", E.DEPT_TITLE AS "부서명"  ,E. SALARY*12 AS "연봉"

FROM (  

            SELECT EMP_NAME, DEPT_TITLE,  SALARY
            FROM EMPLOYEE 
            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
            ORDER BY 3 DESC
            
        ) E;
 
 
 --부서명   
  
  SELECT E.EMP_NAME AS "이름", E.DEPT_TITLE AS "부서명"  ,E. SALARY*12 AS "연봉"
  
FROM (  
            SELECT EMP_NAME, DEPT_TITLE,  SALARY
            FROM EMPLOYEE 
            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
            WHERE DEPT_CODE = 'D2'
            ORDER BY 2
            
        ) E;          
 
            
 
 -----------------------------------------------✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰페이징 처리할 때 사용하니까 꼭 기억
 
 --사원의 급여를 4번째에서 8번째 높게 받는 사원을 조회
 --사원명, 급여
 SELECT  A.EMP_NAME, A.SALARY
 
 FROM(
                 SELECT ROWNUM AS "RNUM", E.*
                 
                 FROM ( 
                                SELECT EMP_NAME, SALARY
                                FROM EMPLOYEE
                                ORDER BY 2 DESC
                        )E
                
        )A
        
WHERE RNUM BETWEEN 4 AND 8;        
        
--1번부터 시작하면 상관은 없어.. 근데 얘는 중간에서 캐치하는거라 (ROWNUM을 부여하는 시점 때문에)

-----------------------------------------------✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰페이징 처리할 때 사용하니까 꼭 기억




-- 2. 함수를 이용한다. 
--오라클에서 RANK() OVER라는 함수를 제공
-- RANK() OVER(정렬 기준)
SELECT E.*

FROM (
                SELECT EMP_NAME, SALARY, 
                            RANK() OVER (ORDER BY SALARY DESC) AS "순위"
                
                FROM  EMPLOYEE
                
           )E     
           
WHERE  E.순위 BETWEEN 1 AND 3;



------------------ RANK() OVER에 추가적인건데 OVER(여기에) 다른 짓을 또 할수 있어요
SELECT E.*

FROM (
                SELECT EMP_NAME, SALARY, 
                            RANK() OVER (ORDER BY SALARY DESC) AS "순위",
                            RANK() OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC) AS "부서별 순위"
                
                FROM  EMPLOYEE
                
           )E     
           
WHERE  E.순위 BETWEEN 1 AND 3;


-------------------DENSE_RANK() OVER
-- RANK()OVER와의 차이?  > 중복되는 순위가 있을 때 번 호 부여해서 차이가 남
-- 14위 15위 15위  16위? 17위? 
-- DENSE RANK OVER는 16을 쓰고
-- RANK OVER 는 17로 간다.


SELECT RANK() OVER (ORDER BY SALARY) AS "순위", 
        EMP_NAME, SALARY,
        DENSE_RANK() OVER( ORDER BY SALARY) AS "DENSE_순위"
FROM EMPLOYEE;    


--       RANK() OVER            DENSE_RANK()OVER
--4	전형돈	2000000        4	전형돈	2000000
--4	윤은해	2000000        4	윤은해	2000000
--6	하이유	2200000        5	하이유	2200000


--RANK()OVER는 윈도우 함수 WHERE절에 쓸 수 없다. 






-------------여기까지 RESULTSET에서 순서를 부여하는 방법을 알아 봤따. 



-- 계층형 쿼리 -> 댓글 조회해서 가져올 때 사용한다. ✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰✰

-- A 
--  ㄴ-A
--  ㄴ-B
--  B
--  ㄴ-C
--  ㄴ-D

--이런식 > 수직적 관계를 표현할 떄 사용 > 조직도, 메뉴, 답변형 게시판(댓글)

SELECT LEVEL, EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE
        START WITH EMP_ID = 200
        CONNECT BY PRIOR EMP_ID = MANAGER_ID;
        
        
        
SELECT LEVEL, EMP_NAME
FROM EMPLOYEE
    START WITH EMP_ID =200
    CONNECT BY PRIOR EMP_ID = MANAGER_ID;

SELECT LEVEL, EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE
        START WITH EMP_ID = 200  --시작 기준 (ROOT) LEVEL컬럼을 부여하는 기준
        CONNECT BY PRIOR EMP_ID = MANAGER_ID;  -- 관계 연결 기준
--ORDER BY LEVEL;        

--1	200	선동일	

--        2	201	송종기	200
--               ㄴ     3	202	노옹철	201

--        2	204	유재식	200
--               ㄴ 3	203	송은희	204
--               ㄴ 3	205	정중하	204

--        2	207	하이유	200
--          ㄴ   3	206	박나라	207
--          ㄴ   3	208	김해술	207
--          ㄴ   3	209	심봉선	207
--          ㄴ   3	210	윤은해	207

--        2	211	전형돈	200
--           ㄴ  3	212	장쯔위	211

--        2	214	방명수	200
--           ㄴ   3	216	차태연	214


--LEVEL : 계층의 정보 

SELECT LPAD( '  ' , (LEVEL - 1)*5, '  ' )||EMP_NAME||NVL2(MANAGER_ID,'('||MANAGER_ID||')','') AS 조직도
FROM EMPLOYEE
        START WITH MANAGER_ID IS NULL
        CONNECT BY PRIOR EMP_ID =MANAGER_ID;
        
        
        --SELECT는 끝...
        -------------------------------------------------------------------------------------------------------------------------------------
        
        -- DDL(데이터 정의 언어 / DATA DEFINITION LANGUAGE) : 테이블에 관한 것에 집중할 예정
        --1. 테이블을 생성 (CREATE는 테이블만 생성하는 것이 아니라 ORACLE에서 관리하고 있는 
                    --   OBJECT > TABLE, VIEW, SEQUENCE, INDEX, TRIGGER, SYNONYM, USER만들 때도 해당 정의어를 사용)
                
          --2.       
                





-- 1. CREATE 오브젝트를 만드는 명령어  : CREATE (생성할 오브젝트 명) (이름) '(컬럼명(변수) / 자료형/ (크기))' -> 꼭 중괄호
--                                                                                                                                                                  ㄴ 공간 자체를 내가 유동적으로 만들 수 있다. 정해진 범위 내에서


--오라클 데이터형
--**문자형
-- CHAR(크기 )  : 고정 길이 문자 데이터 (크기)만큼 공간을 확보 2000BYTE
-- VARCHAR2(크기) : 가변길이 문자 데이터 4000 BYTE (크기)만큼 공간을 확보하되, 사용하지 않으면 반환 4000BYTE

-- CHAR(10), VARCHAR(10) 에 '유병승'을 넣으면 CHAR는 크기 그대로 남은 바이트는 그냥 노는 것임/ VARCHAR는 (크기에 맞춰서 반환)

CREATE TABLE TBL_DATA_STR(
    A CHAR(6),
    B VARCHAR2(6),     --> 문자열 사용에 대한 권장 자료형 > 길이는 어떻게 전하나?? 들어올 도메인을 기준으로 잡는다. 
    C NCHAR(6),
    D NVARCHAR2(6)
);
--N이 들어가면 한 글자 당 2 바이트/ NCHAR(6)에서 6은 글자수

SELECT * FROM TBL_DATA_STR;

drop table tbl_data_str;
INSERT INTO TBL_DATA_STR VALUES('ABC','ACB', 'ABC','ABC');
INSERT INTO TBL_DATA_STR VALUES ('가나', '가', '가나다','가나');
INSERT INTO TBL_DATA_STR VALUES ('가', '가', '가','가나');


SELECT LENGTHB(A), LENGTHB(B), LENGTHB(C), LENGTHB(D),
                LENGTH(A), LENGTH(B), LENGTH(C), LENGTH(D)
FROM TBL_DATA_STR;


-- NCHAR
-- NVARCHAR2



CREATE TABLE PERSON(
 NAME VARCHAR2(15) -- 여기서 글자 크기는 가장 긴 것으로 상정해서 >  이 길이를 기준으로...
);


--VARCHAR2의 4000바이트가 부족할 수도 있기에 LONG이라는 녀석을 쓸 수 있다. -> 2GB까지 사용 가능 > 그러나 오라클에서 사용하지 말라고 하긴하네

-- CLOB = 4GB * 문자열 기링가 크면 이것을 사용
                                                                                                                                                                



--**숫자형
-- NUMBER : 숫자데이터 (40자리) : 실수/정수 둘 다 NUMBER 사용
-- NUMBER (길이) : 숫자데이터로 길이 지정 가능 (최대 38자리)

--NUMBER(PRECISION, SCALE)
-- PRECISION :표현할 수 있는 전체 자료수 (1~38)
--SCALE : 소수점 이하 자리수 (-84~127)
--물론 둘 다 생략 가능(알아서 할당해서 쓴다. )

CREATE TABLE TBL_DATA_NUM(
        A NUMBER,
        B NUMBER(5),  -- 숫자 자리수
        C NUMBER(5,1),  -- 숫자 자리수, 소수점 자리
        D NUMBER(5,-2) -- 숫자 자리수 , 소수점 자리 ( -2칸  정수 범위로 값을 자름 EG 1234.567 -> 1200)
        --최적화를 해야한다면 쓰겠지만 그게 아니라면 그냥  NUMBER 로 쓴다. 
        -- 일단 정수 기준으로 하고, PRECISION/   소수로 넘어가면 자르거나한다. 
);        

INSERT INTO TBL_DATA_NUM  VALUES (1234.567,1234.567,1234.567,1234.567);


SELECT *
FROM TBL_DATA_NUM;


--**날짜형
--DATE

CREATE TABLE TBL_DATA_DATE(
    BIRTHDATE DATE --얘는 옵션이 따로 없음

);

SELECT *
FROM TBL_DATA_DATE;

INSERT INTO TBL_DATA_DATE VALUES('93/07/10');
--저 형식만 맞춰주면 문자라도 형변환 시켜서 들어간다.
INSERT INTO TBL_DATA_DATE VALUES (TO_DATE(199307100945, 'YYYY/MM/DD HH:MI'));

--**데이터형
--BLOB : 실제 파일 자체 > 서버에 저장 / DB에는 저장 X 
--CLOB : 문자

--시/분/초 : TIMESTAMP


--컬럼에 COMMENT 달기
-->별칭을 부여
--COMMNET ON COLUMN  테이블 명. 컬럼명 IS 주석 내용


--기본 테이블 생성하기
-- 테이블을 생성을 할 때에는 CREATE명령어를 이용한다.
-- CREATE TABLE 테이블 명 (컬럼 선언....>> 컬럼명 / (자료형), 컬럼명 / (자료형));

CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(100),
    MEMBER_PWD VARCHAR2 (100),
    MEMBER_NAME VARCHAR2 (20)
    
);

SELECT *
FROM MEMBER;

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';

--COMMENT확인하기

SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'MEMBER';  --(여기서 테이블 이름 대문자로 써야하네)
COMMENT ON TABLE MEMBER IS '회원정보관리';

select *
from user_tab_comments;


--DBMS의 가장 큰 장점 > 데이터 무결성을 지킬 수 있다. 
-- 제약 조건 : 테이블 작성 시 각 컬럼에 기록될 데이터에 대해서 제약 조건을 설정할 수 있는데, 이는 데이터 무결성 보장을 주 목적으로 한다.
                -- 입력 데이터에 문제가 없는지에 대한 검사와 데이터 수정/삭쩨 가능 여부 검사 등을 위해서 사용
                
                --1.NOT NULL : null을 절대 못 넣게 하는 
                
                --2. UNIQUE   : 유일성 > 중복된 값을 허용하지 않음 > 고유키
                
                --3. PRIMARY KEY : NULL과 중복값을 허용하지 않음 > 기본키로 사용하려고 ( UNIQUE + NULL = 기본키)  : ROW를 구분하는 키 > 당연히 NULL은 안 됨  >> 내가 컬럼에다 지정한다. 
                                                --기본키로 지정하면 자동으로 not null/ unique가 됨
                
                --4. FOREIGN KEY : 참조되는 외부의 다른 테이블의 컬럼 값이 존재하면 허용 > 외래키  
                
                --5. CHECK : 저장 가능한 데이터 값의 범위나 조건을 지정하여 설정한 값만 허용 > 내가 그 컬럼에 들어갈 수 있는 값에 제한을 둔다. > 내가 정해둔 대로만 입력할 수 있게 선언
                
                -- 한 개 컬럼에 여러 개 적용 가능 (상반되지 않는 선에서)
                
                --테이블을 지우려면
                
                DROP TABLE TBL_DATA_DATE;
                DROP TABLE TBL_DATA_NUM;
                DROP TABLE TBL_xDATA_STR;
                