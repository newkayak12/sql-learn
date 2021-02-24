--JOIN은 기술 면접 때 질문하기도 한다(집한연산자도)


-- 다중 JOIN : 두 개 이상의 테이블을 연결하는 것



--사원의 부서명과 직책명을 조회하는 SQL문을 작성하자
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
                        JOIN DEPARTMENT ON DEPT_CODE=DEPT_ID
                        JOIN JOB USING (JOB_CODE);


-- 사원명, 부서명, 근무하고 있는 지역을 출력

SELECT *
FROM DEPARTMENT;

SELECT *
FROM LOCATION;


SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, JOB_NAME
FROM EMPLOYEE
                        JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE  -- 1
                        JOIN LOCATION ON LOCAL_CODE= LOCATION_ID  --  2
                        JOIN JOB USING (JOB_CODE);  -- 3

--이렇게 여러 개를 연결할 수 있다.  참고로 얘는 INNERJOIN 이다.

--JOIN을 읽을 때 FROM EMPLOYEE를 읽고 1,2,3 순으로 붙여나감 그러니까   ( ( EMPLOYEE + 1) + 2) +3) 이렇게
--그니까 JOIN  한 테이블에 있는 키로 연쇄적으로 붙이는 거니까 

--다중JOIN할 떄는 OUTER와 INNER를 같이 사용할 수 있다.


SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, JOB_NAME
FROM EMPLOYEE
                        LEFT JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE  -- 1
                        LEFT JOIN LOCATION ON LOCAL_CODE= LOCATION_ID  --  2
                        JOIN JOB USING (JOB_CODE)  -- 3
WHERE DEPT_TITLE LIKE '%해외%'
ORDER BY 2;
-- 위와 같이 > 일단 INNER/OUTER JOIN을 다시 보자





-- NON-EQUI JOIN 


--2. NON_EQU JOIN : 테이블 연결 할 때 대소/범위/NULL값으로 비교로 연결하는 것 ( 얘는 따로 범위 지정하는 테이블이 있어야한다.)
    -- 동등비교가 아니라 위와 같은 느낌으로
    
    
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- 여기까지가 JOIN문.... 대부분 사용하는게 EQUAL - JOIN 이긴 한데


--SUBQUERY (보조 쿼리)
SELECT *
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE);
--이렇게 쿼리 안의 쿼리 단 ()으로 묶어서 연산 우선 처리를 해줘야 정상 작동


-- 1 단일행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리 (서브쿼리 결과가 한 개의 열, 한 개의 행을 의미함)
            -- WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE) 1행 1열으로 구성되는 쿼리
            -- 130줄부터 확
            
-- 2 다중행 서브쿼리 : 서브쿼리의 조회 결과 값이 행이 여러 개인 서브쿼리리 (컬럼은 한 개에 행이 다수가 나오는 SELECT 구문)
            -- 행이 다수이기 때문에 비교가 불가능 > 동등 비교할 때는 IN/NOT IN 을 사용한다.
            -- ANY, ALL : 다수가 나오기 때문에 / EXIST : 값이 존재하면 (상관성 서브 쿼리)
            -- 150줄부터

-- 3 다중열 서브쿼리 : 서브쿼리의 조회 결과 컬럼의 개수가 여러 개인 서브쿼리
            --270줄부터
            
            
            
            
-- 4 다중행 다중열 서브쿼리 
        --300줄부


-------------------- 여기까지는 서브쿼리가 메인에 영향을 준다.

-- 5 상호연관성 쿼리 : 서브쿼리가 만든 결과 같을 메인 쿼리가 비교 연산할 떄 메인 쿼리 테이블의 값이 변경되면 서브 쿼리의 결과 값도 바뀌는 서브쿼리
        --319 줄
        


-- 6 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 한 개인 서브쿼리

-------------------- 메인이 서브에 영향을 주고 그 영향받은 서브가 메인에 다시 영향을 준다. 



-- 서브 쿼리
--하나의 SQL문(MAIN쿼리) 안에 포함되어 있는  또 다른 SQL문(서브쿼리)
-- 서브쿼리는 반드시 소괄호 '()'로 꼭 묶어줘야한다. 
-- 서브쿼리는 WHERE절에 사용 시에 오른쪽에 위치해야한다. 

-- 전지연 사원의 관리자 이름을 출력


--그냥 두 번의 쿼리로
SELECT MANAGER_ID FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = 214;


--  SELF JOIN으로 
SELECT M.EMP_NAME
FROM EMPLOYEE E JOIN EMPLOYEE M ON (E.EMP_ID = M.MANAGER_ID)
WHERE M.EMP_ID = 214;
--WHERE E.EMP_NAME = '전지연';


--단일 행 서브쿼리로
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = (SELECT MANAGER_ID 
                                FROM EMPLOYEE 
                                WHERE EMP_NAME = '전지연');
                                
                                
-- 사원의 평균 급여보다 많이 받는 사원 조회
-- 사원명, 부서명,직책명,  급여

SELECT EMP_NAME AS "이름" , DEPT_TITLE AS "부서명" , JOB_NAME AS "직급", SALARY AS "월급"
FROM EMPLOYEE
                        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                        JOIN JOB USING(JOB_CODE)
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY 1,3,4,2;


-- 윤은해 사원과 동일한 급여를 받고 있는 사원을 구하시오'

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '윤은해');

--사원의 최대 급여, 최소급여 받는 이의 이름

SELECT EMP_NAME,SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE)  OR SALARY =  (SELECT MIN(SALARY) FROM EMPLOYEE); 



-- 다중행 서브쿼리
-- 송종기, 박나라와 같은 부서에서 근무하는 사원의 이름/ 부서를 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE = ( SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN('송종기', '박나라'));

--ORA-01427: SINGLE-ROW SUBQUERY RETURNS MORE THAN ONE ROW
--01427. 00000 -  "SINGLE-ROW SUBQUERY RETURNS MORE THAN ONE ROW"
--*CAUSE:    
--*ACTION:
--이렇게 에러 그래서 위와 같이 쓰는게 아니라

WHERE DEPT_CODE IN ( SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN('송종기', '박나라'));
--이렇게 쓴다 = 대신에 IN  IN ('D9','D5')랑 같은 결과

-- 다중열 예시
--DEP_CODE
--D9
--D8


--직급이 대표, 부사장이 아닌 모든 사원 출력하기
-- ASIA 1에서 근무하는 지원 조회하기

SELECT EMP_NAME
FROM EMPLOYEE 
                            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                            JOIN JOB USING (JOB_CODE)

WHERE    JOB_NAME != '대표'
                         AND 
            JOB_NAME != '부사장'
                         AND 
            LOCATION_ID =( SELECT LOCAL_CODE FROM LOCATION WHERE LOCAL_NAME = 'ASIA1');
            
            
            
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT 
                                                                            JOIN LOCATION ON LOCATION_ID = LOCAL_CODE WHERE LOCAL_NAME = 'ASIA1');
            
            SELECT *
            FROM LOCATION;
            
            
--다중열 ANY|| SOME
--ANY는 대소비교, 동등비교  -> ANY에 있는 값의 비교를 OR로 연결
-- X > ANY(값1, 값2 ) : 어떤 값보다 X가 크기만 하면 TRUE/ 하나라도 X보다 크면 FALSE
                                            -- 최소값보다 크면 참
                                            
                                           -- 즉, 예를 들면 값1 = 10  , 값2 =20, 값3 = 30 ,  값4 = 40
                                           --X가 15라면 값1보다 T / 값2 F / 값 3 F/ 값 4 F
                                           --얘네들을 OR로 묶는다.
                
--X< ANY(값1, 값2) : ANY에 있는 어떤 값보다 X가 작기만 하다면 참, 최대값보다 작으면 참



SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY(2000000,5000000);


SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT SALARY FROM EMPLOYEE WHERE DEPT_CODE IN('D5', 'D6'));

--어따쓰냐?
-- 직책이 J3인 사원들 중 최소 급여보다 많이 받는 사원을 조회하기
SELECT *
FROM EMPLOYEE
--WHERE SALARY > ANY( SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE ='J3');
--3400000보다 큰
--WHERE SALARY > ( SELECT MIN(SALARY) FROM EMPLOYEE WHERE JOB_CODE ='J3');

--3900000보다 작은
WHERE SALARY < ANY( SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE ='J3');



--ALL : 모든 값보다 크다, 작다 -> AND
--X >ALL(값, 값1) : ALL의  모든 값보다  큰 X가 TRUE; / ALL의 값의 최대 값보다 크면 TRUE;
            --X> 값1? AND X>값2   결국 최대 값보다 크면 장땡

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ALL(2000000, 5000000);


--부서가 D2인 사원들의 최대 급여를 받는 사원보다 급여를 더 많이 받는 사원

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D2');
WHERE SALARY > (SELECT MAX(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D2');
--4480000보다 많이 받는


-- 2000년 1월 1일 이전 입사자 중에서 2000년 1월 1일 이후 입사자보다 급여를 (가장 높게 받는 사원보다) 적게 받는 사원의 사원명과 월 급여를 출력하시오
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE 
WHERE HIRE_DATE < '00/01/01'
                        AND
         SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE HIRE_DATE> '00/01/01');                



-- 어떤 J4직급의 사원보다 많은 급여를 받는 직급이 J5,J,6,J7인 사원
            
   SELECT *
   FROM EMPLOYEE
   WHERE  JOB_CODE IN ('J5','J6','J7')
              AND  (SALARY > ALL(SELECT SALARY FROM EMPLOYEE WHERE JOB_CODE  = 'J4'));
              
 
 
 
 
              
 -- 다중열 서브쿼리 : 행이 한 개이면서  컬럼이 여러 개인 서브쿼리 
              -- 퇴직한 여사원의 같은 부서, 같은 직급에 해당하는 사원 조회
 
 SELECT *
 FROM EMPLOYEE 
 --WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE ENT_YN= 'Y')
    --         AND JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE WHERE ENT_YN= 'Y');
 
 
 WHERE(DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE ENT_YN='Y');
              
   
   
   -- 기술지원부이면서 급여가 2000000 인 사원이 있다. 이름, 부서코드 급여 출력
   SELECT *
   FROM DEPARTMENT;
   
   SELECT EMP_NAME, DEPT_TITLE, SALARY
   FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
   WHERE(DEPT_TITLE, SALARY) IN (SELECT DEPT_TITLE, SALARY FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) WHERE DEPT_TITLE = '기술지원부' AND SALARY = 2000000);
   
   
   
   
   --다중 행 / 열 서브쿼리 :행도 여러 개/ 열도 여러 개
   SELECT  DEPT_CODE, MIN(SALARY)
   FROM EMPLOYEE
   GROUP BY DEPT_CODE ;
   
   
   --위에서 이름/ 부서명 출력
   SELECT  EMP_NAME, DEPT_TITLE, SALARY
   FROM EMPLOYEE  
   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
   WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MIN(SALARY)
                                                        FROM EMPLOYEE 
                                                        GROUP BY DEPT_CODE) ;
   
   
   --상관성 서브쿼리
   -- 서브쿼리를 구성할 때 메인쿼리에 있는 값을 가져와 사용을 하게 작성을 함
   -- 상관서브쿼리는 이중 FOR랑 로직이 비슷
   -- 서브쿼리 결과에 메인쿼리의 값이 영향을 주고 그 결과에 다시 메인쿼리가 영향을 받음
   
   --EXISTS : ROW가  1이상 있다면, 무조건  TRUE 그렇지 않고 ROW가 0개이면 FALSE;
   
   SELECT *
   FROM EMPLOYEE
   WHERE EXISTS (SELECT '1' FROM EMPLOYEE WHERE DEPT_CODE = 'D5');
   
   
   --부하직원 있는 사원을 조회
   
   SELECT *
   FROM EMPLOYEE E
   WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
   
   
   
   -- 심봉선 사원과 같은 부서의 사원의 부서코드, 사원명, 월 평균 급여를 조회
   
   SELECT DEPT_CODE, EMP_NAME
   FROM EMPLOYEE E
   WHERE EXISTS (SELECT EMP_NAME  FROM EMPLOYEE WHERE EMP_NAME ='심봉선' AND  E.DEPT_CODE = DEPT_CODE);
   
   
   -- 스칼라 서브쿼리
   -- 가장 많은 급여를 받는 사원을 EXISTS 연산자를 이용해서 구해보자
   
   SELECT EMP_NAME
   FROM EMPLOYEE E
   WHERE  NOT EXISTS( SELECT EMP_NAME FROM EMPLOYEE WHERE E.SALARY > SALARY);

                             --최대 급여

SELECT EMP_NAME
   FROM EMPLOYEE E
   WHERE  NOT EXISTS( SELECT EMP_NAME FROM EMPLOYEE WHERE E.SALARY > SALARY);                             
   
                            --최소 급여
                            
                            
         -- 상관 서브쿼리의 결과가 단 하나만 나오면 스칼라 서브쿼리
         -- 스칼라서브쿼리 : 상관 서브쿼리의 결과가 단일 행인 쿼리문
         
         --SELECT의 WHERE나 컬럼이 들어가는 곳에 사용?
         
        --모든 사원의 사번, 이름, 관리자 번호, 관리자명을 조회
        
        SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID, M.EMP_NAME 
        FROM EMPLOYEE E JOIN EMPLOYEE M ON E.MANAGER_ID= M.EMP_ID;
        
        --스칼라서브쿼리를 사용하면
        SELECT EMP_ID, EMP_NAME, MANAGER_ID, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID=E.MANAGER_ID)  --> 한 개만 나왔을 때 -> + PRIMARY키
        FROM EMPLOYEE E;
        
         SELECT EMP_ID, EMP_NAME, MANAGER_ID, (SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE=E.DEPT_CODE)  --> 안됨/ PRIMARY키가 아니야..
        FROM EMPLOYEE E;
        
        
         --ORA-01427: SINGLE-ROW SUBQUERY RETURNS MORE THAN ONE ROW
            --01427. 00000 -  "SINGLE-ROW SUBQUERY RETURNS MORE THAN ONE ROW"
            --*CAUSE:    
            --*ACTION:
         
         
         
         
         -- 사원 명, 부서 코드, 부서별 평균 임금을 조회해라
         SELECT *
         FROM EMPLOYEE;
         
         
         
         SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D9';
         SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D6';
         --저 뒤에 따라 바뀌죠
         
         SELECT DEPT_CODE, EMP_NAME, SALARY,  FLOOR( (SELECT AVG(SALARY) FROM EMPLOYEE     WHERE DEPT_CODE = E.DEPT_CODE) ) AS "부서별 평균"
          FROM EMPLOYEE E
          --GROUP BY DEPT_CODE, EMP_NAME
          ORDER BY 1,2;
          
          
          
          
          
          -- 직급이 J1이 아닌 사원 중에서 자신의 부서별 평균 급여보다 적은 급여를 받는 사원출력
          -- 부서코드, 사원명, 급여, 부서별 급여평균
          
          
          SELECT DEPT_CODE AS "부서코드", EMP_NAME AS "사원명", SALARY AS "급여" ,  TRUNC((SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE), 2) AS "부서별 급여 평균"
          FROM EMPLOYEE E
          WHERE JOB_CODE <> 'J1' AND (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.DEPT_CODE = DEPT_CODE ) > SALARY
          ORDER BY 1,2;
          
          
          --테이블을 뽑아 놓고 필터링을 나중에 해도 된다...
          -- 한 번에 다 쓸 생각을 하지 말고, 단계별로 쿼리문을 작성하는 것도 고려해봐야하는 선택지라고 생각해
          
          --SELECT의 WHERE나 컬럼이 들어가는 곳에 사용할 수 있다!!!!
          
          
          -- 자신이 속한 직급의 평균 급여보다 많이 받는 직원의 이름, 직책명, 급여를 조회
          
          
          SELECT EMP_NAME, JOB_NAME, SALARY
          FROM EMPLOYEE E JOIN JOB J ON (J.JOB_CODE= E.JOB_CODE)
          --FROM EMPLOYEE  E JOIN JOB USING(JOB_CODE)
          WHERE (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE) <  SALARY
          ORDER BY 1,2;
          
          --????
          
          --1스칼라
          --2그룹BY
          
          --배운 레고로 조립하는 거
          --USING을 쓰면 별칭을 쓸 수 없어서 오류났었네
          
          
            
          SELECT EMP_NAME, JOB_NAME, SALARY
          FROM EMPLOYEE   JOIN JOB USING(JOB_CODE)
          WHERE (SELECT AVG(SALARY) FROM EMPLOYEE  E WHERE E.JOB_CODE = JOB_CODE) <  SALARY
          ORDER BY 1,2;
          
          
          
          
          
          --인라인 뷰 : from절에 select문이 들거나는 것
          --인라인 함수랑 비슷한 느낌이다?? 
--물리적인 테이블이 아닌 resultset을 테이블로 보는 것 view(가상)

-- INLINE VIEW : FROM절에 SELECT문 쓴 것  ( 다중열, 다중 행 서브쿼리.. 대부분)

-- STORED VIEW : 영구적으로 저장하고 사용하는 View -> 나중에 view를 배울때.. 사용



-- 여사원의 사번, 사원명, 부서코드, 성별을 출력

select emp_id, emp_name, dept_code, decode( substr( emp_no, 8,1), '1', '남', '2', '여') 
from employee
where decode( substr( emp_no, 8,1), '1', '남', '2', '여')  = '여';

select *
from 
            (select emp_id, emp_name, dept_code, decode( substr( emp_no, 8,1), '1', '남', '2', '여') 
                from employee
                where decode( substr( emp_no, 8,1), '1', '남', '2', '여')  = '여'); --이러면 한 개의 테이블화(가상화) > 이러면 우리가 조작한 컬럼을 사용할 수 있음
                





                            
                             
   
   
              