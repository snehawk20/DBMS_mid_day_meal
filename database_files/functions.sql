-- FUNCTIONS	

-- 1.EXTRA BUDGET OF CITIES UNDER A GIVEN DISTRICT
CREATE OR REPLACE FUNCTION public.calc_extra_budget(districtid integer)
RETURNS TABLE(city_id integer, 
              schools_enrolled integer, 
              budget_alloted numeric, 
              mdm_expenses numeric, 
              extra_budget numeric) 
LANGUAGE 'plpgsql'
AS $BODY$
begin
      return query
      select c.city_id, c.schools_registered, c.mdm_budget, c.total_budget,      
             c.mdm_budget - c.total_budget as extra_budget
      from city_committee c
      where district_id = districtID;
end;
$BODY$;


/*--------------------------------------------------------------------------*/

-- 2.UNRESOLVED GRIEVANCES OF SCHOOLS UNDER A DISTRICT
CREATE OR REPLACE FUNCTION public.district_grievances_data_func(districtid integer)
RETURNS TABLE(school_id integer, 
              complaint_number integer, 
              date date, 
              category grievance_category, 
              complaint_details character varying, 
              status grievance_status, actions_taken character varying) 
LANGUAGE 'plpgsql'
AS $BODY$ 
begin
	return query
	select g.school_id , cast(row_number () over(partition by g.school_id order by g.date)as,integer),              
              g.date , g.category , g.description , g.status , g.actions_taken 
	from grievances g
	where g.school_id in (select s.school_id from school s where s.district_id = districtID) 
                              and ( g.status = 'progressing' or g.status = 'new' ) ;
end; 
$BODY$;


/*--------------------------------------------------------------------------*/

-- 3.MONTHLY ITEM EXPENSES OF A SCHOOL
CREATE OR REPLACE FUNCTION public.school_monthly_item_expenses_func(schoolid integer,monthnum integer, yearnum integer)
RETURNS TABLE(item_name character varying, 
              item_expense numeric, 
              stock_expense numeric) 
LANGUAGE 'plpgsql'
AS $BODY$
begin
	return query 
	select t1.item_name as item_name , t1.quantity * i.price  as item_expense ,         
               s.item_quantity * i.price as stock_expense
	from  item_prices i , stock_left s ,
	      (select d.item_name , sum(d.item_quantity) as quantity
		from daily_stock_usage d
		where  d.school_id = schoolID and extract(MONTH from d.date) = monthNum 
                      and extract(YEAR FROM d.date) = yearNum
		group by d.item_name ) as t1 
	where t1.item_name = i.item_name and t1.item_name = s.item_name 
          and s.school_id = schoolID and i.city_id = (select city_id from school where school_id=schoolID)        
          and s.month = monthNum and s.year = yearNum and i.month = monthNum and i.year = yearNum ;
end;
$BODY$;


/*--------------------------------------------------------------------------*/

-- 4.MONTHLY OVERALL FOOD EXPENSES,COOK SALARIES OF A SCHOOL
CREATE OR REPLACE FUNCTION public.school_monthly_expenses_func( schoolid integer, month integer, year integer)
RETURNS TABLE(total_cook_salary numeric, 
              food_used_expense numeric, 
              stock_left_expense numeric) 
LANGUAGE 'plpgsql'
AS $BODY$
begin
	return query 
	select salary_table.c_salary , expenses_table.fe , expenses_table.sle
	from (select  sum(c.salary) as c_salary
		  from cook c
		  group by c.school_id 
		  having c.school_id = schoolID) as salary_table , 
	     (select sum(t2.item_expense) as fe , sum(t2.stock_expense) as sle
	      from (select * from school_monthly_item_expenses_func(schoolID , month , year)) as t2)  as expenses_table ;
end;
$BODY$;


/*--------------------------------------------------------------------------*/

-- 5.SCHOOL OVERALL MONTHLY DATA
CREATE OR REPLACE FUNCTION public.school_dashboard(schoolid_num integer, monthnum integer, yearnum integer)
RETURNS TABLE( schoolid integer, 
               students_registered integer, 
               meals_served integer, 
               monthly_expenses numeric, 
               stock_left_expense numeric, 
               inspection_count integer, 
               grievances_count integer) 
 LANGUAGE 'plpgsql'
AS $BODY$
begin
return query
select m.school_id, m.primary_enrollment+ m.secondary_enrollment as students_enrolled,    
       t1.total_enrolled, t2.total_cook_salary+ t2.food_used_expense as monthly_expenses,   
       t2.stock_left_expense as stock_left_expense , t3.coalesce as inspection_count, 
       t4.coalesce as grivances_count
from mdm_school_committee m,
(   select a.school_id, cast(sum(a.mdm_primary_attendance + a.mdm_secondary_attendance) as integer)    
                        total_enrolled
    from student_attendance a
    where (extract (month from a.date) = monthNum) and extract (year from date) = yearNum
    group by school_id
    having a.school_id = schoolID_num 
) as t1,
(   select * from school_monthly_expenses_func(schoolID_num, monthNum,yearNum)
) as t2,
(   select cast( coalesce ((select count(date) 
    from inspection_feedback
    group by school_id , inspection_feedback.date 
    having school_id = schoolID_num and extract (month from inspection_feedback.date) = monthNum 
            and extract (year from inspection_feedback.date) = yearNum) , 0) as integer) 
) as t3,
(   select cast ( coalesce( (select count(complaint_id)
    from grievances
    group by school_id , grievances.date
    having school_id = schoolID_num and extract (month from grievances.date) = monthNum 
    and extract (year from grievances.date) = yearNum ) , 0) as integer)
) as t4
where m.school_id = schoolID_num;
end;
$BODY$;


/*--------------------------------------------------------------------------*/

-- 6.ALL THE SCHOOLS DATA UNDER A DISTRICT IN THE GIVEN MONTH
CREATE OR REPLACE FUNCTION public.get_schools_data(districtid integer,month integer,year integer)
RETURNS TABLE( schoolid integer, 
               students_registered integer, 
               meals_served integer, 
               monthly_expenses numeric, 
               stock_left_expenses numeric, 
               inspection_count integer, 
               grievances_count integer) 
LANGUAGE 'plpgsql'
AS $BODY$
declare
	school_num integer;
begin
	for school_num in (Select school_id from school where district_id = districtID)
	loop
    	return query select * from school_dashboard(school_num, month, year);
	end loop;
end;
$BODY$;