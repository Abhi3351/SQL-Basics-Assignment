-- Assignment Questions --

create database Subqueries;

use Subqueries;

#Create Department table...
create table Department(
department_id varchar(10) primary key,
department_name varchar(10),
location varchar(10)); 

#Create Employee table...
create table Employee(
emp_id int primary key, 
name varchar(20),
department_id varchar(10),
salary int,
foreign key (department_id) 
references Department(department_id));

#Create Sales table...
create table Sales(
sale_id int primary key,
emp_id int,
sale_amount int,
sale_date date,
foreign key (emp_id) 
references Employee(emp_id));


#Insert Data into tables..

#1. Department Dataset...

insert into Department values(
'D01', 'Sales', 'Mumbai'),
('D02', 'Marketing', 'Delhi'),
('D03', 'Finance', 'Pune'),
('D04', 'HR', 'Bangaluru'),
('D05', 'IT', 'Hyderabad');

#2. Employee Dataset...

insert into Employee values(
101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);

#3. Sales Dataset...

insert into Sales values(
201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');


#Basic Level

#1. Retrieve the names of employees who earn more than 
#   the average salary of all employees.

select * from employee;

select avg(salary) 
from employee;

select emp_id, 
       name, 
       salary
from employee
where salary > (
      select avg(salary) 
      from employee);
 
 
#2. Find the employees who belong to the department
#   with the highest average salary.

select * from department;
select * from employee;

#Find Department wise average salary
select Department_id, 
       avg(salary) as avg_salary
from employee
group by Department_id;

#Find Maximum average salary
select max(avg_salary)
from (select Department_id, 
	  avg(salary) as avg_salary
from employee
group by Department_id) as dept_avg;

#Find Department id which has maximum average salary
select department_id
from employee
group by department_id
having avg(salary) = (select max(avg_salary)
                      from (select Department_id, 
                            avg(salary) as avg_salary
                            from employee
							group by Department_id) as dept_avg);

#Find employee details who belongs to the department 
#with highest average salary

select emp_id, 
       name, 
       salary, 
       department_id
from employee
where department_id in (
      select department_id
      from employee
      group by department_id
      having avg(salary) = (
             select max(avg_salary)
             from (
                    select Department_id, 
                    avg(salary) as avg_salary
                    from employee
                    group by Department_id) 
                    as dept_avg));

#3. List all employees who have made at least one sale.

select distinct(emp_id)
from sales;

select emp_id, 
       name, 
	   department_id, 
	   salary
from employee
where emp_id in (select distinct(emp_id)
from sales);

#4. Find the employee with the highest sale amount.

select max(sale_amount)
from sales;

select emp_id, sale_amount
from sales
where sale_amount in (select max(sale_amount)
from sales);

#5. Retrieve the names of employees whose salaries are 
# higher than Shubham’s salary.

select * from employee;

select salary
from employee
where name = 'Shubham';

select emp_id, name, department_id, salary
from employee
where salary > (select salary
from employee
where name = 'Shubham');

#Intermediate Level
#1. Find employees who work in the same department as Abhishek.

select * from employee;

select department_id
from employee
where name = 'Abhishek';

select name
from employee
where department_id = (select department_id
from employee
where name = 'Abhishek')
and name <> 'Abhishek';

#2. List departments that have at least one employee 
# earning more than ₹60,000.

select * from employee;

select distinct department_id
from employee
where salary > 60000;

select department_id, department_name
from department
where department_id in (select distinct department_id
from employee
where salary > 60000);

#3. Find the department name of the employee who made 
# the highest sale.

select * from sales;

select max(sale_amount)
from sales;

select emp_id
from sales
where sale_amount = (select max(sale_amount)
from sales);

select department_id
from employee
where emp_id = (select emp_id
from sales
where sale_amount = (select max(sale_amount)
from sales));

select department_id, department_name
from department
where department_id = (select department_id
from employee
where emp_id = (select emp_id
from sales
where sale_amount = (select max(sale_amount)
from sales)));

#4. Retrieve employees who have made sales greater 
# than the average sale amount.

select avg(sale_amount)
from sales;

select emp_id
from sales
where sale_amount > (select avg(sale_amount)
from sales);

select emp_id, name
from employee
where emp_id in (select emp_id
from sales
where sale_amount > (select avg(sale_amount)
from sales));

#5. Find the total sales made by employees who earn 
# more than the average salary.

select avg(salary)
from employee;

select emp_id
from employee
where salary > (select avg(salary)
from employee);

select sum(sale_amount)
from sales
where emp_id in (select emp_id
from employee
where salary > (select avg(salary)
from employee));

#Advanced Level

#1. Find employees who have not made any sales.

select emp_id
from sales;

select emp_id
from employee  
where emp_id not in (select emp_id
from sales);

#2. List departments where the average salary 
# is above ₹55,000.

select department_id
from employee
group by department_id
having avg(salary) > 55000;

select department_name
from department
where department_id in (select department_id
from employee
group by department_id
having avg(salary) > 55000);

#3. Retrieve department names where the total sales 
# exceed ₹10,000.

select emp_id
from sales
group by emp_id
having sum(sale_amount) > 10000;

select department_id
from employee
where emp_id in (select emp_id
from sales
group by emp_id
having sum(sale_amount) > 10000);

select department_name
from department
where department_id in (select department_id
from employee
where emp_id in (select emp_id
from sales
group by emp_id
having sum(sale_amount) > 10000));

#4. Find the employee who has made the second-highest sale.

select max(sale_amount)
from sales;

select max(sale_amount)
from sales
where sale_amount < (select max(sale_amount)
from sales);

select emp_id
from sales
where sale_amount = (select max(sale_amount)
from sales
where sale_amount < (select max(sale_amount)
from sales));

select name
from employee
where emp_id in (select emp_id
from sales
where sale_amount = (select max(sale_amount)
from sales
where sale_amount < (select max(sale_amount)
from sales)));

#5. Retrieve the names of employees whose salary 
# is greater than the highest sale amount recorded.

select max(sale_amount)
from sales;

select name
from employee
where salary > (select max(sale_amount)
from sales);