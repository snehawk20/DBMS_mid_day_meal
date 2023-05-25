# Mid Day Meal Management System

## Description
The objective of our project is to create a self-sufficient database to store all details pertaining to the budget allocation and expenditure on remuneration and procurement of fresh produce, cereals, pulses, etc. There are several levels of users with the lowest being school which micromanages the activities and updates the records daily. The database will be succinct and provide a smooth interface to ensure that resources are being used efficiently and not mis-used. Since it holds all data for a state, it will deal with huge quantities of data over the long run and be more efficient that maintaining it in paper (as is done in many places today). This system will give schools the liberty to take decisions at the local level while maintaining transparency in the allocation of resources. It can also enable efficient resource distribution from government storage facilities. 

We shall store stock, enrollment of students, audit details, details on prices and items and daily logs.

## Installation
* Login to your `psql` client as user `postgres`
    sudo -u postgres psql
* Create the roles as follows:  
    create role city_role;  
    create role school_role;  
    create role district_role;
* Create a database named `mdm`  
    create database mdm;
* Exit the `psql` client and restore the `mdm.tar` file  
    pg_restore -U postgres -d mdm <<i>path to tar file</i>>
* Again login to your `psql` client as user `postgres`
* Create roles for users with login
    * There are three kinds of roles: district, city and school
    * They should be named as district_officer<<i>num</i>>, city_officer<<i>num</i>> and school_manager<<i>num</i>>
    * Where <<i>num</i>> is the respective `district_id`, `city_id` and `school_id`  
        create role district_officer2 with login password '`<<i>password</i>>`';
    * Grant the roles the associated permissions of `district_role`, `city_role` and `school_role` respectively  
        grant district_role to district_officer4;

  

## Schema
![Schema](https://github.com/snehawk20/DBMS_mid_day_meal/blob/main/schema.jpg)