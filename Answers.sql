/*------------Data Quality and Validation in ETL--------------*/
#Assessment

#Q1 : Define Data Quality in the context of ETL pipelines. 
#     Why is it more than just data cleaning?

/*Answer: Data Quality in ETL pipeline ensures that the data 
is accurate, complete, consistent, timely and aligned with 
business rules. It goes beyond simple "data cleaning" because
it involves proactive monitoring and validation of both
technical and business rules throughout the pipeline.*/

/*---Its more than Data Cleaning---

Data cleaning (removing duplicates, fixing formats, 
filling missing values) is only one part of the process. 
Data quality is broader and continuous:

1. Technical Validation
>> Ensures extracted data can be converted into correct types (e.g., dates, decimals).
>> Prevents ETL failures due to schema mismatches.

2. Business Validation
>> Checks if data makes sense in context (e.g., negative prices are invalid).
>> Ensures integrity across systems (referential integrity between transactions and master tables).

3. Monitoring & Governance
>> Automated checks detect schema drift, stale datasets, or partial loads.
>> Governance frameworks define rules and standards for data producers and consumers.

4. Resilience & Prevention
>> Pipelines should quarantine bad data instead of silently propagating it.
>> Prevention is cheaper than fixing downstream dashboards or reports.


----------------------------------------------------------
#Q2 : Explain why poor data quality leads to misleading 
dashboards and incorrect decisions.

Answer: There are five points which will tell why poor data
quality leads to misleading and incorrect decisions.

1. Missing Values: If revenue or quantity fields are null, 
totals and averages are understated. 
Example: missing high‑value transactions lowers the average 
revenue shown.

2. Duplicates: Double‑counted rows inflate metrics like 
sales, customer counts, or campaign spend. A dashboard 
may show growth that doesn’t exist.

3. Inconsistent Formats: If dates or amounts are stored 
differently (e.g., “12,400” as text vs. numeric), aggregations 
fail silently, producing wrong totals.

4. Invalid Business Keys: If Customer_ID doesn’t match the 
master table, dashboards may show customers that don’t exist.

5. Timeliness Issues: Late or partial data loads make 
dashboards appear complete but actually miss recent activity.

------------------------------------------------------------
#Q3: What is duplicate data? Explain three causes in ETL pipelines.

Answer: It means the same record (or logically identical 
information) appears more than once in a dataset. In ETL 
pipelines, duplicates distort metrics, inflate counts, 
and cause misleading dashboards.

Below are three common causes

1. Multiple Source Systems Feeding the Same Records
>> Example: A customer transaction is logged in both the CRM and the billing system.

>> When ETL jobs pull from both sources without deduplication, 
the same transaction appears twice.

2. Improper Joins or Merge Logic
>> Example: Joining Sales_Transactions with Customers_Master
using only Customer_Name instead of Customer_ID.

>> This can create multiple matches, duplicating rows in the
output.

3. Reprocessing or Partial Loads Without Idempotency
>> Example: If yesterday’s ETL job failed halfway and was 
rerun without clearing the staging table, the first half of 
records get loaded twice.

>> Lack of idempotent design (ensuring the same job can run 
multiple times without duplicating data) is a major cause.

------------------------------------------------------------
#Q4: Differentiate between exact, partial, and fuzzy duplicates.

Answer: Below are the difference between exact, partial and 
fuzzy duplicates.

1. Exact Duplicates
>> Definition: Records are identical across all fields in every columnd.
>> Cause: Multiple loads of the same source file or repeated inserts without deduplication.

2. Partial Duplicates
>> Definition: Records share some key attributes but differ in others. 
>> Cause: Incomplete ETL loads, inconsistent source systems, or schema mismatches. 

3. Fuzzy Duplicates
>> Definition: Records are not exactly the same but represent
>> the same real-world entity.
>> Cause: Data entry errors, inconsistent naming conventions,
   or lack of standardization.
   
------------------------------------------------------------
#Q5: Why should data validation be performed during transformation
     rather than after loading?
     
Answer: Data validation should be performed during the transformation
stage of ETL rather than after loading because this is the 
point where raw data is standardized, cleaned, and aligned 
with business rules before it enters the target system.

Why Validation is better:

1. Stops Bad Data at the Source
>> Invalid records (nulls, duplicates, wrong formats) are 
caught before they pollute the warehouse.
>> Once loaded, bad data is harder to detect and remove.

2. Ensures Business Rule Compliance Early
>> Rules like Quantity > 0, Txn_Date IS NOT NULL, or valid 
Customer_ID are enforced before loading.
>> This guarantees that only trustworthy data flows downstream.

3. Prevents Error Propagation
>> If invalid data is loaded, it gets aggregated, joined, 
and reported on, multiplying the error.
>> Early validation stops errors before they spread into 
dashboards.

4. Improves Efficiency
>> Filtering out bad records during transformation reduces storage costs and speeds up queries.
>> Warehouses stay lean and optimized.

------------------------------------------------------------
#Q6:  Explain how business rules help in validating data accuracy. 
Give an example.

Answer: Business rules are logical conditions defined by the
organization that ensure data reflects reality and complies
with business requirements. In ETL pipelines, they act as 
guardrails to validate data accuracy before it enters 
dashboards or reports.

#Business Rules Help
1. Catch Invalid Values >> Rules like Quantity > 0 prevent 
nonsensical records.

2. Ensure Completeness >> Rules like Txn_Date IS NOT NULL 
guarantee required fields are filled.

3. Maintain Consistency >> Rules like Customer_ID must exist
in Customers_Master enforce referential integrity.

4. Align With Business Logic >> Rules reflect actual business 
operations (e.g., transaction amount must equal Quantity × Unit Price).


-- Find invalid records violating business rules*/

use sakila;

SELECT r.rental_id, r.customer_id, p.payment_id, p.amount
FROM rental r
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE p.amount IS NULL OR p.amount <= 0;

------------------------------------------------------------
/*
#Q7: Write an SQL query on  to list all duplicate keys and
their counts using the business key (Customer_ID + Product_ID 
+ Txn_Date + Txn_Amount )*/

create database Dataquality;

use Dataquality;

create table Sales_Transactions (
    Txn_ID int primary key,
    Customer_ID varchar(10),
    Customer_Name varchar(50),
    Product_ID varchar(10),
    Quantity int,
    Txn_Amount decimal(10,2),
    Txn_Date date,
    City varchar(50)
);

insert into Sales_Transactions values
(201, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(202, 'C102', 'Anjali Rao', 'P12', 1, 1500, '2025-12-01', 'Bengaluru'),
(203, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(204, 'C103', 'Suresh Iyer', 'P13', 3, 6000, '2025-12-02', 'Chennai'),
(205, 'C104', 'Neha Singh', 'P14', null, 2500, '2025-12-02', 'Delhi'),
(206, 'C105', 'N/A', 'P15', 1, null, '2025-12-03', 'Pune'),
(207, 'C106', 'Amit Verma', 'P16', 1, 1800, null, 'Pune'),
(208, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai');

/* Query*/

select
      Customer_ID, 
	  Product_ID, 
      Txn_Date, 
      Txn_Amount, 
      count(*) as Duplicate_Count
from Sales_Transactions
group by Customer_ID, Product_ID, Txn_Date, Txn_Amount
having COUNT(*) > 1;

------------------------------------------------------------
# Q8: Enforcing Referential Integrity assume the following  table:
#Identify Sales_Transactions.Customer_ID values that violate referential integrity when joined with 
#Customers_Master and write a query to detect such violations.

#Answer: 

create table Customers_Master (
    CustomerID varchar(10) primary key,
    CustomerName varchar(50),
    City varchar(50)
);

insert into Customers_Master values
('C101', 'Rahul Mehta', 'Mumbai'),
('C102', 'Anjali Rao', 'Bengaluru'),
('C103', 'Suresh Iyer', 'Chennai'),
('C104', 'Neha Singh', 'Delhi');

select s.Customer_ID
from Sales_Transactions s
left join Customers_Master c
    on s.Customer_ID = c.CustomerID
where c.CustomerID is null;









