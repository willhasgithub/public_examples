/*
This SQL query will be used to visualize Question 1.
The file prefaced with q2_ is used to answer Question 1 in the form of a SQL query/table
*/

WITH shipped_product_sales_in_2003_and_2004 as (
	SELECT
		sales.product_id
	-- aggregators
		, SUM(quantity) as total_quantity_sold
		, SUM(quantity*unit_price) as total_dollar_sales
	FROM public.sales
	WHERE
	-- filter sales data for specific years
		sales.year BETWEEN 2003 AND 2004
		AND lower(sales.status::text) = 'shipped'
	GROUP BY sales.product_id
)

SELECT
	products.product_line
	, shipped_product_sales_in_2003_and_2004.*
FROM public.products
INNER JOIN shipped_product_sales_in_2003_and_2004
	ON shipped_product_sales_in_2003_and_2004.product_id = products.product_id
ORDER BY total_dollar_sales DESC
