--제약 조건
-- NOT NULL : 데이터에 NULL을 차단 ( 얘는 무조건 DUMMY는 안돼!)
-- UNIQUE  : 중복값을 허용 안 함 (SET처럼)
-- PRIMARY : NOT NULL + UNIQUE
-- FOREIGN : 외래키 외부에 있는 키와 매칭되는 (외래키로 가져오는 키는 그 테이블의 PRIMARY키로 설정된 컬럼을 FOREIGN 키로 참조)
-- CHECK : 일정 부분에 대해서 필터링



-- 제약조건 확인  DESC USER_CONSTRAINTS;
--                       DESC USER_CONS_COLUMNS;




--컬럼이 변수니까 변수마다.

--NOT NULL(C)  : 특정 컬럼에 NULL을 허용하지 않는다.  -> 얘는 DEFAULT로 설정되어 있다. (아무 것도 설정하지 않으면 NULL허용)
-- 타입이라는게 있는데 NOT NULL은 (C)

-- UNIQUE(U) : 특정 컬럼에 중복 값을 허용하지 않는 것 -> NULL??중복이 되니??

-- PRIMARY KEY(P) : 데이터를 구분하는 컬럼의 지정하는 제약 조건으로 UNIQUE + NOT NULL이 자동으로 설정
--  > 인덱스가 부여 > 검색 속도 향상 이런 식으로
        --PRIMARY KEY는 보통 테이블에 1개를 지정
        -- 테이블에는 두 개 이상의 PRIMARY KEY가 존재할 수 없음 -> 최대 테이블 당 1개
        

-- FOREIGN KEY(R) : 특정 컬럼의 값은 다른 테이블 컬럼에 있는 값만 저장하게 하는 제약 조건. 지정된 다른 테이블의 컬럼은 유일해야함.



--CHECK(C) : 특정 컬럼의 값을 지정된 값만 저장할 수 있게 하는 것 특정 문구/ 범위를 설정







--DD를 이용해서 제약조건에 대한 정보를 확인하기

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMPLOYEE';


SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='EMPLOYEE';


-- 
--EMPLOYEE_PK	P	EMPLOYEE	
--SYS_C0016082	C	EMPLOYEE	"SAL_LEVEL" IS NOT NULL
--SYS_C0016083	C	EMPLOYEE	"JOB_CODE" IS NOT NULL
--SYS_C0016084	C	EMPLOYEE	"EMP_NO" IS NOT NULL
--SYS_C0016085	C	EMPLOYEE	"EMP_NAME" IS NOT NULL
--SYS_C0016086	C	EMPLOYEE	"EMP_ID" IS NOT NULL

--어디 걸려 있는거냐??/ 아...


SELECT K.CONSTRAINT_NAME, K.CONSTRAINT_TYPE, L.COLUMN_NAME
FROM USER_CONS_COLUMNS L  JOIN USER_CONSTRAINTS  K ON(K.CONSTRAINT_NAME= L.CONSTRAINT_NAME)
WHERE  L.TABLE_NAME='EMPLOYEE';

DESC USER_CONSTRAINTS;








-- 1. NOT NULL
-- NULL이 안들어가게 하는거

CREATE TABLE TBL_CONS_N(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(30),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

SELECT *
FROM TBL_CONS_N;
--각 컬럼은 기본적으로 NULL을 허용

SELECT *
FROM USER_CONS_COLUMNS 
WHERE TABLE_NAME = 'TBL_CONS_N';


INSERT INTO TBL_CONS_N VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL);

SELECT *
FROM TBL_CONS_N;

INSERT INTO TBL_CONS_N VALUES(1,'USER01', 'USER01', '김상현', '여', '010-1234-4445','SANG@SANG.COM');

-- NULL제약조건을 설정하면??
--제약조건을 설정하는 방법 1. 컬럼레벨, 2. 테이블 레벨
--1. 컬럼 레벨에서 설정하는 것은 : CREATE에서 컬럼 선언부 옆에 설정 내용을 작성
-- USER_NO NUMBER (제약조건)


--2. 테이블 레벨에서 설정 : 컬럼 선언이 다 끝나고 맨 끝에 작성하는 것 > CONSTRAINT라는 예약어를 통해서 작성을 한다. 
-- 테이블 끝에서 선언






--NOT NULL제약 조건은 컬럼 레벨에서만 선언이 가능하다. *************************
-- 컬럼명 타입(킬이)  NOT NULL,

DROP TABLE TBL_CONS_NN;
--테이블 명은 중복이 있으면 안된다.

CREATE TABLE TBL_CONS_NN(
    USER_NO NUMBER CONSTRAINT TBL_CONS_NN_USER_NO_NN NOT NULL, -- NOT NULL 선언 방법 & CONSTRAINT_NAME주는 방법 > 나중에 ALTER로 제약 조건 수정하는데 그 때 이름을 사용
    USER_ID VARCHAR2(20) NOT NULL, 
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    GENDER VARCHAR2(20),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
    
    );
    INSERT INTO TBL_CONS_NN VALUES(1,'USER2', 'USER2', '김태희', '남', '010-1234-5555', 'TEA@TEA.COM');
    INSERT INTO TBL_CONS_NN VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    SELECT * FROM TBL_CONS_NN;
    
--명령의 149 행에서 시작하는 중 오류 발생 -
--  INSERT INTO TBL_CONS_NN VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL)
--오류 보고 -
--ORA-01400: CANNOT INSERT NULL INTO ("SANGHYUN"."TBL_CONS_NN"."USER_NO")

    -- NOT NULL로 NULL이 들어가는 것을 막았다.
    
  -- 웹에서 필수 입력 항목 * 있잖아 거기에 값이 없으면 안돼니까 거기에 NOT NULL을 아마 선언했을 거라는 추측? 
  
  INSERT INTO TBL_CONS_NN VALUES(1,'USER2', 'USER2', '김태희', NULL, '010-1234-5555', 'TEA@TEA.COM');
  -- GENDER는 따로 NOT NULL없었으니까 가능
  
  
  
    -- UNIQUE : 중복값 허용 X 
    --컬럼단/ 테이블단 둘 다 사용 가능
    
    
    
DROP TABLE TBL_CONS_N;


CREATE TABLE TBL_CONS_N(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(30),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);


INSERT INTO TBL_CONS_N VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO TBL_CONS_N VALUES(1,'USER01', 'USER01', '김상현', '여', '010-1234-4445','SANG@SANG.COM');
INSERT INTO TBL_CONS_N VALUES (2, 'USER02', 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');
INSERT INTO TBL_CONS_N VALUES (2, 'USER02', 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');
--ID 중복 되는거 가능해요??

SELECT *
FROM TBL_CONS_N;





CREATE TABLE TBL_CONS_UQ(
    USER_NO NUMBER NOT NULL,
    USER_ID VARCHAR2(20) UNIQUE, --UNIQUE 제약 조건 설정
    USER_PW VARCHAR2(30),
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(30),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);


INSERT INTO TBL_CONS_UQ VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO TBL_CONS_UQ VALUES(1,'USER01', 'USER01', '김상현', '여', '010-1234-4445','SANG@SANG.COM');
INSERT INTO TBL_CONS_UQ VALUES (2, 'USER02', 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');
INSERT INTO TBL_CONS_UQ VALUES (2, 'USER02', 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');


SELECT *
FROM TBL_CONS_UQ;



--명령의 200 행에서 시작하는 중 오류 발생 -
--INSERT INTO TBL_CONS_UQ VALUES (2, 'USER02', 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM')
--오류 보고 -
--ORA-00001: UNIQUE CONSTRAINT (SANGHYUN.SYS_C0016151) VIOLATED


--데이터를 안정적으로 보장할 수 있지




-- 그렇다면 UNIQUE 제약 조건이 설정된 컬럼에 NULL처리는 어떻게 될까?
INSERT INTO TBL_CONS_UQ VALUES (3, NULL, 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');
--UNIQUE 인 상태에서 NULL 가능하다.
INSERT INTO TBL_CONS_UQ VALUES (4, NULL, 'USER02', '김태희', '남', '010-1234-1234', 'TEA@TEA.COM');
-- NULL은 값이 아니라서 중복 개념이 없다.  > NULL이 동등 비교가 되는 부분이에요? 아니죠??
-- UNIQUE가 설정되어 있는 NULL을 넣을지 아닌지는
-- 벤더 회사마다 다름

--UNIQUE 는 테이블 단에서도 선언이 가능하다. 
CREATE TABLE TBL_CONS_UQ2(
    USER_ID VARCHAR2(20),
    USER_PW VARCHAR2(20),
    
    --여기에 UNIQUE(컬럼명)
  CONSTRAINT USER_ID_UQ  UNIQUE(USER_ID)
    --CONSTRAINT_NAME은 위와 같이 (똑같이 하는데 
);

INSERT INTO TBL_CONS_UQ2 VALUES ('USE1','USE1');
INSERT INTO TBL_CONS_UQ2 VALUES ('USE1','USE2');
--명령의 238 행에서 시작하는 중 오류 발생 -
--INSERT INTO TBL_CONS_UQ2 VALUES ('USE1','USE2')
--오류 보고 -
--ORA-00001: UNIQUE CONSTRAINT (SANGHYUN.SYS_C0016155) VIOLATED
--이렇게도 가능하다.

DROP TABLE TBL_CONS_UQ2;

-- 한 개 이상의 컬럼에 UNIQUE 설정하기

--얘는 테이블 단에서 한다.


CREATE TABLE TBL_CONS_UQ3(
    USER_NO NUMBER ,
    USER_ID VARCHAR2(20) , --UNIQUE 제약 조건 설정
    USER_PW VARCHAR2(30),
 CONSTRAINT COM_NO_ID_UQ UNIQUE(USER_NO, USER_ID)
 -- 이러면 USER_NO랑 USER_ID를 DISTINCT처럼 하나로 봐서 UNIQUE가 원하는대로 안된다.
 
 --따로 걸고 싶으면
 -- UNIQUE(USER_NO),
 -- UNIQUE(USER_ID)  
 --이렇게 하려면 차라리 컬럼 레벨에서 하는게 나을 수도 있지!
 
);



INSERT INTO TBL_CONS_UQ3 VALUES(1,'B','B');
INSERT INTO TBL_CONS_UQ3 VALUES(1,'A','A');
INSERT INTO TBL_CONS_UQ3 VALUES(2,'B','B');

SELECT *
FROM TBL_CONS_UQ3;


--PRIMARY KEY : 기본키
-- 중복 값이 없고 NULL이 없는 컬럼에 설계자가 지정하는 제약조건
-- PRIMARY  KEY가 설정이 되면 UNIQUE + NOT NULL이 같이 설정됨
-- 한 개 테이블 당 한 개만 가능하다(최대)
-- 테이블 단/ 컬럼 단에서 설정이 가능하다.

--컬럼 단
CREATE TABLE TBL_CONS_PK(
        USR_NO NUMBER PRIMARY KEY,  --기본키 목적으로 이렇게 집어 넣을 수 이다.
        USR_ID VARCHAR2(20) UNIQUE,
        USR_PW VARCHAR2(20) NOT NULL, 
        USR_NAME VARCHAR2(20) NOT NULL
        
);

INSERT INTO TBL_CONS_PK VALUES (1,'USER01', 'USER01', '김예진');
INSERT INTO TBL_CONS_PK VALUES (2,'USER02', 'USER02', '이진주');
INSERT INTO TBL_CONS_PK VALUES (2,'USER03', 'USER03', '장혜린');

--명령의 284 행에서 시작하는 중 오류 발생 -
--INSERT INTO TBL_CONS_PK VALUES (2,'USER03', 'USER0', '장혜린')
--오류 보고 -
--ORA-00001: UNIQUE CONSTRAINT (SANGHYUN.SYS_C0016160) VIOLATED

INSERT INTO TBL_CONS_PK VALUES (NULL,'USER03', 'USER03', '장혜린');

--명령의 291 행에서 시작하는 중 오류 발생 -
I--NSERT INTO TBL_CONS_PK VALUES (NULL,'USER03', 'USER0', '장혜린')
--오류 보고 -
--ORA-01400: CANNOT INSERT NULL INTO ("SANGHYUN"."TBL_CONS_PK"."USR_NO")

--> PRIMARY KEY = UNIQUE + NOT NULL


--PK가 있어야하는 이유??
INSERT INTO TBL_CONS_PK VALUES (3,'USER03', 'USER03', '장혜린');
INSERT INTO TBL_CONS_PK VALUES (4,'USER04', 'USER04', '장혜린');

SELECT *
FROM TBL_CONS_PK WHERE USR_NAME = '장혜린';

--4	USER04	USER04	장혜린
--3	USER03	USER03	장혜린

--이런 상황에서 둘 중 하나를 구분해 낼 수 있는 방법이??


SELECT *
FROM TBL_CONS_PK WHERE USR_NAME = '장혜린' AND USR_NO = 3;

--3	USER03	USER03	장혜린  > 이렇게
--PK는 유일하게 떨어지는 단 하나의 값




SELECT * FROM TBL_CONS_PK;


CREATE TABLE TBL_CONS_PK2(
        USR_NO NUMBER,
        USR_ID VARCHAR2(20),
        USR_PW VARCHAR2(20),
        USR_NAME VARCHAR2(20),
        
        
        CONSTRAINT USR_NO_PK PRIMARY KEY(USR_NO)
);


INSERT INTO TBL_CONS_PK2 VALUES (1,'USER01', 'USER01', '김예진');
INSERT INTO TBL_CONS_PK2 VALUES (2,'USER02', 'USER02', '이진주');
INSERT INTO TBL_CONS_PK2 VALUES (2,'USER03', 'USER03', '장혜린');

SELECT *
FROM TBL_CONS_PK2;


--PK설정 시 한 개 이상의 컬럼도 가능 --> 복합키 
-- 그룹으로 묶어서 하나의 구분자로 사용
-- 복합키 어따 써??? 장바구니 같은 곳 > USER_NO / PRODUCT_NO를 통으로 PK로 복합키로 쓴다.

-- 예시 다른 분꺼 참조해야함.. 아직 잘 이해가 안가...******************************************************************************************************


-- 장바구니 테이블
 DROP TABLE TBL_ORDER;
 
CREATE TABLE TBL_ORDER (
    PRODUCT_NO NUMBER,   --얘들이 다른 테이블에 있겠지 FOREIGN으로 묶어서.. 어쩍..와 ㅋㅋㅋ
    USR_NO NUMBER, 
    ORDER_DATE DATE,
    ORDER_NO NUMBER NOT NULL,
    
    
    PRIMARY KEY(PRODUCT_NO, USR_NO, ORDER_DATE)
    

);
INSERT INTO TBL_ORDER VALUES ('11','11', '21/02/26',1);
INSERT INTO TBL_ORDER VALUES ('11','11', '21/02/26',1);


--명령의 375 행에서 시작하는 중 오류 발생 -
--INSERT INTO TBL_ORDER VALUES ('11','11', '21/02/26',1)
--오류 보고 -
--ORA-00001: UNIQUE CONSTRAINT (SANGHYUN.SYS_C0016164) VIOLATED


INSERT INTO TBL_ORDER VALUES ('11','22', '21/02/26',1);
INSERT INTO TBL_ORDER VALUES ('11',NULL, '21/02/26',1);


--명령의 386 행에서 시작하는 중 오류 발생 -
--INSERT INTO TBL_ORDER VALUES ('11',NULL, '21/02/26',1)
--오류 보고 -
--ORA-01400: CANNOT INSERT NULL INTO ("SANGHYUN"."TBL_ORDER"."USR_NO")

-- NOT NULL은 컬럼당으로 잡혀 있어  테이블단에서 안되는 이유가 있죠?


SELECT *
FROM TBL_ORDER;



--FOREIGN KEY
-- 다른 테이블의 컬럼을 가져와 쓰는 것 
-- 마치 부모, 자식 관계처럼 설정됨
-- 참조 되는 테이블/ 참조 하는 테이블 : 부모/ 자식


CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) NOT NULL UNIQUE, --이렇게 두 개를 쓸 수 있어 쉼표 없이 이래야 후보키가 되는거니까
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    
    GENDER VARCHAR2(10), 
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)

);

INSERT INTO SHOP_MEMBER VALUES (1,'USR01', '1234','홍길동','남','01021213232', 'HONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (2,'USR02', '1234','홍동길','여','01011111111', 'DONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (3,'USR03', '1234','길홍동','남','01022113232', 'GIL@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (4,'USR04', '1234','동길홍','여','01021214332', 'HONGDONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (5,'USR05', '1234','길동홍','남','01021218732', 'HONGGIL@NAVER.COM');


SELECT *
FROM SHOP_MEMBER;



CREATE TABLE SHOP_BUY(
    BUY_NUM NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) REFERENCES SHOP_MEMBER(USER_ID) NOT NULL , --SHOP_MEMBER TABLE의 데이터를 가져오자.......
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE
    
);

--REFERENCES SHOP_MEMBER(USER_ID) 이렇게!
-- MEMBER랑 SHOPBUY랑 연관이 있고, USER_ID를 매개로 이어져 있음 > FOREIGN KEY로 서로 이어준다구요

SELECT * FROM SHOP_BUY;
INSERT INTO SHOP_BUY VALUES(1,'USR04','술',SYSDATE);
--됩니다. 

INSERT INTO SHOP_BUY VALUES(1,'SANG','육포',SYSDATE);
--명령의 445 행에서 시작하는 중 오류 발생 -
--INSERT INTO SHOP_BUY VALUES(1,'SANG','육포',SYSDATE)
--오류 보고 -
--ORA-00001: UNIQUE CONSTRAINT (SANGHYUN.SYS_C0016169) VIOLATED - PARENT KEY NOT FOUND
--USR_ID를 외부 테이블에서 체크하는데 없으니까 에러

INSERT INTO SHOP_BUY VALUES(2,NULL, '육포', SYSDATE);
--들어가네??????
-- 2	 NULL	육포	2021/02/26  > 이딴거 막으려면 NOT NULL도

--NOT NULL 떄리면 안들어감




DROP TABLE SHOP_MEMBER;
DROP TABLE SHOP_BUY;


---------------------------------------------
CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) NOT NULL UNIQUE, --이렇게 두 개를 쓸 수 있어 쉼표 없이 이래야 후보키가 되는거니까
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    
    GENDER VARCHAR2(10), 
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)

);

-- 이렇게 외래 키에 UNIQUE지우고 참조하려면


--오류 보고 -
--ORA-02270: NO MATCHING UNIQUE OR PRIMARY KEY FOR THIS COLUMN-LIST
--02270. 00000 -  "NO MATCHING UNIQUE OR PRIMARY KEY FOR THIS COLUMN-LIST"
--*CAUSE:    A REFERENCES CLAUSE IN A CREATE/ALTER TABLE STATEMENT
--         GIVES A COLUMN-LIST FOR WHICH THERE IS NO MATCHING UNIQUE OR PRIMARY
 --          KEY CONSTRAINT IN THE REFERENCED TABLE.
--*ACTION:   FIND THE CORRECT COLUMN NAMES USING THE ALL_CONS_COLUMNS
--           CATALOG VIEW

--외래키는 UNIQUE가 안되면 저얼대로 외래키로 쓸 수 없다.



-- 다시 원래대로 돌아와서
-- 외래키를 테이블 단에서


CREATE TABLE SHOP_BUY(
    BUY_NUM NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) NOT NULL,--REFERENCES SHOP_MEMBER(USER_ID) NOT NULL , --SHOP_MEMBER TABLE의 데이터를 가져오자.......
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE,
    
    CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID)
    
);

--외래키로 지정된 컬럼은 함부로 지우지 못하게 설정되어있다.
-- 자식테이블(참조해서 가져오는 애)이 부모테이블 컬럼의 값을 가지고 있으면 부모테이블에서 그 값은 삭제가 불가능하다. 

--지울 때 사용
DELETE FROM SHOP_MEMBER WHERE USER_ID = 'USR04';

--명령의 514 행에서 시작하는 중 오류 발생 -
--DELETE FROM SHOP_MEMBER WHERE USER_ID = 'USR04'
--오류 보고 -
--ORA-02292: INTEGRITY CONSTRAINT (SANGHYUN.USER_ID_FK) VIOLATED - CHILD RECORD FOUND

--CHILD에 있어서 CHILD에서 뭘 참조하란 소리냐.. 못하지 그래서 ㅋㅋㅋ



DELETE FROM SHOP_MEMBER WHERE USER_ID = 'USR01';
-- 1 행 이(가) 삭제되었습니다.

--외래키를 사용하고 있는 것만 못지운다. 안쓰면 (자식에서) 지울 수 있다.





-- FOREIGN KEY (외래키) 설정 시 컬럼에 대한 삭제 옵션을 설정할 수 있다. 
-- ON DELETE SET NULL                                                                          / ON DELETE CASCADE(종속)
-- NULL로 바꾼다. => 외래키 삭제와 운명을 같이 할 필요가 없는 경우  / 종속된 값을 통째로 다 들어낸다.  => 데이터의 종속 관계를 이용해서 정리할 때 사용

-- DB종류(관계형 DB같이..)


CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20)  UNIQUE, --이렇게 두 개를 쓸 수 있어 쉼표 없이 이래야 후보키가 되는거니까
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    
    GENDER VARCHAR2(10), 
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)

);


CREATE TABLE SHOP_BUY(
    BUY_NUM NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) ,--REFERENCES SHOP_MEMBER(USER_ID) NOT NULL , --SHOP_MEMBER TABLE의 데이터를 가져오자.......
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE,
    
    CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE SET NULL
    
);

-- 외래키 뒤 쪽에 그냥 쓰면 됨 
DROP TABLE SHOP_BUY;
DROP TABLE SHOP_MEMBER;


INSERT INTO SHOP_MEMBER VALUES (1,'USR01', '1234','홍길동','남','01021213232', 'HONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (2,'USR02', '1234','홍동길','여','01011111111', 'DONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (3,'USR03', '1234','길홍동','남','01022113232', 'GIL@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (4,'USR04', '1234','동길홍','여','01021214332', 'HONGDONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (5,'USR05', '1234','길동홍','남','01021218732', 'HONGGIL@NAVER.COM');

SELECT *
FROM SHOP_MEMBER;

INSERT INTO SHOP_BUY VALUES(2, 'USR02','커피', SYSDATE);


SELECT *
FROM SHOP_BUY;


DELETE FROM SHOP_MEMBER WHERE USER_ID = 'USR02';







-- 



CREATE TABLE SHOP_MEMBER(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20)  UNIQUE, --이렇게 두 개를 쓸 수 있어 쉼표 없이 이래야 후보키가 되는거니까
    USER_PW VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(20),
    
    GENDER VARCHAR2(10), 
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)

);


CREATE TABLE SHOP_BUY(
    BUY_NUM NUMBER PRIMARY KEY,
    USER_ID VARCHAR2(20) ,--REFERENCES SHOP_MEMBER(USER_ID) NOT NULL , --SHOP_MEMBER TABLE의 데이터를 가져오자.......
    PRODUCT_NAME VARCHAR2(50),
    REG_DATE DATE,
    
    CONSTRAINT USER_ID_FK FOREIGN KEY(USER_ID) REFERENCES SHOP_MEMBER(USER_ID) ON DELETE CASCADE
    
);

-- 외래키 뒤 쪽에 그냥 쓰면 됨 
DROP TABLE SHOP_BUY;
DROP TABLE SHOP_MEMBER;


INSERT INTO SHOP_MEMBER VALUES (1,'USR01', '1234','홍길동','남','01021213232', 'HONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (2,'USR02', '1234','홍동길','여','01011111111', 'DONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (3,'USR03', '1234','길홍동','남','01022113232', 'GIL@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (4,'USR04', '1234','동길홍','여','01021214332', 'HONGDONG@NAVER.COM');
INSERT INTO SHOP_MEMBER VALUES (5,'USR05', '1234','길동홍','남','01021218732', 'HONGGIL@NAVER.COM');

SELECT *
FROM SHOP_MEMBER;

INSERT INTO SHOP_BUY VALUES(2, 'USR02','커피', SYSDATE);


SELECT *
FROM SHOP_BUY;


DELETE FROM SHOP_MEMBER WHERE USER_ID = 'USR02';

-- 이러면 부모가 삭제되면 자식도 같이 종속되어 사라진다. 






-------------------------------------------------------------------으아앙! 크아아앙
-- 다음에 할 건? CHECK 제약조건
--FOREIGN키랑 비슷한데! FOREIGN 테이블에 들어간 값을 중심으로 하잖아
--CHECK는 들어갈 수 있는 값을 미리 정해 놓은거랑 같다. 

CREATE TABLE USER_CHECK(
    USER_NO NUMBER,
    USER_NAME VARCHAR2(20),
    GENDER VARCHAR2(10) CHECK(GENDER IN ('남', '여')), --CHECK(비교연산 안이 TRUE이면) GENDER에 들어갈 수 있음
    age number,
    
    check(age>19 and user_no >0)
    
    
);

INSERT INTO USER_CHECK VALUES (1, '양호준', 'M');


--명령의 661 행에서 시작하는 중 오류 발생 -
--INSERT INTO USER_CHECK VALUES (1, '양호준', 'M')
--오류 보고 -
--ORA-02290: CHECK CONSTRAINT (SANGHYUN.SYS_C0016215) VIOLATED


INSERT INTO USER_CHECK VALUES (1, '양호준', '남',19);
SELECT *
FROM USER_CHECK;

drop table user_check;
--check 계속 합시다!!!!!!


INSERT INTO USER_CHECK VALUES (1, '양호준', '남',19);
INSERT INTO USER_CHECK VALUES (0, '양호준', '남',20);

-- 안 들어가 이렇게 check로 못 박아두면



create table test_member(
    member_code number primary Key, 
    member_id varchar2(20) unique,
    member_pwd char(20) not null,
    member_name nchar(10), 
    member_adder char(50) not null,
    gender varchar2(5) check( gender in ('남', '여')),
    phone varchar2 (20) not null
);


comment on column test_member.member_code is '회원전용코드';
comment on column test_member.member_id is '회원 아이디';
comment on column test_member.member_pwd is '회원 비밀번호';
comment on column test_member.member_name is '회원 이름';
comment on column test_member.member_adder is '회원 거주지';
comment on column test_member.gender is '성별';
comment on column test_member.phone is '회원 연락처';

select *
from test_member;


--시험
--데이터베이스의 특징 (dbms특징 ) 동시성, 무결성, 계속적인 변화 공유가 되고 내용에 의한 참조
--sql구문을 봤을 때 뭐가 있는지 
--타입 (숫자/문자/날짜) 날짜 타입
--평균구하는 select문
--년수/ 나이/ 
-- 개월수로 나눠서하는 방법?
--합계/ 평균
--그룹으로 묶었을 때 조건문 작성
--민번 처리(별로)
--date를 to_char() 로 바꾸는 
 --select 문을 실행하는 순서  (from/ where/ group by/ having/ select /order by)
 --계산식(산술연산 계산)
 --조건에 따라서 select문에서 분기처리(decode/ case)_
 -- 테이블을 보고 정렬하는데 > 정렬하는데 문제가 있어서 그걸 inline으로 > group by로 묶었을 때 컬럼 호출 할 때 문제 e.*
 -- sql구문을 보고 문제를 찾아내는 것(조건을 잘 읽고 문제를 찾아내는 문제) > group by로 묶여 있을 때 조건을 작성하는 방법은??????????????????????????
