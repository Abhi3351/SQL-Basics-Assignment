-- Advance SQL Assignment Questions --

-- Q1. What is a Common Table Expression (CTE), and 
--     how does it improve SQL query readability?

-- Ans: A CTE improves SQL query readability by providing 
--      a structured, reusable, and logical way to organize
--      complex queries. It doesn’t store data permanently, 
--      but it makes queries easier to write and understand 
--      especially when dealing with multiple logical steps.

--      and there are several steps that CTE improves 
--      SQL Query Readability

--      1. Reusablity: A CTE can be referenced multiple times
--         within the main query, avoiding duplication of code.

--      2. Maintainability: All the Queries are easier to debug and 
--         modify since each logical block is clearly defined.

--      3. Enhances clarity from alternatives: Unlike 
--         temporary tables or views, a CTE is lightweight 
--         and exists only for the query execution, making 
--         it ideal for readability without cluttering the 
--         schema.

--      4. Supports recursion: Recursive CTEs allow you to 
--         handle hierarchical data (e.g., employee‑manager 
--         relationships, category trees) in a clean way.


-- Q2. Why are some views updatable while others are 
--     read-only? Explain with an example.

-- Ans: Updatable views:- A view is updatable if every row 
--      in the view maps directly to a single row in the 
--      underlying base table.
--      Updatable views has no ambiguity so when we update
--      the view, the database knows exactly which row 
--      in the base table to update.
--      It based on a single table and it has no aggreagate
--      functions like SUM, COUNT, AVG, etc.
--      No Distinct, Group by and Union or complex joins. 

--      Ex: Using Sakila Dataset
        use sakila;

        create view customers as
        select customer_id, first_name, last_name, email
		from customer;

--      Note: it is based on single table and it has no
--      aggregates, joins or group by

--      Read-only views: If the view involves transformations
--      that break the one-to-one mapping between view rows 
--      and base table rows, updates are not allowed.
--      It uses Group by, Distinct and Joins.

--      Ex: Using Sakila Dataset

        USE sakila;

        create view films as
        select c.name AS category_name, 
                         COUNT(f.film_id) AS total_films
        from film f
		join film_category fc 
		on f.film_id = fc.film_id
        join category c 
        on fc.category_id = c.category_id
        group by c.name;
        
--      Note: Use Join in the multiple tables and it includes
--      count() as aggregate function and group by. it has 
--      no direct mapping between view rows and base table rows.


-- Q3.  What advantages do stored procedures offer compared 
--      to writing raw SQL queries repeatedly?

-- Ans 1. Reduced Network Traffic: Applications can call a 
--      procedure with parameters instead of sending long 
--      queries repeatedly. This minimizes the data transfer 
--      between client and server.

--     2. Maintainability: Raw SQL would require updating 
--     every script or app where the query is written.
--     If business logic changes, you only update the procedure once.

--     3. Security Control: You can grant users permission
--     to execute a procedure without giving them direct access 
--     to the underlying tables. This prevents accidental or 
--     malicious data manipulation.

--     4. Code Reuse & Consistency: Instead of writing the 
--     same SQL query multiple times, you can store it once 
--     as a procedure and call it whenever needed.

--     5. Performance Optimization: Stored procedures are 
--     precompiled and cached by the database engine. Raw 
--     SQL queries are parsed and optimized every time you 
--     run them, which is slower.


-- Q4. What is the purpose of triggers in a database? 
--     Mention one use case where a trigger is essential.

-- Ans: Triggers used to enforce rules, maintain audit logs, 
--     or cascade changes without requiring manual intervention.
--     A trigger is a special procedure that automatically 
--     executes in response to certain events 
--     (INSERT, UPDATE, DELETE) on a table.

--     Essential Use Case:


       delimiter //
       create trigger before_film_update
       before update on film
       for each row
       begin
            set new.last_update = NOW();
       end //

       delimiter ;
       
--     Note: Automatically updating the last_update column 
--     whenever a film record changes.
--     Whenever a row in the film table is updated 
--     (e.g., changing the title, description, or rental rate), 
--     this trigger fires before the update.
--     It ensures Data Integrity and provides auditability. 


-- Q5. Explain the need for data modelling and normalization
--     when designing a database.

-- Ans: Normalization: Normalization is the process of organizing 
--     data into well-structured tables to reduce redundancy
--     and improve integrity.

--     Purpose: It eliminates duplicate data and ensures consistency.
--     It Improves efficiency by breaking data into smaller,
--     related tables.
--     It Maintains data integrity through proper use of 
--     keys an dconstraints.

--     Data Modeling: Data modelling is the process of visually 
--     and logically designing how data will be structured, 
--     stored, and related in a database.

--     Purpose: It provides a blueprint before building 
--     the database and ensures clarity about entities,
--     attributes and relationships. It makes communication
--     easier between developers, analysts, and business stakeholders.


-- Q6. Write a CTE to calculate the total revenue for each product
--     (Revenues = Price × Quantity), and return only products 
--     where revenue > 3000.

--     create table 1

       CREATE TABLE Products (
       ProductID INT PRIMARY KEY,
       ProductName VARCHAR(100),
       Category VARCHAR(50),
	   Price DECIMAL(10,2));

--     insert values

       INSERT INTO Products VALUES
       (1, 'Keyboard', 'Electronics', 1200),
       (2, 'Mouse', 'Electronics', 800),
       (3, 'Chair', 'Furniture', 2500),
       (4, 'Desk', 'Furniture', 5500);

--     create table 2

       CREATE TABLE Sales (
       SaleID INT PRIMARY KEY,
       ProductID INT,
       Quantity INT,
       SaleDate DATE,
       FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

--     insert values 

       INSERT INTO Sales VALUES
       (1, 1, 4, '2024-01-05'),
       (2, 2, 10, '2024-01-06'),
       (3, 3, 2, '2024-01-10'),
       (4, 4, 1, '2024-01-11');
       
-- Ans: 
       with ProductRevenue as (
	   select 
             p.ProductID,
             p.ProductName,
             SUM(p.Price * s.Quantity) as TotalRevenue
       from Products p
       join Sales s 
	   on p.ProductID = s.ProductID
       group by p.ProductID, p.ProductName)
    
       select ProductID, ProductName, TotalRevenue
       from ProductRevenue
       where TotalRevenue > 3000;
       
       
-- Q7. Create a view named vw_CategorySummary that shows
--     Category, TotalProducts, AveragePrice.

-- Ans:
       create view vw_CategorySummary as
       select 
             Category,
             count(ProductID) as TotalProducts,
             avg(Price) as AveragePrice
       from Products
       group by Category;


-- Q8. Create an updatable view containing ProductID, 
--     ProductName, and Price. Then update the price of 
--     ProductID = 1 using the view.

-- Ans: Create the updatable view

	   create view vw_ProductInfo as
       select ProductID, ProductName, Price
       from Products;

--     Update price using the view

       update vw_ProductInfo
       set Price = 1500
       where ProductID = 1;


-- Q9. Create a stored procedure that accepts a category 
--     name and returns all products belonging to that category.

-- Ans: 
       delimiter $$

       create procedure GetProductsByCategory(in categoryName varchar(50))
       begin
            select ProductID, ProductName, Price
            from Products
            where Category = categoryName;
       end$$

       delimiter ;


-- Q10. Create an AFTER DELETE trigger on the Products table
--      that archives deleted product rows into a new table
--      ProductArchive. The archive should store ProductID, 
--      ProductName, Category, Price, and DeletedAt timestamp.

-- Ans: First, create the archive table

        create table ProductArchive (
                     ProductID int,
                     ProductName varchar(100),
                     Category varchar(50),
                     Price decimal(10,2),
                     DeletedAt timestamp);

--      Now, create the AFTER DELETE trigger
        DELIMITER $$

        create trigger after_product_delete
                       after delete on Products
        for each row
        begin
             insert into ProductArchive (ProductID, ProductName, Category, Price, DeletedAt)
             values (old.ProductID, old.ProductName, old.Category, old.Price, now());
        end$$

        DELIMITER ;







        