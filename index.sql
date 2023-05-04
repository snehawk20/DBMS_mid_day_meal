-- 1
-- makes joins efficient
-- used in calc_extra_budget()
-- appoved
create index city_committee_district_fkey on city_committee using hash (district_id);

-- school_monthly_expenses_func() needs it
-- this one is increasing time taken
-- create index cook_school_id_fkey on cook using hash (school_id);

-- above two are not high priority index

-- date is part of the composite primary key
-- but date is used most often and applied on the already created views
-- of the respective schools (school_id is already filtered for the school users)
-- for range based queries, this is more efficient

-- 2
-- check with explain analyze before creating any query
-- school dashboard requires month and year extracted from date
-- after a lookup on solely date
create index daily_stock_usage_date on daily_stock_usage using btree (date);

-- function school_monthly_item_expenses_func()
-- the primary key index will deal with it (mostly)

-- no need to index on grievances or inspection feedback
-- nobody checks it that often

-- SELECT     s.school_name,
-- mdm.manager_name, c.officer_name, d.officer_name
-- FROM    	 school as s, city_committee as c,
-- district_committee as d, mdm_school_committee as mdm
-- WHERE     s.school_id = mdm.school_id and s.city_id = c.city_id
-- and c.district_id = d.district_id;
-- create a concatenated index on district_id and city_id of school
-- create index school_district_id_city_id on school using hash (city_id, district_id);

create index idx_grievances_status on grievances(status) where status = 'progressing' or status = 'new';

create index idx_dates on daily_stock_usage(date) include (extract (month from date));

create index idx_cook_school_id_fkey on cook using hash (school_id);