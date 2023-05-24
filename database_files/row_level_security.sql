-- ROW LEVEL SECURITY POLICIES ON VARIOUS TABLES

alter table school enable row level security ;
alter table student enable row level security ;
alter table student_attendance enable row level security ;
alter table mdm_school_committee enable row level security ;
alter table cook enable row level security ;
alter table daily_stock_usage enable row level security ;
alter table stock_left enable row level security ;
alter table grievances enable row level security ;
alter table district_static enable row level security ;
alter table item_prices enable row level security ;
alter table inspection_feedback enable row level security ;
alter table city_committee enable row level security ;
alter table district_committee enable row level security ;

-- 1. School table
CREATE POLICY district_role_policy1
    ON public.school
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))
    WITH CHECK ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer));

CREATE POLICY city_role_policy1
    ON public.school
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))
    WITH CHECK ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer));

CREATE POLICY school_role_policy1
    ON public.school
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 2. MDM School Committee Table
CREATE POLICY district_role_policy1
    ON public.mdm_school_committee
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY city_role_policy1
    ON public.mdm_school_committee
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.mdm_school_committee
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 3. Daily Stock Usage
CREATE POLICY city_role_policy1
    ON public.daily_stock_usage
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.daily_stock_usage
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.daily_stock_usage
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 4. Stock Left
CREATE POLICY city_role_policy1
    ON public.stock_left
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.stock_left
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.stock_left
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 5. Student
CREATE POLICY city_role_policy1
    ON public.student
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.student
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.student
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 6. Student Attendance
CREATE POLICY city_role_policy1
    ON public.student_attendance
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.student_attendance
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.student_attendance
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));


/*--------------------------------------------------------------------------*/

-- 7. Grievances
CREATE POLICY city_role_policy1
    ON public.grievances
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.grievances
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.grievances
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));
	
	
/*--------------------------------------------------------------------------*/

-- 8. Inspection Feedback
CREATE POLICY city_role_policy1
    ON public.inspection_feedback
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.inspection_feedback
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.inspection_feedback
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));
	
	
	
/*--------------------------------------------------------------------------*/

-- 9. Cook
CREATE POLICY city_role_policy1
    ON public.cook
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.cook
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((school_id IN ( SELECT school.school_id
   FROM school
  WHERE (school.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.cook
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))
    WITH CHECK ((school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer));
	

/*--------------------------------------------------------------------------*/

-- 10. City Committee
CREATE POLICY city_role_policy1
    ON public.city_committee
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))
    WITH CHECK ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer));

CREATE POLICY district_role_policy1
    ON public.city_committee
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))
    WITH CHECK ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer));

CREATE POLICY school_role_policy1
    ON public.city_committee
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((city_id = ( SELECT school.city_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))))
    WITH CHECK ((city_id = ( SELECT school.city_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))));
  
  
/*--------------------------------------------------------------------------*/

-- 11. District Committee
CREATE POLICY city_role_policy1
    ON public.district_committee
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((district_id = ( SELECT city_committee.district_id
   FROM city_committee
  WHERE (city_committee.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((district_id = ( SELECT city_committee.district_id
   FROM city_committee
  WHERE (city_committee.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.district_committee
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))
    WITH CHECK ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer));

CREATE POLICY school_role_policy1
    ON public.district_committee
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((district_id = ( SELECT school.district_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))))
    WITH CHECK ((district_id = ( SELECT school.district_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))));
  
  
/*--------------------------------------------------------------------------*/

-- 12. Item Prices
CREATE POLICY city_role_policy1
    ON public.item_prices
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))
    WITH CHECK ((city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer));

CREATE POLICY district_role_policy1
    ON public.item_prices
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((city_id IN ( SELECT city_committee.city_id
   FROM city_committee
  WHERE (city_committee.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))))
    WITH CHECK ((city_id IN ( SELECT city_committee.city_id
   FROM city_committee
  WHERE (city_committee.district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))));

CREATE POLICY school_role_policy1
    ON public.item_prices
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((city_id = ( SELECT school.city_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))))
    WITH CHECK ((city_id = ( SELECT school.city_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))));
  

/*--------------------------------------------------------------------------*/

-- 13. District Static
CREATE POLICY city_role_policy1
    ON public.district_static
    AS PERMISSIVE
    FOR ALL
    TO city_role
    USING ((district_id = ( SELECT city_committee.district_id
   FROM city_committee
  WHERE (city_committee.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))))
    WITH CHECK ((district_id = ( SELECT city_committee.district_id
   FROM city_committee
  WHERE (city_committee.city_id = (ltrim((CURRENT_USER)::text, 'city_officer'::text))::integer))));

CREATE POLICY district_role_policy1
    ON public.district_static
    AS PERMISSIVE
    FOR ALL
    TO district_role
    USING ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer))
    WITH CHECK ((district_id = (ltrim((CURRENT_USER)::text, 'district_officer'::text))::integer));

CREATE POLICY school_role_policy1
    ON public.district_static
    AS PERMISSIVE
    FOR ALL
    TO school_role
    USING ((district_id = ( SELECT school.district_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))))
    WITH CHECK ((district_id = ( SELECT school.district_id
   FROM school
  WHERE (school.school_id = (ltrim((CURRENT_USER)::text, 'school_manager'::text))::integer))));
