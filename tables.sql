-- tables and basic constraints

create table district_committee(
    district_id int primary key,
    district_name varchar,
    officer_id int,
    officer_name varchar,
    schools_registered int,
    mdm_budget decimal check (mdm_budget > 0)
);

create table city_committee(
    city_id int primary key,
    district_id int,
    city_name varchar not null,
    officer_id int,
    officer_name varchar,
    schools_registered int,
    mdm_budget decimal check (mdm_budget >= 0),
    constraint fk_city_committee_district_committee foreign key (district_id)
    references district_committee (district_id)
);

create type school_category as enum ('govt-aided', 'govt', 'private', 'central');

create table school(
    school_id int primary key,
    school_name varchar,
    principal_name varchar,
    contact_number varchar,
    email varchar,
    school_type school_category,
    city_id int,
    district_id int,
    account_number varchar,
    primary_strength int check (primary_strength >= 0),
    secondary_strength int check (secondary_strength >= 0),
    mdm_enrollment bool,
    constraint fk_school_city_committee foreign key (city_id)
    references city_committee (city_id),
    constraint fk_school_district_committee foreign key (district_id)
    references district_committee (district_id)
);

create table student(
    student_id int not null,
    school_id int not null,
    student_name varchar not null,
    standard int check(standard >= 1 and standard <= 12) ,
    height decimal,
    weight decimal,
    mdm_enrollment boolean,
    primary key (student_id, school_id),
    constraint fk_student_school foreign key (school_id)
    references school (school_id)
);

create table student_attendance(
    school_id int not null,
    date date not null,
    mdm_primary_attendance int,
    mdm_secondary_attendance int,
    -- secondary_attendance int,
    -- primary_attendance int,
    -- holiday bool,
    primary key (school_id, date),
    constraint fk_student_attendance_school foreign key (school_id)
    references school (school_id)
);

create table cook(
    cook_id int primary key,
    cook_name varchar,
    salary decimal check (salary > 0),
    school_id int,
    constraint fk_cook_school foreign key (school_id)
    references school (school_id)
);

create table payment(
    transaction_id int primary key,
    date date not null,
    school_id int,
    receiver_account varchar not null,
    sender_account varchar not null,
    amount decimal not null check (amount > 0),
    constraint fk_payment_school foreign key (school_id)
    references school (school_id),
    check (sender_account <> receiver_account)
);

create table inspection_feedback(
    date date,
    school_id int,
    -- officer_id int,
    feedback varchar,
    primary key (date, school_id),
    constraint fk_inspection_feedback_school foreign key (school_id)
    references school (school_id)
);

create table item_prices(
    item_name varchar,
    price decimal not null check (price > 0),
    month int not null check (month >= 1 and month <= 12),
    year int not null,
    city_id int,
    primary key (item_name, month, year, city_id),
    constraint fk_item_prices_city_committee foreign key (city_id)
    references city_committee (city_id)
);

create type grievance_category as enum ('general', 'miscellaneous',
            'quantity', 'quality', 'food contamination', 'hygiene');

create type grievance_status as enum ('resolved', 'progressing', 'new');

create table grievances(
    complaint_id int,
    school_id int,
    category grievance_category not null,
    description varchar,
    proof varchar,
    status grievance_status not null,
    date date,
    phone_no varchar,
    actions_taken varchar,
    primary key (complaint_id, school_id),
    constraint fk_grievances_school foreign key (school_id)
    references school (school_id)
);

create table mdm_school_committee(
    school_id int primary key,
    manager_id int,
    manager_name varchar,
    -- teacher_id int,
    -- teacher_name varchar,
    budget decimal not null check (budget >= 0),
    primary_enrollment int not null check (primary_enrollment >= 0),
    secondary_enrollment int not null check (secondary_enrollment >= 0),
    constraint fk_mdm_committee_school foreign key (school_id)
    references school (school_id)
);

create type menu_day as enum ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');

create table district_static(
    district_id int,
    day menu_day,
    items text[],
    primary key (district_id, day),
    constraint fk_district_static_district_committee foreign key(district_id)
    references district_committee (district_id)
);

create table daily_stock_usage(
    school_id int,
    item_name varchar,
    item_quantity decimal check (item_quantity >= 0),
    date date,
    primary key (school_id, item_name, date),
    constraint fk_daily_stock_usage_school foreign key (school_id)
    references school (school_id),
    -- constraint fk_daily_stock_usage_item_prices foreign key (item_name)
    -- references item_prices (item_name)
);

create table stock_left(
    school_id int,
    item_name varchar,
    item_quantity decimal not null check (item_quantity >= 0),
    month int,
    year int,
    primary key (school_id, item_name, month, year),
    constraint fk_stock_left_school foreign key (school_id)
    references school (school_id)
);

-- now have to create triggers to check extra constraints