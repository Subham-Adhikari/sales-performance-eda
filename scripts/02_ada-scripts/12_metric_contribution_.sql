-- find top 10% customers contributes how many % of revenue?
-- ANS: ~40.28% REVENUE

WITH total_cust_revenue AS
  (
  	SELECT
  		customer_key,
  		SUM(sales_amount) customer_revenue
  	FROM gold.fact_sales F
  	WHERE order_date IS NOT NULL
  	GROUP BY customer_key
  
  ),
top_ten_percCustomers AS
  (
  	SELECT
  		customer_key,
  		customer_revenue,-- INDIVIDUAL CUSTOMER REVENUE
  		SUM(customer_revenue) OVER() total_revenue, -- TOTAL REVENUE
  		PERCENT_RANK() OVER(ORDER BY customer_revenue DESC) top_tenCust_percentrank
  	FROM total_cust_revenue
  )



SELECT
	ROUND(
		CAST(SUM(customer_revenue) AS float) / MAX(total_revenue) * 100
		, 2) AS top_10_percent_revenue_contribution
FROM top_ten_percCustomers
WHERE top_tenCust_percentrank <= 0.1;
GO





--Which product category had highest revenue = ?, CALCULATE THIS WHERE ORDER DATE IS PRESENT.
--  bike, almost 96.46% of total revenue

SELECT *,
	SUM(sales_amount) OVER() golbal_revenue,
	ROUND(
		CAST(sales_amount AS float) / SUM(sales_amount) OVER() * 100
		, 2) percContribution_ofCategories
FROM
(
	SELECT
		P.category,
		SUM(F.sales_amount) sales_amount
	FROM gold.fact_sales F
	INNER JOIN gold.dim_products P
	ON F.product_key = P.product_key
	WHERE F.order_date IS NOT NULL
	GROUP BY P.category
)T
ORDER BY sales_amount DESC;
GO



-- Average shipping time in days = ?
--ANS: 7 DAYS
SELECT 
	AVG(dayDifference)
FROM
(
	SELECT
		order_date,
		shipping_date,
		DATEDIFF(DAY, order_date, shipping_date) dayDifference
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL OR shipping_date IS NOT NULL
)T;
GO



/* 
	% of orders shipped on/before due_date = ?, exclude orderdate, shippingdate and due date with
	no values.



	% on-time = (On-time orders / Valid orders) × 100 --VALID ORDER MEANS ORDER WHICH IS
														DELIVERED, WHETHER LATE OR ON-TIME
	          = (2 / 3) × 100 
			  = 66.67%

*/
-- ANS: 100
SELECT
	CAST(onTime_orders AS float) / all_orders * 100
FROM
(
	SELECT
		COUNT(DISTINCT order_number) AS onTime_orders,
		(SELECT 
			COUNT(DISTINCT order_number) 
		 FROM gold.fact_sales 
		 WHERE order_date IS NOT NULL AND 
		       shipping_date IS NOT NULL AND 
			   due_date IS NOT NULL) AS all_orders
	FROM gold.fact_sales
	WHERE (order_date IS NOT NULL AND shipping_date IS NOT NULL AND due_date IS NOT NULL)
		  AND
		  shipping_date <= due_date -- ON TIME ORDERS
)T;
GO
