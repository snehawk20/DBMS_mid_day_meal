-- makes joins efficient
-- used in calc_extra_budget()
create index city_committee_district_fkey on city_committee using hash (district_id);

-- school_monthly_expenses_func() needs it
create index cook_school_id_fkey on cook using hash (school_id);

-- above two are not high priority index

-- date is part of the composite primary key
-- but date is used most often and applied on the already created views
-- of the respective schools (schol_id is already filtered for the school users)
-- for range based queries, this is more efficient

-- check with explain analyze before creating any query
create index daily_stock_usage_date on daily_stock_usage using btree (date);

-- function school_monthly_item_expenses_func()
-- the primary key index will deal with it (mostly)

-- no need to index on grievances or inspection feedback
-- nobody checks it that often

