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





