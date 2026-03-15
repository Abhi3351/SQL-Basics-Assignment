create database sample_db;

use sample_db;

create table Employees(
EmpID int primary key,
EmpName varchar(50),
Department varchar(20),
City varchar(10),
Salary int,
HireDate date
);

insert into Employees values(101, 'Rahul Mehta', 'Sales', 'Delhi', 55000, '2020-04-12'),
(102, 'Priya Sharma', 'HR', 'Mumbai', 62000, '2019-09-25'),
(103, 'Aman Singh', 'IT', 'Bengaluru', 72000, '2021-03-10'),
(104, 'Neha Patel', 'Sales', 'Delhi', 48000, '2022-01-14'),
(105, 'Karan Joshi', 'Marketing', 'Pune', 45000, '2018-07-22'),
(106, 'Divya Nair', 'IT', 'Chennai', 81000, '2019-12-11'),
(107, 'Raj Kumar', 'HR', 'Delhi', 60000, '2020-05-28'),
(108, 'Simran Kaur', 'Finance', 'Mumbai', 58000, '2021-08-03'),
(109, 'Anjali Das', 'Sales', 'Kolkata', 51000, '2023-01-15');

select * from Employees;

-- Q1. Show employees working in either the 'IT' or 'HR' departments. --

select * from Employees 
where department IN ('IT', 'HR');

-- Q2. Retrieve employees whose department is in ‘Sales’, ‘IT’, or ‘Finance’.

select * from Employees
where Department IN('Sales', 'IT', 'Finance');

-- Q3. Display employees whose salary is between ₹50,000 and ₹70,000. --

select * from Employees
where salary between 50000 and 70000;

-- Q4.  List employees whose names start with the letter ‘A’. --

select * from Employees 
where EmpName LIKE 'A%';

-- Q5. Find employees whose names contain the substring ‘an’. --

select * from Employees
where EmpName LIKE '%an%';

-- Q6. Show employees who are from ‘Delhi’ or ‘Mumbai’ and earn more than ₹55,000. --

select * from Employees
where City IN ('Delhi', 'Mumbai')
AND salary > 55000;

-- Q7. Display all employees except those from the ‘HR’ department.--

select * from Employees
where not department = 'HR';

-- Q8.  Get all employees hired between 2019 and 2022, ordered by HireDate (oldest first) --

select * from Employees
where HireDate between '2019-01-01' and '2022-12-31'
order by HireDate ASC;