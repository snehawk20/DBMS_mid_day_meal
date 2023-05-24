-- VIEWS

-- 1. bmi calculation
CREATE OR REPLACE VIEW public.bmi_calculation
AS
SELECT student.school_id, student.student_id, student.student_name,
       student.weight * 100::numeric * 100::numeric / (student.height * student.height) AS bmi,
       CASE
           WHEN(student.weight*100::numeric*100::numeric /(student.height*student.height)) < 18.5   
                THEN 'underweight'::text
           WHEN (student.weight*100::numeric*100::numeric/(student.height*student.height))>= 18.5   
            AND (student.weight*100::numeric *100::numeric/(student.height*student.height))<=24.9 
                THEN 'healthy-weight'::text
           WHEN(student.weight*100::numeric*100::numeric /(student.height*student.height)) > 24.9 
            AND (student.weight*100::numeric*100::numeric /(student.height*student.height))<=29.9 
                THEN 'overweight'::text
           WHEN(student.weight*100::numeric*100::numeric /(student.height*student.height)) > 29.9 
                THEN 'obese'::text
           ELSE NULL::text
        END AS category
FROM student
WHERE bmi_view_rls_policy(CURRENT_USER::text, student.school_id);


-- This is a policy function for the bmi_view to allow users access according to their role
CREATE OR REPLACE FUNCTION public.bmi_view_rls_policy(cur_user text, schoolid integer)
RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
declare 
	new_id integer ;
	role_name varchar ;
begin
	select rolname into role_name from pg_user
	join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
	join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
	where
	pg_user.usename=cur_user;
  
  	if (role_name = 'school_role')
	then 
		select cast(trim(leading 'school_manager' from current_user) as integer) into new_id ;
		
		if(schoolid = new_id)
		then
			return true;
		else
			return false;
		end if;
	elsif(role_name = 'city_role')
	then
		select cast(trim(leading 'city_officer' from current_user) as integer) into new_id ;
		
		if(schoolid in (select school_id from school where city_id = new_id))
		then
			return true;
		else
			return false;
		end if;
	elsif (role_name = 'district_role')
	then
		select cast(trim(leading 'district_officer' from current_user) as integer) into new_id;
		
		if(schoolid in (select school_id from school where district_id = new_id))
		then
			return true;
		else
			return false;
		end if;
	end if;
end;
$BODY$;


/*--------------------------------------------------------------------------*/

-- Similar kinds of policy functions can be created for other views too

-- VIEW 2:  All the required basic school details that a city officer needs to know about a school
CREATE VIEW city_officer_view AS
( SELECT school_id, manager_id, manager_name, budget,   
         primary_enrollment+secondary_enrollment as students_enrolled, 
         t1.count as grievances_registered
  from mdm_school_committee, (select count(complaint_id) from grievances) as t1 );
  

/*--------------------------------------------------------------------------*/
 
-- VIEW 3 : This can be used to verify attendance of schools by higher officers at the end of each month
CREATE VIEW school_attendance AS
( SELECT t1.school_id,t1.school_name, t1.primary_percent *100 as primary_attendance,  t1.secondary_percent*100 as secondary_attendance
  FROM (SELECT s.school_id, s.school_name , 
        AVG(a.mdm_primary_attendance)/sum(primary_strength) as primary_percent , 
        AVG(a.mdm_secondary_attendance)/sum(s.secondary_strength) as secondary_percent
        FROM student_attendance a, school s
        where (extract (month from a.date) = extract(month from CURRENT_DATE) 
               and extract(year from a.date) = extract (year from CURRENT_DATE))
        group by (s.school_id)) as t1 );
