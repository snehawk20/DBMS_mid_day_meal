\COPY district_committee(district_id,district_name,officer_id,officer_name,schools_registered,mdm_budget,total_budget)
FROM 'district_committee.csv'
DELIMITER ','
CSV HEADER;

\COPY city_committee (city_id,district_id,city_name,officer_id,officer_name,schools_registered,mdm_budget,total_budget)
FROM 'city_committee.csv'
DELIMITER ','
CSV HEADER;

\COPY school(school_id,school_name,principal_name,contact_number,email,school_type,city_id,district_id,primary_strength,secondary_strength,mdm_enrollment)
FROM 'school.csv'
DELIMITER ','
CSV HEADER;

\COPY student(student_id,school_id,student_name,standard,height,weight,mdm_enrollment)
FROM 'student.csv'
DELIMITER ','
CSV HEADER;

\COPY student_attendance(school_id,date,mdm_primary_attendance,mdm_secondary_attendance)
FROM 'student_attendance.csv'
DELIMITER ','
CSV HEADER;

\COPY cook(cook_id,cook_name,salary,school_id)
FROM 'cook.csv'
DELIMITER ','
CSV HEADER;

\COPY inspection_feedback(date,school_id,feedback)
FROM 'inspection_feedback.csv'
DELIMITER ','
CSV HEADER;

\COPY item_prices(item_name,price,month,year,city_id)
FROM 'item_prices.csv'
DELIMITER ','
CSV HEADER;

\COPY grievances(complaint_id,school_id,category,description,status,date,actions_taken)
FROM 'grievances.csv'
DELIMITER ','
CSV HEADER;

\COPY mdm_school_committee(school_id,manager_id,manager_name,budget,primary_enrollment,secondary_enrollment)
FROM 'mdm_school_committee.csv'
DELIMITER ','
CSV HEADER;

\COPY district_static(district_id,day,items)
FROM 'district_static.csv'
DELIMITER ','
CSV HEADER;

\COPY daily_stock_usage(school_id,item_name,item_quantity,date)
FROM 'daily_stock_usage.csv'
DELIMITER ','
CSV HEADER;

\COPY stock_left(school_id,item_name,item_quantity,month,year)
FROM 'stock_left.csv'
DELIMITER ','
CSV HEADER;