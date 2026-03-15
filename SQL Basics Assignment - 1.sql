-- SQL Basics Assignment - 1 --

-- Q1. Create a New Database and Table for Employees -- 
-- TASK: Create a new database named company_db and create a table named employees with the following columns: --

create database company_db;
use company_db;

create table employees(
employee_id int primary key,
first_name varchar(50),
last_name varchar(50),
department varchar(50),
salary int,
hire_date date
);

select * from employees;

-- Q2. Insert Data into Employees Table -- 
-- TASK: Insert the following sample records into the employees table -- 

insert into employees values(101, 'Amit', 'Sharma', 'HR', 50000, '2020-01-15'),
(102, 'Riya', 'Kapoor', 'Sales', 75000, '2019-03-22'),
(103, 'Raj', 'Mehta', 'IT', 90000, '2018-07-11'),
(104, 'Neha', 'Verma', 'IT', 85000, '2021-09-01'),
(105, 'Arjun', 'Singh', 'Finance', 60000, '2022-02-10');

select * from employees;

-- Q3. Display All Employee Records sorted by Salary(Lowest to Highest)
-- TASK: Insert the following sample records into the employees table. --

select * from employees order by salary asc;

-- Q4. Show Employees sorted by Department(A-Z) and Salary(High-Low)

select * from employees order by department asc, salary desc;

-- Q5. List all Employees in the IT Department, ordered by hire date(newest first)

select * from employees
where department = 'IT'
order by hire_date desc;

-- Q6. Create and Populate a sales table -- 

create table sales(
sale_id int,
customer_name varchar(25),
amount int,
sale_date varchar(20)
);

insert into sales values(1, 'Aditi', 1500, '2024-08-01'),
(2, 'Rohan', 2200, '2024-08-03'),
(3, 'Aditi', 3500, '2024-09-05'),
(4, 'Meena', 2700, '2024-09-15'),
(5, 'Rohan', 4500, '2024-09-25');

select * from sales;

-- Q7. Display all sales Records sorted by Amount(Highest to Lowest)

select * from sales order by amount desc;

-- Q8. Show all sales made by customer 'Aditi' --

select * from sales where customer_name  = 'Aditi';

-- Q9. What is the difference between a primary key and a foreign key --

/* 
Ans. A Primary key uniquely identifies each row in a table,
while a foreign key establishes a relationship between two
tables by referencing the primary key of another table. 

Properties of Primary Key:
1. Must be Unique
2. Cannot contain NULL vlaues
3. Each table can have almost every time one primary key

Properties of Foreign key:
1. Can contain duplicate values
2. Can contain NULL values
3. A table can have multiple foreign keys. 

*/

-- Q10. What are the constraints in SQL and why are they used? --

/*
Ans. Constraints in SQL are rules applied to table columns
that enforce data integrity, accuracy and consistency. They
prevent invalid data from being entered and ensure the 
database follows business logic.

It used because:
Ensure data validity - Prevents incorrect and inconsistent values.
Maintain Integrity - Enforces relationships between tables
Improve reliability - Guarantees that stored data meets defined rules
Automate checks - Saves developers from writing manual validation logic.

Types of SQL Constraints
NOT NULL - It insures a column can not have NULL values.
UNIQUE - It insures all values in a column are distinct 
PRIMARY KEY - Uniquely identifies each row in a table.
FOREIGN KEY - Links one table to another, enforcing
referential integrity
CHECK -  It ensures values meet a condition
DEFAULT - Assign a default value if none is provided
*/

