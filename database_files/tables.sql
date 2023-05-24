-- TABLES

-- 1.District Committee
CREATE TABLE IF NOT EXISTS public.district_committee
(
    district_id integer NOT NULL,
    district_name character varying COLLATE pg_catalog."default",
    officer_id integer,
    officer_name character varying COLLATE pg_catalog."default",
    schools_registered integer,
    mdm_budget numeric,
    total_budget numeric,
    CONSTRAINT district_committee_pkey PRIMARY KEY (district_id),
    CONSTRAINT district_committee_mdm_budget_check CHECK (mdm_budget > 0::numeric),
    CONSTRAINT district_committee_total_budget_check CHECK (total_budget >= 0::numeric)
)

-- 2. City Committee
CREATE TABLE IF NOT EXISTS public.city_committee
(
    city_id integer NOT NULL,
    district_id integer,
    city_name character varying COLLATE pg_catalog."default" NOT NULL,
    officer_id integer,
    officer_name character varying COLLATE pg_catalog."default",
    schools_registered integer,
    mdm_budget numeric,
    total_budget numeric,
    CONSTRAINT city_committee_pkey PRIMARY KEY (city_id),
    CONSTRAINT city_district_unique_constraint UNIQUE (city_id, district_id),
    CONSTRAINT fk_city_committee_district_committee FOREIGN KEY (district_id)
        REFERENCES public.district_committee (district_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT city_committee_mdm_budget_check CHECK (mdm_budget >= 0::numeric),
    CONSTRAINT city_committee_total_budget_check CHECK (total_budget >= 0::numeric)
)

-- 3.School
CREATE TABLE IF NOT EXISTS public.school
(
    school_id integer NOT NULL,
    school_name character varying COLLATE pg_catalog."default",
    principal_name character varying COLLATE pg_catalog."default",
    contact_number character varying COLLATE pg_catalog."default",
    email character varying COLLATE pg_catalog."default",
    school_type school_category,
    city_id integer,
    district_id integer,
    primary_strength integer,
    secondary_strength integer,
    mdm_enrollment boolean,
    CONSTRAINT school_pkey PRIMARY KEY (school_id),
    CONSTRAINT fk_school_city_district FOREIGN KEY (city_id, district_id)
        REFERENCES public.city_committee (city_id, district_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT school_primary_strength_check CHECK (primary_strength >= 0),
    CONSTRAINT school_secondary_strength_check CHECK (secondary_strength >= 0),
    CONSTRAINT contact_number_constraint_school CHECK (contact_number::text ~ similar_escape('[1-9]{1}[0-9]{9}'::text, NULL::text)),
    CONSTRAINT email_constraint_school CHECK (email::text ~ similar_escape('[a-zA-Z_]+[.](org)[.](in)'::text, NULL::text))
)

-- 4.MDM School Committee
CREATE TABLE IF NOT EXISTS public.mdm_school_committee
(
    school_id integer NOT NULL,
    manager_id integer,
    manager_name character varying COLLATE pg_catalog."default",
    budget numeric NOT NULL,
    primary_enrollment integer NOT NULL,
    secondary_enrollment integer NOT NULL,
    CONSTRAINT mdm_school_committee_pkey PRIMARY KEY (school_id),
    CONSTRAINT fk_mdm_committee_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT mdm_school_committee_budget_check CHECK (budget >= 0::numeric),
    CONSTRAINT mdm_school_committee_primary_enrollment_check CHECK (primary_enrollment >= 0),
    CONSTRAINT mdm_school_committee_secondary_enrollment_check CHECK (secondary_enrollment >= 0)
)

-- 5.Cook
CREATE TABLE IF NOT EXISTS public.cook
(
    cook_id integer NOT NULL,
    cook_name character varying COLLATE pg_catalog."default",
    salary numeric,
    school_id integer,
    CONSTRAINT cook_pkey PRIMARY KEY (cook_id),
    CONSTRAINT fk_cook_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT cook_salary_check CHECK (salary > 0::numeric)
)

-- 6.Student
CREATE TABLE IF NOT EXISTS public.student
(
    student_id integer NOT NULL,
    school_id integer NOT NULL,
    student_name character varying COLLATE pg_catalog."default" NOT NULL,
    standard integer,
    height numeric,
    weight numeric,
    mdm_enrollment boolean,
    CONSTRAINT student_pkey PRIMARY KEY (student_id, school_id),
    CONSTRAINT fk_student_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT student_standard_check CHECK (standard >= 1 AND standard <= 12)
)

-- 7.Student Attendance
CREATE TABLE IF NOT EXISTS public.student_attendance
(
    school_id integer NOT NULL,
    date date NOT NULL,
    mdm_secondary_attendance integer,
    mdm_primary_attendance integer,
    CONSTRAINT student_attendance_pkey PRIMARY KEY (school_id, date),
    CONSTRAINT fk_student_attendance_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT primary_attendance_constraint CHECK (mdm_primary_attendance >= 0),
    CONSTRAINT secondary_attendance_constraint CHECK (mdm_secondary_attendance >= 0)
)

-- 8.Grievances
CREATE TABLE IF NOT EXISTS public.grievances
(
    complaint_id integer NOT NULL,
    school_id integer NOT NULL,
    category grievance_category NOT NULL,
    description character varying COLLATE pg_catalog."default",
    status grievance_status NOT NULL,
    date date,
    actions_taken character varying COLLATE pg_catalog."default" DEFAULT 'nil'::character varying,
    CONSTRAINT grievances_pkey PRIMARY KEY (complaint_id, school_id),
    CONSTRAINT fk_grievances_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT date_check_constraint_greivances CHECK (date <= CURRENT_DATE)
)

-- 9.District Static
CREATE TABLE IF NOT EXISTS public.student_attendance
(
    school_id integer NOT NULL,
    date date NOT NULL,
    mdm_secondary_attendance integer,
    mdm_primary_attendance integer,
    CONSTRAINT student_attendance_pkey PRIMARY KEY (school_id, date),
    CONSTRAINT fk_student_attendance_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT primary_attendance_constraint CHECK (mdm_primary_attendance >= 0),
    CONSTRAINT secondary_attendance_constraint CHECK (mdm_secondary_attendance >= 0)
)

-- 10.Item Prices
CREATE TABLE IF NOT EXISTS public.item_prices
(
    item_name character varying COLLATE pg_catalog."default" NOT NULL,
    price numeric NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    city_id integer NOT NULL,
    CONSTRAINT item_prices_pkey PRIMARY KEY (item_name, month, year, city_id),
    CONSTRAINT fk_item_prices_city_committee FOREIGN KEY (city_id)
        REFERENCES public.city_committee (city_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT item_prices_price_check CHECK (price > 0::numeric),
    CONSTRAINT item_prices_month_check CHECK (month >= 1 AND month <= 12)
)

-- 11.Inspection Feedback
CREATE TABLE IF NOT EXISTS public.inspection_feedback
(
    date date NOT NULL,
    school_id integer NOT NULL,
    feedback character varying COLLATE pg_catalog."default" DEFAULT 'nil'::character varying,
    CONSTRAINT inspection_feedback_pkey PRIMARY KEY (date, school_id),
    CONSTRAINT fk_inspection_feedback_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT date_check_constraint CHECK (date <= CURRENT_DATE)
)

-- 12.Daily Stock Usage
CREATE TABLE IF NOT EXISTS public.daily_stock_usage
(
    school_id integer NOT NULL,
    item_name character varying COLLATE pg_catalog."default" NOT NULL,
    item_quantity numeric,
    date date NOT NULL,
    CONSTRAINT daily_stock_usage_pkey PRIMARY KEY (school_id, item_name, date),
    CONSTRAINT fk_daily_stock_usage_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT daily_stock_usage_item_quantity_check CHECK (item_quantity >= 0::numeric)
)

-- 13.Stock Left
CREATE TABLE IF NOT EXISTS public.stock_left
(
    school_id integer NOT NULL,
    item_name character varying COLLATE pg_catalog."default" NOT NULL,
    item_quantity numeric NOT NULL,
    month integer NOT NULL,
    year integer NOT NULL,
    CONSTRAINT stock_left_pkey PRIMARY KEY (school_id, item_name, month, year),
    CONSTRAINT fk_stock_left_school FOREIGN KEY (school_id)
        REFERENCES public.school (school_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT stock_left_item_quantity_check CHECK (item_quantity >= 0::numeric)
)