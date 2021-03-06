--02/17(수)
-- 여기에는 명령어를 입력할 수 있는 창이다.  맨 오른쪽 하드모양은 이 질의를 어디에서 실행할 것이냐?
-- 계정 별로 DB가 있을건데

SELECT * FROM DICt;  --dictionary테이블에 있는거 다 조회해라 (대소문자 안가림)
--오라클db에 대한 정보를 가지고 있는 테이블 : Data Dictionary라고 
-- SELECT * FROM DICTIONARY; 이렇게 써도 
-- 현재 db에 등록된 
select * from dba_users;
--  계정은 관리자 계정, 사용자 계정으로 나뉜다.
-- 관리자 계정 : 사용자 계정을 등록/ 권한 부여 하고, 전체 생성된 저장소(TABLE)을 관리하는 역할을 한다. -> 데이터 베이스 자체를 전체적으로 관리
--  ㄴ system/ sys계정이 있다.
-- sys:가 super관리자 : 데이터 베이스를 생성하고 삭제하고 data dict을 소유하고 있다. > 최고 관리자!
-- system : 일반 관리자 (sys보다는 약한) : 데이터 베이스 자체를 생성 삭제할 수 없음

-- 기본적으로 오라클 data base를 이용하기 위해서는 사용자 계정이 필요하다. 
-- 사용자 계정 만들기, 계정에 대한 권한부여
-- 사용자 계정은 SYstem, sys as sysdba 계정으로 명령어를 사용해서 생성
-- create user 유저명 identified by 비밀번호 
create user kh identified by kh;
-- User KH created.

select * from dba_users; --비밀번호는 대소문자 구분한다. 

--kh로 접속하려면?? > 접속을 등록해줘야한다?  +눌러서 로그인하면 됨
-- failure ora-01045: user kh lacks create session privilege : logon denied > 세션을 만드는 것 역시 권한이 필요하다. 
-- 계정은 생성한다고 바로 쓸 수 있는 것이 아니라 권한까지 줘야한다. (아마 아이디 생성하면 아무 권한 없는 상태로 만들어지고 

--System이나 sys as sysdba 계정이 권한을 부여해야함
--grant 권한명(role) to 사용자 계정명;

--권한은 어떤게 있을까??
--resource, conntect (role) 을 부여

grant resource, connect to kh;
-- Grant succeeded.
-- 거의 자연어에 가깝게 질의어를 써놨네...

create user test identified by test;
grant resource, connect to test;

-- 02/18(목)
-- 얘를 실행할 수 있는 녀석은 system or sys as sysDBA

--오라클에서 항상 중요한 것은 명령을 수행할 권한이 있는가? > 그래서 sys나 system이 굉장히 중요하다. 
-- resource : 테이블을 생성/조작할 수 있는 권한
-- connection : 할당된 영역에 접속할 수 있는 권한


-- kh계정정보 확인하기
select * from tab;
--게정이 가지고 있는 전체 테이블 조회  tab (table의 약자)
--TNAME은 테이블 


-- 생성된 kh계정의 테이블을 확인해 봅시다!
select * from department;
select * from employee;
select * from job;
select * from location;
select * from national;
select * from sal_grade;
-- from 뒤에는 테이블 명이 나온다. 
--우리가 기본 테이블로 사용할 일종의 포맷 정도로 생각하면 된다.(질의에 대한 답변을 보면)


--  select 해보기 (kh계정의 Employee테이블을 조회해보자.)
-- 사번 emp_id/ 이름 emp_name/ 월급 salary

select emp_id, emp_name, salary 
from employee;

-- employee table에서 사원 이름, 이메일, 부서 코드, 직책코드 조회하기

select emp_name, email, dept_code, job_code 
from Employee;

--employee테이블에 있는 전체 컬럼 조회에는  *를 이용하자

select *
from employee;


--select는 단순히 조회뿐만 아니라 select해서 조회할 때 산술 연산처리도 가능하다. (DB에서는 select가 가장 중요한 이유)
-- 단, 산술연산은 숫자형 타입이어야 할 수 있다. (당연히 타입이 있겠지)

--select 컬럼명 || 리터럴 값을 적을 수 있다.
select 10*100
from dual; --dual 테이블은 오라클에서 기본 제공하는 테이블로 간단한 테스트를 위한 테이블 

--이렇게 리터럴을 쓰는 방법도 있지만 Select문에서 산술연산을 진행 할 때는 컴럼명을 가져와서 계산할 수도 있음

--사원 연봉 구하기
select emp_name, salary, salary *12 
from employee;

-- 각 사원의 보너스??

select emp_name, salary, bonus, salary*bonus
from employee;

-- 컬럼값이 null인 row는 값이 없는 것 (DUMMY값) > 쓰레기는 계산이 안된다. 
-- select 안에서 함수를 호출하거나 할 수도 있음


-- 사원의 employee테이블에서 사원명, 부서코드, 직책코드, 월급, 연봉, 보너스 포함한 연봉 조회하기

select emp_name, dept_code, job_code, salary, salary*12,  (salary*(1+bonus))*12
from employee;

-- 이런 연산도 가능하다.
--resultset의 컬럼명 변경하기 (별칭 붙여주기)
-- 컬럼명 as 별칭명, 컬럼명 별칭 : as를 쓰는 것을 추천
--eg) select emp_name as 이름 
--      from employee;





select emp_name as 사원명, email as 이메일, phone as 전화번호
from employee;




-- 별칭은 아무거나 다 가능할까? 띄어쓰기나 특수기호 혹은 숫자로 시작하는 이름  
select EMP_Name as "사 원 명 ", email as "@이메일"
            , dep_code as "1부서"
from employee;

--그냥 as 쓸 때 ""로 묶어 그냥 > 띄어쓰기/ 첫글자 숫자/ 특수기호
--그렇다고 ""로 감싼것은 문자열 리터럴이 아니다. 그냥 값! (문자 값 그 자체는 아니다.) _ 자바랑 다릅니다. -> 문자열 리터럴은 ' ' 으로 표현

--select 절에서 문자열 리터럴 사용하기
select emp_name,'님', salary,'원'
from employee;



-- 행에서 중복값을 쩨거하고 출력하기
-- distinct : 행의 중복된 값을 한 개만 출력

select job_code
from employee;

select DISTINCT job_code
from employee; 
--job 코드 출력할 때 중복되는 것은 한 개만 출력하도록함
-- distinct는 select문에서 한 번 사용이 가능함 select맨 앞에
select job_code, distinct dept_code
from employee;

select distinct job_code, dept_code
from employee;
근데 이러면 distinct 뒤에 있는 녀석들을 통으로 하나로 봐서 j2가 있더라도 dept_code가 다르면 다른것으로 봄

-- 컬럼, 리터럴을 연결해보자.
--||연산자 : select에 작성된 컬럼 혹은 리터럴을 하나로 합쳐줌

select emp_name||'님' as "이름", salary||'원' as "연봉", dept_code || job_code as "부서/직책"
from employee;

-- select 컬럼명, 컬럼명, 리터럴
--from 테이블 명; 
-- 추가적으로 where을 쓸 수 있음 (상당히 중요하다. _ 조건문이니까)
-- [ where ] : 조건문 (row(데이터)를 필터링해주는 문장!

-- 이런 연산을 하면 from 테이블에서 값을 다 가져오고 where로 튜플 하나하나 다 비교를 해요 그리고 where절이 true이면 \ resultset으로 넘겨요 (즉 전체에 대해서 루핑한다는 소리임)

-- [where 컬럼명 비교연산자를 사용한다.(==,  >=, <=, >, <, !=) 컬럼명or리터럴
-- 오라클은 ==이 없어요 근데 ' = ' 이게 있어요
            
 
 
 
 
 
 -- 
            -- 이항 연산/ 기본 비교 연산
-- = :  동등비교 (같은지 비교)
-- !=, <>, ^= : 같지 않은지를 비교  (아....)
-- <,>,<=,>= : 대소비교 (숫자/날짜)
--  between 숫자 and 숫자 : 특정 범위의 값을 비교  ( 1<=A && A<=10)이거랑 같은 연산임
-- like / not like : 특정패턴에 의해서 값을 비교 * 부분일치 여부(포함했니 아니니)
-- in / not in : 다중값의 포함 여부  a=20, a=30, a=40 >> a in 20, 30, 40 (or랑 묶이는)
-- (컬럼) is null / is not : null값에 대한 비교 (컬럼에 null이 들어간 것/ 안 들어간 것만 찾을 때 사용)


        --논리 연산 : 진위여부를 확인하는 연산자  > 논리 와 논리를 연결 (논리 && 논리), (논리||논리)
--  and : 자바에서 &&
--  or    : 자바에서 ||
--  not  : 자바에서 ! (부정연산)

-- 얘네들 결과 뭐나와요 true/false






-- 실습, where employee테이블에서 월급이 350만원 이상인 직원 조회
--사원명, 부서코드, 급여

select emp_name||'님' as "사원명", dept_code as "부서 코드", salary as "월급"
from employee
where salary >= 3500000;

-- where절을 잘 써야 내가 원하는 값만 query가능


-- 추가적으로! 위의 조건 이면서 부서 코드가 d5인 사원

select emp_name||'님' as "사원명", dept_code as "부서 코드", salary as "월급"
from employee
where salary >= 3500000 and dept_code = 'D5';

-- 문자는 ' ' 로 묶는다. 
-- 위의 규칙을 준수하면 내가 원하는 데이터를 가져올 수 있으면 된다. 


-- 부서코드가 D6이 아닌 사원의 전체 컬럼 조회하기

select*
from employee
--where dept_code != 'D6';
--where dept_code <> 'D6';
where not dept_code = 'D6';


-- 직급 코드가 j1이 아닌 사원들의 월급 등급 중복없이
-- distinct 쓰면 중복이 안걸리는데


select distinct  sal_level 
from employee
where not job_code = 'J1';



-- 부서 코드가 d5이거나 급여를 300만원 이상 받는 사원
-- 사원명, 부서코드, 급여


select emp_name, dept_code, salary
from employee
where dept_code = 'd5'  or salary >= 3000000;

-- 사원의 급여가 200만원 이상 400만원 이하인 사원의 사원명 직책코드, 급여조회

select emp_name, job_code, salary
from employee
where salary between 2000000 and 4000000;

-- 대소 비교는 날짜도 가능하다. > 날짜는? 문자열로 '년/월/일 ' > '00/00/00' 이렇게 두 글자씩
-- employee 테이블에서 고용일이 90년01월01일보다 빠른 사원을 조회


select *
from employee
where hire_date < '01/feb/01'; -- 일/월/년


--like : 패턴에 의해서 데이터를 조회하는 기능
-- where 컬럼명 like '%리터럴'  or '_리터럴' 혹은! '리%터럴'

--  '% ' : 글자가 0개 이상 아무 문자나 다 허용 (없어도 되는 부분이고 100개든 1000개든 > '%강%' -> 데이터에 '강'이 포함되어있는지
        -- 가나다라마강 : 된다.  //    강 : 된다.  // 가나다강나라니아 : 된다.   // 강하나 : 된다.
        -- 만약 %강  : ~ 강으로 끝나는 문자 

-- '  _ '  :  그 자리 아무 문자나 한 개 
        -- '_강' : 강으로 끝나는 두 글자 ( ' - '으로 끝나면 글자수를 고정함)
        --  '_ _ 강' : 세글자
        
        
        -- employee에서 전씨 성을 가진 사원
        
        
        select emp_name, salary
        from employee
        --where emp_name like '전__';
        --where emp_name like '전%';
        where emp_name like '전__%';
        --이래야 맞지
        
        
        -- 사원명 중간에 '옹'이 들어가는 사원 이름 / 부서코드
        
        select emp_name, dept_code
        from employee
        where emp_name like '_옹%';
    -- where emp_name like '%옹%';
    
        select emp_name, email
        from employee;
        
        
        -- employee  테이블에서 _ 앞의 글자가 3글자인 사원을 찾기
        
        
        select emp_name, email
        from employee
        where email like '___\_%' escape'\';
        


        
        -- 성이 '이'씨가 아닌 사원 조회하기
        select emp_name, email
        from employee
        where not emp_name like '이%';
        
        
        -- 보너스가 null인 녀석
        select emp_name, bonus
        from employee
        --where bonus is null;
        where bonus is not null;
        -- where bonus = (null) > null은 연산이 불가능함  null을 비교하기 위해서는 오라클에서 제공하는 예약어를 사용해야함 is null/ is not null
        
        
        --다중 값을 비교하기 
        --in / not in : 다중값을 한 번에 동등 비교하는 아이
        -- employee 테이블에서 부서코드가 D5, D6인 사원 조회하기
        --  사원명 부서명
        
        
        select emp_name, dept_code
        from employee
   --     where dept_code = 'D5' or dept_code = 'D6';   -- in 과 같다.
   --     where dept_code in('D5','D6');  --다중 행 서브쿼리와 같이 사용

--파란글씨는 대소문자 구별하네 특히 리터럴
        where dept_code not in ('D5', 'D6');
        
        
        -- 직책이 J2 또는 J7인 사원 중 급여가 200만원 초과인 사원
        
        
        select emp_name, job_code, salary
        from employee
        where job_code in('J2','J7')  and salary >= 2000000;
        -- where job_code = 'J7' or job_code = 'J2' and salary >= 2000000;  -- 연산자 우선순위에 따라서 잘못된 값이 나옴
        -- where (job_code = 'J7' or job_code = 'J2' )and salary >= 2000000;




 -- ******************************************************************2월 19일(금)
 -- select 계속
 -- 문자열 함수에 대해서 알아보자
 
 
 --** length :  문자열 || 컬럼의 길이를 알려주는 기능
 
 Select Length('안녕하세요') 
 from dual;
 
 --기존 테이블에서 찾으면
 select emp_name, length(emp_name), email, length(email)
 from employee;
 
 --이메일의 글자수가 16이상인 사원 출력
 
 select emp_name, email, length(email)
 from employee
 where length(EMAIL)>=16;
 
 
 --**lengthB : 문자열||컬럼의 길이 byte단위로 출력
select emp_name, lengthB(emp_name) 
from employee;
--오라클 express버전에서 한글을 3byte로 / enterprise는 2byte... 아오!ㅋㅋㅋ

select length('asv') 
from employee;
 
 --** instr
 --찾는 문자열이 지정한 위치부터 지정한 횟수 번째에 나타나는 위치 반환(인덱스 번호)
 --instar(문자열|| 컬럼(target)  , 문자열|| 컬럼( reference)  , 시작위치, 몇 번째에서 찾을 것인가? > 중복값이 있을 때 사용)
 
 select instr ('kh 정보교육원', 'kh')
 from dual;
 
 --오라클은 인덱스 시작이 1 (자바는 0) 
 
 
 select instr('kh정보교육원 kh수강생화이팅', 'kh', 3)
 from dual;
 -- 9번째 (시작점이 3번째 인덱스)
 
 
 select instr('kh정보교육원 kh수강생화이팅  kh Rcalss힘내라', 'kh', 3, 2)
 from dual;
 -- 18 시작점이 3 , 중복이 되는 두 번째 값
 
 
 
 select instr('kh정보교육원 kh수강생화이팅 kh Rcalss힘내라', 'kh', -1)
 from dual;
 --역순으로 색인 시작 물론 인덱스 번호는 앞에서부터 시작하니까 그래서 
 -- 18이 나옴 lastIndexOf랑 비슷
 
 
 --employee 테이블에서  email의 @의 위치를 구하세요
 
 
 select email, instr(email, '@')
 from employee;
 --물론 얘 혼자 쓰이는건 아님 subString이랑 indexOf랑 같이 쓰인 것처럼 ... 한 번에 할 수 있도록 좀 만들어놔!!
 
 
 --LPAD/RPAD :할당된 공간에서 빈 공간의 왼/오른쪽을 특정문자로 채우는 기능을 한다.
 --L/RPAD(문자열||컬럼, 공간의 크기, 문자)
 -- 공간은! byte단위로 본다. 
 select Lpad('유병승', 10 , '!')
 from dual;
 
 --!!!!유병승
 
 select Rpad('ybs', 10 , '!')
 from dual;
 
 --ybs!!!!!!!
 
 select rpad(email, 16, '#') 
 from employee;
 
 --활용
 
 select rpad('ybs', 16) 
 from employee;
 --첨부 문자를 안쓰면 default로 띄어쓰기
 
 select rpad('ybs', 16, '') 
 from employee;
 
 --왜 null??
 
 
 -- 빼는 것
 --ltrim/rtrim : 문자열의 왼쪽, 오른쪽에 있는 공백, 지정문자를 제거
 -- l/rtrim(문자열|| 컬럼 [, 문자])    * []는 생략 가능

 
 
 select LTRIM('       병승       ')
 from dual;
--'병승       '

select RTRIM('       병승       ')
 from dual;
 --'       병승'
 
 
 select trim('           병승              ')
 from dual;
 -- '병승'
 
 -- 데이터 입력시 본인도 모르게 공란이 들어가는 경우가 있을 수도 있다. 문제는 검색을 했을 때 공란 때문에 제대로된 검색 결과를 보여주지 않을 수가 있다. 따라서 trim을 이용해서 공백을 제거해서 집어 넣는 것이 중요하다.
 
 
 
 select ltrim (00000000123123, '0')
 from dual;
 
 
 select ltrim(00000100101010101010, '0')
 from dual;
 
 
  select ltrim(00000100101010101011, '01')
 from dual;
 
 --(null) 이게 01로 묶어서 비교하는게 아니라 0 또는 1로 잡아서 0, 1이 들어간거는 다 지워버린다는 소리야  000000100101010, 0 은 1을 만나는 순간 멈춰버리는거고
 
 
 
 --12314123081203유병승
 select ltrim('123123123123유병승', '1234567890')
 from dual;
 
 
 --123123840유병승1092358129387
 select ltrim(rtrim('123123840유병승1092358129387','1234567890'),'1234567890')
 from dual;
 
 
 
 --trim : 양쪽, 옵션에 따라서 왼/오른/양쪽 특정 문자를 제거한다. (단, 문자는 오로지 1개)
 -- 생략하면 공백을 날림
 -- trim(문자열 || 컬럼 -> 공백제거    
 -- trim(문자열 || 컬럼[, ' 문자열 ']) -> 양쪽에서 문자를 제거 단 1개****
 -- trim( 한개 문자 from 문자열||컬럼) 양쪽에서 문자를 제거
 --trim(leading\\trailing\\both 문자 from 문자열||컬럼)
 
 select trim(both '1' from '11111유병승111111')
 from dual;

 select trim(leading '1' from '11111유병승111111')
 from dual; 
 
  select trim(trailing '1' from '11111유병승111111')
 from dual;
 
 --substr (subString) : 컬럼||문자열을 지정한 위치부터 지정한 개수 만큼  잘라내기
 -- substr(문자열||컬럼, 시작위치[, 길이])
 
 select substr('ShowMeTheMoney', 5)
 from dual;
 
 -- 시작위치 포함해서 잘라내고
 
 select substr('ShowMeTheMoney', 5, 2)
 from dual;
 
 -- 2 글자를 잘라냄 (얘는 index, index가 아니다)
 
 
  select substr('ShowMeTheMoney', -3, 3)
 from dual;
 
 --그냥 음수면 y가 -1  e 가 -2 .... 이렇게 인덱스가 붙는거지
 
 --생일
 select emp_name, substr(emp_no, 1 , 6)
 from employee;
 
 --이렇게 활용하고
 select emp_name, emp_no
 from employee
 where substr(emp_no, 8 , 1) =2;
 
 
 select substr(email, instr(email,'@')+1)
 from employee;
 
 --영문자 upper/lower/inicatp(첫글자만 대문자)
 
 
 select upper('yubyeonseung')
 from dual;
 
 select lower('KimYeJin')
 from dual;
 
 select initcap('orcAle is hArd for me')
 from dual;
 
 --띄어쓰기를 기준으로 단어로 인식해서 띄어쓰면 다 첫 글자를 대문자로 바꿔버리네
 --이외의 대문자는 소문자로 바꿔버리네
 
 
 --활용
 
 select email
 from employee
 where email like lower('%KH%');
 
 
 -- concat : concatenation(연쇄) , 연결연산을 하는 함수, ==,|| (자바의 concat)
 -- concat(문자열, || 컬럼, 문자열||컬럼)
 
 select (concat('여러분', ' 도망가세요'))
 from dual;
 
 
 -- replace : 특정 문자를 변경하는것
 -- replace(타겟 문자||컬럼, 변경될 문자, 교체될 문구)
 select replace('i love my life', 'love', 'hate')
 from dual;
 
 --예를 들어서
 select replace ( email, 'kh.or.kr', 'gmail.com')
 from employee;
 
 --reverse : 해당 문자열 거꾸로 만드는 기능
 
 select reverse('abc')
 from dual;
 
 
 select reverse('가나다')
 from dual;
 --byte수로 계산하는 거여서 한글이... 깨짐
 
 
 --translate : 매칭되어있는 값으로 출력
 select translate('010-2711-4160', '0123456789', '영일이삼사오육칠팔구')
 from dual;
 
 --1:1 매칭
 
 -- 여기까지 문자처리 함수
 
 --abs : 절대값을 처리하는 함수
 select abs(10), abs(-10)
 from dual;
 
 
 -- mod : 나머지
 -- mod(숫자, 나눌 값)
 select  mod(3, 2) as "나머지"
 from dual;
 
 
 select  mod(3, 2)|| '(은)는 3/2의 나머지' as "나머지"
 from dual;
 
 
 select mod (salary, 3)
 from employee;
 
 select * 
 from employee
 where mod(salary, 3) =0;
 
 --소수점 처리하는 함수들
 
 -- round : 소수점 반올림
 --round(소수점 자리 숫자) -> 소수점에서 반올림

 select round(126.2923)
 from dual;
 
  -- round (소수점이 있는 숫자 [,자리수]) -> 해당 자리수까지 남기고 그 밑의 수를 반올림해서 표현함
  
 select round(126.2923, 1)
 from dual;
 
 --round 의 자리수에 -값이 들어갈 수 있다. : 소수점을 기준으로 +면 소수점 아래쪽/ -면 소수점 위의 자연수 
 부분으로
 select round (126.2923, -1)
 from dual;
 
 
 
  --floor : 소수점 자리를 버림
  select floor ( 123.456789)
  from dual;
  
  -- trunc : 버림 (특정 자릿수에서)
  --디폴트는 floor랑 비슷한데,
  select trunc(123.456)
  from dual;
 
  select trunc(123.456,2)
  from dual;
 
 -- 이러면 2자리까지 표시
 
 select trunc(123.123, -1)
 from dual;
 -- 120
 
 
 --ceil : 올림
 select ceil(122.123)
 from dual;
 
  -- 얘는 위치 지정 안됨
 