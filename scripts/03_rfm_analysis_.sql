
-- Updated Analysis:
/*
==========================================================
Customer Recency Analysis and Segmentation
==========================================================

Objective:
----------
1. For each customer, calculate their total number of distinct orders (Frequency) and total revenue spent (Monetary).
2. For each customer, calculate Recency — the number of days between their last order and the most recent order date in the dataset.

Segmentation Logic:
-------------------
0–30 days   → Very recent buyers
31–90 days  → Bought somewhat recently
91–180 days → Likely to stop buying
181+ days   → Have not purchased for a long time

Output:
-------
- Number of customers in each segment
- Formatted customer counts (e.g., ~4k)
- Percentage distribution of customers
==========================================================
*/

-- Step 1: Calculate last purchase date per customer
-- and determine dataset-wide most recent order date
WITH recency_table AS
(
	SELECT
		customer_key,
		MAX(order_date) AS last_order_date, -- Last order placed by each customer
		MAX(MAX(order_date)) OVER() AS most_recent_order_date, -- Most recent order date in the entire dataset
		-- Recency calculation:
		-- Days between customer's last order
		-- and most recent order in dataset
		DATEDIFF(DAY, MAX(order_date), MAX(MAX(order_date)) OVER()) AS recency_days
	FROM gold.fact_sales
	GROUP BY customer_key -- Group by customer to calculate metrics per customer
),
-- Step 2: Assign business-friendly recency segments
recency_segment AS
(
	SELECT
		*,
		CASE -- Segment customers based on recency_days
			WHEN recency_days <= 30 THEN 'Very recent buyers'
			WHEN recency_days <= 90 THEN 'Bought somewhat recently'
			WHEN recency_days <= 180 THEN 'Likely to stop buying'
			ELSE 'Have not purchased for a long time'
		END AS recency_segment
	FROM recency_table
)
-- Step 3: Aggregate customers by segment
-- and calculate counts and percentages
SELECT
	recency_segment,
	COUNT(1) AS customer_number, -- Total number of customers in each segment
	CASE -- Format large numbers into readable form (~4k)
		WHEN COUNT(1) >= 1000 AND COUNT(1) < 1000000 
			THEN '~' + CAST(
				ROUND(
					CAST(COUNT(1) AS float) / 1000,
					2
				) AS varchar(20)
			) + 'k'

		ELSE 
			CAST(COUNT(1) AS varchar(20))
	END AS number_of_customers,
	-- Percentage share of each segment
	-- relative to total customers
	'~' + CAST(
		ROUND(
			CAST(COUNT(1) AS float)
			/
			SUM(COUNT(1)) OVER()
			* 100,
			0
		) AS varchar(20)
	) + '%' AS perc_of_customers
FROM recency_segment
GROUP BY recency_segment; -- Group results by segment label

GO





/*
	1. For each customer, calculate their total number of distinct orders (Frequency) and 
	total revenue spent (Monetary).

	2. For each customer, calculate Recency — the number of days between their last order 
	and the most recent order date in the dataset.

	
	3. Using NTILE(5), assign each customer a score from 1 to 5 for Recency, Frequency, and 
	Monetary. For Recency, reverse the score so that customers who bought most recently get a 5.

	4. Combine the three scores into a single RFM segment label using CASE WHEN: 
	Champions (R=5, F>=4, M>=4), Loyal (R>=4, F>=3), At Risk (R<=2, F>=3), Lost (R=1, F<=2),
	and Others for the rest.

	5. How many customers fall into each RFM segment, and what percentage of the total 
	customer base does each segment represent?

	6. What is the total revenue and percentage share of total revenue contributed by each
	RFM segment?

*/

WITH initial_aggregation AS (
	SELECT
		F.customer_key,
		ISNULL(C.first_name, '') + ' ' + ISNULL(C.last_name, '') AS customer_name,
		COUNT(DISTINCT F.order_number) AS total_orders,
		SUM(F.sales_amount) AS total_revenue,
		MAX(F.order_date) last_order_date
	FROM gold.fact_sales AS F
	INNER JOIN gold.dim_customers AS C
	ON F.customer_key = C.customer_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		F.customer_key,
		C.first_name,
		C.last_name

),
recency_calculation AS (
	SELECT *,
		DATEDIFF(DAY, last_order_date, MAX(last_order_date) OVER()) recency_days
	FROM initial_aggregation
),
bucketing AS (
SELECT *,
	NTILE(5) OVER(ORDER BY total_orders  ASC) AS frequency_score,
	NTILE(5) OVER(ORDER BY total_revenue ASC) AS monetary_score,
	NTILE(5) OVER(ORDER BY recency_days  DESC) AS recency_score
FROM recency_calculation
),
segmenting AS (
SELECT
	customer_key,
	customer_name,
	total_orders,
	total_revenue,
	CASE
		WHEN recency_score  = 5 AND frequency_score >= 4 AND monetary_score >= 4 
			THEN 'Champions'
		WHEN recency_score >= 4 AND frequency_score >= 3 
			THEN 'Loyal'
		WHEN recency_score <= 2 AND frequency_score >= 3 
			THEN 'At Risk'
		WHEN recency_score  = 1 AND frequency_score <= 2 
			THEN 'Lost'
		ELSE 'Others'
	END segmentation
FROM bucketing
)

SELECT
	segmentation,
	--COUNT(*) total_customers,
	CAST(ROUND(
		CAST(COUNT(*) AS float) / SUM(COUNT(*)) OVER() *100
		, 2) AS varchar) + '%' customers,
	--SUM(total_revenue) rfm_revenue,
	CAST(ROUND(
		CAST(SUM(total_revenue) AS float) / SUM(SUM(total_revenue)) OVER() *100
		, 2) AS varchar) + '%' revenue
FROM segmenting
GROUP BY segmentation;
GO





