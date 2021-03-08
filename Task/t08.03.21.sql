--1
SELECT *
FROM TB_BOOK;

SELECT (SELECT COUNT(*) FROM TB_BOOK) AS "BOOK COUNT" , (SELECT COUNT(*) FROM TB_WRITER) AS "WRITER COUNT",
        (SELECT COUNT(*) FROM TB_PUBLISHER)  AS "PUBLISHER COUNT", (SELECT COUNT(*) FROM TB_BOOK_AUTHOR) AS "AUTHOR COUNT" 
FROM DUAL;
                    
                    
--2
DESC TB_BOOK;

SELECT *
FROM TAB
WHERE TNAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR', 'TB_PUBLISHER', 'TB_WRITER');

SELECT * FROM  COL WHERE  TNAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR', 'TB_PUBLISHER', 'TB_WRITER');


--3
SELECT  BOOK_NO, BOOK_NM
FROM TB_BOOK
WHERE BOOK_NM LIKE( '_______________________%');

--4
SELECT *
FROM (
            SELECT *
            FROM TB_WRITER
            WHERE MOBILE_NO LIKE ('019%') AND WRITER_NM LIKE('김%')
            ORDER BY WRITER_NM
        )
WHERE ROWNUM =1;        

--5
SELECT  COUNT (*) ||'명'AS "저작형태가 옮김"
FROM  TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '옮김';


--6
SELECT COMPOSE_TYPE, STOCK_QTY
FROM TB_BOOK    
                JOIN TB_BOOK_AUTHOR USING (BOOK_NO  )
WHERE    STOCK_QTY >=300;

SELECT COMPOSE_TYPE, COUNT(COMPOSE_TYPE)
FROM TB_BOOK
                    JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
WHERE COMPOSE_TYPE IS NOT NULL AND COMPOSE_TYPE IN ('지음', '옮김')
GROUP BY COMPOSE_TYPE;


--7
SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
FROM TB_BOOK
ORDER BY ISSUE_DATE DESC;


--8

SELECT *
FROM (
            SELECT WRITER_NM AS "작가 이름", COUNT(BOOK_NO) AS "권수"
            FROM TB_WRITER 
                                JOIN TB_BOOK_AUTHOR USING (WRITER_NO)
            GROUP BY WRITER_NM
            ORDER BY COUNT(BOOK_NO) DESC
        ) 
WHERE ROWNUM<=3;        


--9 
SELECT *
FROM TB_WRITER;

UPDATE TB_WRITER W
SET REGIST_DATE = (
                            SELECT  MIN(ISSUE_DATE)
                             FROM TB_BOOK B
                                JOIN TB_BOOK_AUTHOR A USING (BOOK_NO)
                             WHERE A.WRITER_NO = W.WRITER_NO
                            GROUP BY WRITER_NO
                        
                        );           
                        
                        ROLLBACK;
--커밋은 혹시 모르니

COMMIT;
                                                                        
SELECT WRITER_NO, MIN(ISSUE_DATE)
FROM TB_BOOK
                        JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
GROUP BY WRITER_NO;

SELECT *
FROM TB_WRITER
ORDER BY WRITER_NO;



-- 10
CREATE TABLE TB_BOOK_TRANSLATOR(
    BOOK_NO VARCHAR2(10) CONSTRAINT FK_BOOK_TRANSLATOR_01 REFERENCES TB_BOOK (BOOK_NO),
    WRITER_NO VARCHAR2 (10),
    TRANS_LANG VARCHAR2 (60) ,
    
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY (BOOK_NO, WRITER_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_02 REFERENCES TB_WRITER (WRITER_NO)
    
    
);



SELECT *
FROM TB_BOOK_TRANSLATOR;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TB_BOOK_TRANSLATOR';


--10
INSERT INTO TB_BOOK_TRANSLATOR
(
            SELECT BOOK_NO, WRITER_NO ,NULL
            FROM TB_BOOK_AUTHOR
            WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역')
);  -- VALUES대신에 SUB쿼리로
    
    SELECT *
    FROM TB_BOOK_TRANSLATOR;
    
    DELETE TB_BOOK_AUTHOR
    WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');
    --COMMENT ON TB_BOOK_TRANSLATE.B
    
    -- 12
--    SELECT B.BOOK_NM, W.WRITER_NM
--    FROM TB_BOOK B
--    JOIN TB_BOOK_AUTHOR A ON (B.BOOK_NO = A.BOOK_NO)
--    JOIN TB_WRITER W ON (A.WRITER_NO = W.WRITER_NO)
--    WHERE (B.BOOK_NO, W.WRITER_NO) IN (
--                                                                SELECT T.BOOK_NO, T.WRITER_NO
--                                                                FROM TB_BOOK_TRANSLATOR T
--                                                                WHERE B.BOOK_NO =T. BOOK_NO
--                                                            
--                                                            )
--    AND                                                        
--            SUBSTR(B.ISSUE_DATE,1,4) LIKE ('2007%')   ;
            ---------------------------
            SELECT*
            FROM TB_BOOK_TRANSLATOR;
            
            
              SELECT BOOK_NM, WRITER_NM
    FROM TB_BOOK
    JOIN TB_BOOK_TRANSLATOR USING (BOOK_NO)
    JOIN TB_WRITER USING (WRITER_NO )
    WHERE  SUBSTR(ISSUE_DATE,1,4) LIKE ('2007%');
            
            
            
            
            
            
            SELECT *
            FROM TB_BOOK
            JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
            JOIN TB_WRITER USING(WRITER_NO)
            WHERE (BOOK_NM, WRITER_NM ) IN ( SELECT BOOK_NM, WRITER_NM
                                                                FROM TB_BOOK_TRANSLATOR
                                                            ) AND
            SUBSTR(ISSUE_DATE,1,4) LIKE ('2007%')  ;
    SELECT *
    FROM TB_BOOK
    WHERE BOOK_NM IN ('올리버 트위스트 1', '올리버 트위스트 2');
    
    SELECT *
    FROM TB_BOOK
    JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
    WHERE BOOK_NO IN (SELECT BOOK_NO FROM TB_BOOK_TRANSLATOR);
    
    
  
    --13
    
    CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR
    AS
     SELECT B.BOOK_NM, W.WRITER_NM, B.ISSUE_DATE
    FROM TB_BOOK B
    JOIN TB_BOOK_AUTHOR A ON (B.BOOK_NO = A.BOOK_NO)
    JOIN TB_WRITER W ON (A.WRITER_NO = W.WRITER_NO)
    WHERE (B.BOOK_NM, W.WRITER_NM) IN (
                                                                SELECT BOOK_NM, WRITER_NM
                                                                FROM TB_BOOK_TRANSLATOR
                                                            
                                                            )
    AND                                                        
            SUBSTR(B.ISSUE_DATE,1,4) LIKE ('2007%') ;
            
            
            SELECT *
            FROM VW_BOOK_TRANSLATOR;
            
            
            
--14
INSERT INTO TB_PUBLISHER VALUES ('춘출판사', '02-6710-3737', DEFAULT);

DELETE TB_PUBLISHER
WHERE PUBLISHER_NM = '춘출판사';


SELECT *
FROM TB_PUBLISHER
WHERE PUBLISHER_NM = '춘출판사';


-- 15
COMMIT;

SELECT WRITER_NM, COUNT(WRITER_NM)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(WRITER_NM) >1;


--16 
SELECT *
FROM TB_BOOK_AUTHOR
;

UPDATE TB_BOOK_AUTHOR
SET COMPOSE_TYPE = '지음'
WHERE COMPOSE_TYPE IS NULL;



--17

SELECT WRITER_NM, OFFICE_TELNO
FROM TB_WRITER
WHERE SUBSTR(OFFICE_TELNO, 1 , 2)  = 02
AND SUBSTR(OFFICE_TELNO, 4,4 )LIKE ('___%');
            
            
--18
SELECT WRITER_NM
FROM TB_WRITER
WHERE EXTRACT (YEAR FROM (TO_DATE('2006/01/01'))) - EXTRACT( YEAR FROM ( REGIST_DATE) )>31;


--19
SELECT BOOK_NM, PRICE, CASE 
                                        WHEN STOCK_QTY <5 THEN '재고부족'
                                        ELSE '소량보유'
                                    END    AS "재고 보유 현황"

FROM TB_BOOK
WHERE PUBLISHER_NM = '황금가지'
AND STOCK_QTY<10;

--20 
SELECT BOOK_NM, WRITER_NM
FROM TB_BOOK 
JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
JOIN TB_WRITER USING (WRITER_NO)
WHERE BOOK_NM = '아타트롤';
 --??
 
 
 
 --21
 
 SELECT *
 FROM (
 SELECT BOOK_NM AS "도서명" , STOCK_QTY AS "재고 수량" , PRICE AS "가격(ORG)", PRICE*(0.8) AS "가격(NEW)"
 FROM TB_BOOK
 WHERE  MONTHS_BETWEEN( SYSDATE, ISSUE_DATE)   > 30*12 AND STOCK_QTY >90
 ORDER BY 1
 )
 ORDER BY '재고수량','가격(NEW)' DESC;
 
 
 SELECT MONTHS_BETWEEN ( SYSDATE, ISSUE_DATE)
 FROM TB_BOOK;
  
 
    