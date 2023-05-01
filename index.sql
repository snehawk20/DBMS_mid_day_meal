-- makes joins efficient
create index city_committee_district_fkey on city_committee using hash (district_id);

create index cook_school_id_fkey on cook using hash (school_id);

