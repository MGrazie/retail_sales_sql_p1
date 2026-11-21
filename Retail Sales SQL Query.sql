-- STEP 0: CREATE DATABASE
-- SQL Retail Sales Analysis Practice 1
CREATE DATABASE retail_sales_analysis_practice;

-- STEP 1: CREATE TABLE

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),	
				age	INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

-- STEP 2: UNDERSTAND VARIABLES/COLUMNS

-- Check the table created first with the column names and empty records
-- Make sure to refresh after creating the table and after loading the raw data
-- Check table after importing and loading/refreshing
SELECT * FROM retail_sales
LIMIT 10;

-- Check total number of rows by using SELECT COUNT(*) Countercheck with excel
SELECT COUNT(*) FROM retail_sales;

-- Rename column "quantiy" to "quantity"
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

-- STEP 3: DATA CLEANING

-- Checking null values in all columns using the WHERE condition clause, IS NULL, OR 
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Identified 13 rows with missing records for all 5 columns(quantity, price_per_unit, age, cogs & total_sale)
-- Solution is to DELETE the 13 rows. No much effect on the 2000 records.
-- Use DELETE FROM with WHERE condition for the IS NULL rows
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Check the number of records left by running the COUNT query
SELECT COUNT(*) FROM retail_sales;
-- 1987 records left

-- Check the null records again to confirm no null record is left
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
-- No empty record left

-- STEP 4: DATA EXPLORATION

-- How many total sales we have? Transaction IDs are unique so we are counting the number of rows: COUNT(*)
-- AS is an alias, a temporary column name that is shown only on the output of that code
SELECT COUNT(*) as total_sales FROM retail_sales;
-- This shows 1987 total sales

-- How many customers do we have? 
-- Counts unique/distinct customer_IDs
SELECT gender,COUNT(DISTINCT customer_id) as total_customers 
FROM retail_sales
GROUP BY 1;
-- We have 306 customers

-- Which categories do we have? (Gives the category names while using count gives us 3)
SELECT DISTINCT category as total_categories FROM retail_sales;

-- STEP 5: DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- Q1: Retrieve all columns for sales made on '2022-11-05'
-- Using SELECT and WHERE. The date is inside single quotations
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- We can count the total number of sales for this date
SELECT COUNT(*) FROM retail_sales
WHERE sale_date = '2022-11-05';

-- We can also count the total sales for each category on this date using customer_id
SELECT category, gender, COUNT(customer_id) AS total_customers 
FROM retail_sales
WHERE sale_date = '2022-11-05'
GROUP BY 1,2;

-- Or do the same using transactions_id
SELECT category, gender, COUNT(transactions_id) AS total_transactions 
FROM retail_sales
WHERE sale_date = '2022-11-05'
GROUP BY 1,2;

-- We can also find the total number of sales as per gender on this date
SELECT gender, COUNT(customer_id) AS total_customers
FROM retail_sales
WHERE sale_date = '2022-11-05'
GROUP BY 1;

-- Q2: Retrieve all the transactions where category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
-- To retrieve all sales for a specific month we use TO_CHAR() to convert date to text as specified 'YYYY-MM' for comparison.
-- 'YYYY-MM' converts the date to just the year and month and then compares the date with the condition '2022-11'
SELECT * FROM retail_sales
WHERE
	category = 'Clothing'
	AND
	quantity > 2
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q3: Calculate the total sales (total_sale) for each category
-- See the difference between using COUNT() and SUM()
SELECT category, COUNT(total_sale) as total_sales
FROM retail_sales
GROUP BY category;

SELECT category, COUNT(transactions_id) as total_transactions
FROM retail_sales
GROUP BY category;

SELECT category, COUNT(customer_id) as total_customers
FROM retail_sales
GROUP BY category;
-- Notice that using COUNT() gives us the same output. This counts the total number of purchases/sales/transactions for each category
-- SUM() adds the total sale prices for each transaction as per the product/category
SELECT category, SUM(total_sale) as total_sales, COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q4: Find the average age of customers who purchased items from the Beauty category
-- Use of aggregates, AVG()
SELECT category, AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1;

-- Average age for all categories
SELECT category, AVG(age) as avg_age
FROM retail_sales
GROUP BY 1;

-- Using ROUND() to roundoff the age. The format includes 2 elements(a,b). 
-- a is the variable you want to roundoff, b is the decimal place yu want to roundoff to
SELECT category, ROUND(AVG(age), 0) as avg_age
FROM retail_sales
GROUP BY category;

-- Q5: Find ALL TRANSACTIONS where the total sale is greater than 1000
-- Use of WHERE
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- We can group these transactions by gender or category
SELECT gender, COUNT(total_sale) as total_sales FROM retail_sales
WHERE total_sale > 1000
GROUP BY 1;

SELECT category, COUNT(total_sale) as total_sales FROM retail_sales
WHERE total_sale > 1000
GROUP BY 1;

-- Can we group by both?
SELECT gender, category, COUNT(total_sale) as total_sales FROM retail_sales
WHERE total_sale > 1000
GROUP BY 1,2;

-- Q6: Find the total number of transactions (transaction_id) made by each gender in each category
SELECT gender, category, COUNT(transactions_id) as total_transactions
FROM retail_sales
GROUP BY 1,2;
-- Same as:
SELECT gender, category, COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2;
-- Grouping by category first
SELECT category, gender, COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2;
-- We can order the output by a variable for easier comparison
SELECT category, gender, COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 1;

SELECT category, gender, COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 2;

-- Q7: Calculate the average sale for each month. Find out best selling month in each year
-- To get the year and months we use the EXTRACT() function which will extract year and month from the sale_date column
-- Format is EXTRACT(a FROM b) as c: a is the data you want to get, b is the column you're getting the data from, c is the new column name in the output
-- First we calculate the sum/total sales per month
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;

-- Average sales for each month
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	AVG(total_sale) as avg_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;

-- Rounding off a double precision column like total_sale. 
-- Postgre does not require the second element which specifies the decimal point to which you want to roundoff 
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	ROUND(AVG(total_sale)) as avg_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;

-- To roundoff and specify to which decimal point for a float column we use ::NUMERIC
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	ROUND(AVG(total_sale)::NUMERIC,2) as avg_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2;

-- We can order by 3 to arrange the avg_sales in ascending/descending order
-- We remove order by 2
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	ROUND(AVG(total_sale)::NUMERIC,2) as avg_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- We can use RANK(). We don't use aliases inside the rank function. More practice & understanding needed.
SELECT 
	EXTRACT(YEAR FROM sale_date) as year, 
	EXTRACT(MONTH FROM sale_date) as month, 
	ROUND(AVG(total_sale)::NUMERIC,2) as avg_sale,
	RANK() OVER(
		PARTITION BY EXTRACT(YEAR FROM sale_date) 
		ORDER BY AVG(total_sale) DESC
		) as sales_rank
FROM retail_sales
GROUP BY 1,2;

-- We can filter the above table to obtain the month with most sales for each month by:
SELECT * FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year, 
		EXTRACT(MONTH FROM sale_date) as month, 
		ROUND(AVG(total_sale)::NUMERIC,2) as avg_sale,
		RANK() OVER(
			PARTITION BY EXTRACT(YEAR FROM sale_date) 
			ORDER BY AVG(total_sale) DESC
			) as sales_rank
	FROM retail_sales
	GROUP BY 1,2
) 
WHERE sales_rank = 1;

-- we can omit the rank column in this by specifying the columns to display
SELECT year, month, avg_sale FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year, 
		EXTRACT(MONTH FROM sale_date) as month, 
		ROUND(AVG(total_sale)::NUMERIC,2) as avg_sale,
		RANK() OVER(
			PARTITION BY EXTRACT(YEAR FROM sale_date) 
			ORDER BY AVG(total_sale) DESC
			) as sales_rank
	FROM retail_sales
	GROUP BY 1,2
) 
WHERE sales_rank = 1;

-- Q8: Find the top 5 customers based on the highest total sales
-- First understand the dataset
-- How many customers(customer_id) do we have?(306)
SELECT customer_id, gender 
FROM retail_sales
GROUP BY 1,2;
-- We notice that the customer_id is allocated as per the customer gender
-- Therefore, customer_id 1 is allocated twice. Male and Female.

-- Each customer with their total sales
SELECT customer_id, gender, SUM(total_sale) as total_sales 
FROM retail_sales
GROUP BY 1,2
ORDER BY 1;

-- Order the total sales in descending order
SELECT customer_id, gender, SUM(total_sale) as total_sales 
FROM retail_sales
GROUP BY 1,2
ORDER BY 3 DESC;
-- Customer 3(male) has the highest total sales, customer_id 125(female) has the lowest total sales


-- Q9: Find the NUMBER OF UNIQUE customers who purchased items from each category
SELECT category, gender, COUNT(DISTINCT customer_id) as customer_count
FROM retail_sales
GROUP BY 1,2;

-- Q10: CREATE each shift and number of orders(Example Morning <=12, Afternoon Between 12 and 17, Evening >17)
-- Check time formart
SELECT sale_time FROM retail_sales;

-- Use of segmentation
-- We use CASE, WHEN...THEN, ELSE & END...
SELECT *,
	CASE
		WHEN sale_time <= '12:00:00' THEN 'Morning'
		WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales;

-- Another way of doing it using EXTRACT()
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales;

-- Can we check total number of transactions in each shift? YES!
SELECT shift, SUM(total_sale) as total_sales, COUNT(*) as total_transactions FROM
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
GROUP BY 1;

-- End of project