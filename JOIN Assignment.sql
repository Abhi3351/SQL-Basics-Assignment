-- SQL JOINS Assignment --

create database abc;

use abc;

-- Table 1: Customers --

create table Customers(
CustomerID INT primary key,
CustomerName varchar(50),
City varchar(50)
);

Insert into Customers values(1, "John Smith", "New York"),
(2, "Mary Johnson", "Chicago"),
(3, "Peter Adams", "Los Angeles"),
(4, "Nancy Miller", "Houston"),
(5, "Robert White", "Miami");

-- Customer 6 doesn't exist so we'll enter a dummy customer --
-- otherwise table orders entries will never succeed --

insert into Customers values(6, "Rocky Miller", "DC");

select * from Customers;

-- Table 2: Orders --

create table Orders(
OrderID INT primary key,
CustomerID INT,
OrderDate Date,
Amount int,
foreign key (CustomerID) references Customers(CustomerID)
);

Insert into Orders values(101, 1, '2024-10-01', 250),
(102, 2, '2024-10-05', 300),
(103, 1, '2024-10-07', 150),
(104, 3, '2024-10-10', 450),
(105, 6, '2024-10-12', 400);

select * from Orders;

-- Table 3: Payments --

create table Payments(
PaymentID varchar(20) primary key,
CustomerID int,
PaymentDate DATE,
Amount int,
foreign key (CustomerID) references Customers(CustomerID)
);

insert into Payments values("P001", 1, "2024-10-02", 250),
("P002", 2, "2024-10-06", 300),
("P003", 3, "2024-10-11", 450),
("P004", 4, "2024-10-15", 200);

select * from Payments;

-- Table 4: Employees --

create table Employees(
EmployeeID int primary key,
EmployeeName varchar(50),
ManagerID int
);

insert into Employees values(1, "Alex Green", NULL),
(2, "Brian Lee", 1),
(3, "Carol Ray", 1),
(4, "David Kim", 2),
(5, "Eva Smith", 2);

select * from Employees;

-- Q1.  Retrieve all customers who have placed at least one order --

-- Answer --
select distinct c.customerID, c.customerName, c.City
from customers c 
inner Join orders o
on c.customerID = o.customerID;

-- Q2. Retrieve all customers and their orders, including customers who have not placed any orders. --

-- Answer --
SELECT c.CustomerID, c.CustomerName, c.City, o.OrderID, o.OrderDate, o.Amount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- Q3. Retrieve all orders and their corresponding customers, including orders placed by unknown customers --

-- Answer -- 
SELECT o.OrderID, o.CustomerID, o.OrderDate, o.Amount,
       c.CustomerName, c.City
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- Q4.  Display all customers and orders, whether matched or not. --

-- Answer --

-- Customers with their orders (including customers without orders)
SELECT c.CustomerID, c.CustomerName, c.City,
       o.OrderID, o.OrderDate, o.Amount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID

UNION

-- Orders with their customers (including orders without valid customers)
SELECT c.CustomerID, c.CustomerName, c.City,
       o.OrderID, o.OrderDate, o.Amount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- Q5. Find customers who have not placed any orders. --

-- Answer --

SELECT c.CustomerID, c.CustomerName, c.City
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Q6. Retrieve customers who made payments but did not place any orders --

-- Answer -- 

SELECT DISTINCT c.CustomerID, c.CustomerName, c.City
FROM Customers c
INNER JOIN Payments p
    ON c.CustomerID = p.CustomerID
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Q7. Generate a list of all possible combinations between Customers and Orders. --

-- Answer --
SELECT c.CustomerID, c.CustomerName, c.City,
       o.OrderID, o.OrderDate, o.Amount
FROM Customers c
CROSS JOIN Orders o;

-- Q8. Show all customers along with order and payment amounts in one table --

-- Answer --
SELECT c.CustomerID, c.CustomerName, c.City,
       o.OrderID, o.Amount AS OrderAmount,
       p.PaymentID, p.Amount AS PaymentAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
LEFT JOIN Payments p
    ON c.CustomerID = p.CustomerID;
    
-- Q9. Retrieve all customers who have both placed orders and made payments --

-- Answer --
SELECT DISTINCT c.CustomerID, c.CustomerName, c.City
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN Payments p
    ON c.CustomerID = p.CustomerID;
