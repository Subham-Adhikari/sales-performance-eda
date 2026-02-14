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

