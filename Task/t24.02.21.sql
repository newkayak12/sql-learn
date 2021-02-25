--additional select -option
--1
select  student_name as "학생 이름", student_address as "학생 주소"
from tb_student
order by 1;

--2
select student_name , student_ssn 
from tb_student
order by 2 desc;

--3
select  student_name, student_no, student_address
from tb_student
where substr(student_address, 1,3) in ('경기도', '강원도') and (substr(student_no,1,2) like ('9%'));


--4
select professor_name, professor_ssn
from tb_professor join tb_class using (department_no)
where department_no = '001'
order by 1 desc;

select distinct p.professor_name, p.professor_ssn

from tb_professor p join tb_class_professor using (professor_no)
                            join tb_class e using (class_no)
                            
where e.department_no = '005'
order by 2 ;




select *
from tb_department;

select * 
from tb_class;



--5
select student_no , point
from tb_student join tb_grade using(student_no)
where class_no = 'C3118100' and term_no ='200402'
order by 2 desc;


select *
from tb_grade;
--6

select student_no, student_name, department_name
from  tb_student join tb_department using(departMent_no)
order by 2 ;

--7
 select class_name, department_name
 from  tb_class join tb_department using (department_no);

--8
select class_name, professor_name
from tb_professor join tb_class using (department_no)
order by 2;

--9
select class_name, professor_name
from tb_professor join tb_class using (department_no)
                            join tb_department using( department_no)
where category = '인문사회'
order by 2;


--10

select  student_no, student_name ,  trunc(avg(point),1)

from tb_student join tb_grade using (student_no)
                        join tb_department using(department_no)
                    
where department_name = '음악학과'

group by student_no, student_name;

--11
select department_name as "학과 이름", student_name as "학생이름" , professor_name as "지도교수 이름"
from tb_department join tb_student using(department_no)
                            join  tb_professor using (department_no)
where   student_no = 'A313047' ;

select *
from tb_student;


--12  ****
select student_name, term_no
from tb_student join tb_grade using (student_no)
                        join tb_class using (class_no)
where class_name = '인간관계론' ;






select student_name
from tb_student join tb_grade using(student_no)
where class_no = 'C2604100';


select student_name, term_no
from  tb_student  join tb_grade using(student_no)
                            join tb_class using (class_no)
where class_name = '인간관계론' ;


select student_name, term_no
from tb_student  join (select *
                                 from tb_grade
                                where class_no = (select class_no
                                                            from tb_class
                                                            where class_name = '인간관계론')) using(student_no)
                                                            
order by 1   ;

select *
from tb_grade
where class_no = (select class_no
                            from tb_class
                            where class_name = '인간관계론');

select class_no
from tb_class
where class_name = '인간관계론';

--13





select class_name, department_name
from tb_class   outer left join tb_class_professor using(class_no)
                         join tb_department using(department_no)   
 where category = '예체능' and professor_no is null
 order by 1,2;


select *
from tb_class;

select *
from tb_department;

select *
from tb_class_professor;



--14 
select  student_name, NVL(professor_name, '지도교수 미지정')
from tb_student s left outer join tb_professor p on (coach_professor_no = professor_no);
--where  s.coach_professor_no = ;

select *
from tb_professor;

select *
from tb_class_professor;


select *
from tb_student
where student_name = '남가영';


--15
select student_no,  student_name, department_name , trunc((select avg(point) from tb_grade g where e.student_no = g.student_no),1) as "평점"
from tb_student e join tb_department using( department_no)
where absence_yn = 'N'  and trunc((select avg(point) from tb_grade g where e.student_no = g.student_no),1) >=4.0
order by 1;

--16

select class_no, class_name, trunc((select avg(point) from tb_grade g where c.class_no = g.class_no),1) as "avg(point)"
from tb_class c join tb_department using (department_no)
where department_name = '환경조경학과' and class_type like ('전공%')
order by 1;


select *
from tb_class;
--17

select student_name, student_address
from tb_student
where department_no in (select department_no from tb_student where student_name = '최경희');


--18
select e.student_no, e.student_name

from tb_student e join tb_grade o on (e.student_no= o. student_no)
                        join tb_department d on(e.department_no = d.department_no)
                        
where department_name = '국어국문학과'
group by e.student_no, e.student_name 
having sum(o.point) > any(select  sum(g.point)
                                from tb_grade g
                                where e.student_no = g.student_no );
                                
                                
                                
select student_no, student_name
from 



select *
from tb_student;

select *
from tb_grade;

select student_no, sum(point)
from tb_grade
group by student_no;


--19