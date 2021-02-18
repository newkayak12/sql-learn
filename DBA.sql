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
select * from tab; --게정이 가지고 있는 전체 테이블 조회  tab (table의 약자)

select * from department;
select * from employee;
select * from job;
select * from location;
select * from national;
select * from sal_grade;











