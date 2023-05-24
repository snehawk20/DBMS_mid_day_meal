-- INDEXES 

-- 1. city_committee_district_fkey 
create index city_committee_district_fkey on city_committee using hash (district_id);


-- 2. daily_stock_usage_date
create index daily_stock_usage_date on daily_stock_usage using btree (date, school_id);


-- 3. idx_grievances_status
create index idx_grievances_status on grievances(status) where status = 'progressing' or status = 'new';


-- 4.idx_cook_school_id_fkey
create index idx_cook_school_id_fkey on cook using hash (school_id);

