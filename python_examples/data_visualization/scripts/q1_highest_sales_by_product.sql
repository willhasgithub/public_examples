/*
Write a SQL query to show which product had the highest sales in the years 2003 and 2004.
Your results should show the rank of every product, the product name, and the total sales of each product.
You are only given the unit price and sales quantity, so total sales amount will need to be calculated.

Did you filter some sales data out, and why?
	Yes, initial filter is on 2003 >= sales.year >= 2004
	I grouped the sales by both product and status.
		It will be useful to be able to see the product_sales that have status that is other than 'Shipped'.
			This may allow the user to see which orders may have been disputed, put on hold, etc.;
			possibly indicating an issue with the supply chain or avg customer satisfaction with the product.
			I will filter out not 'Shipped' sales for the visualization.
			But the inclusion of them in this table does not impact the top results.
		Also, it is my assumption that only 'Shipped' product_sales should count as final revenue;
			therefore, status is critical in determining the procuct with the highest sales in the given years.
			status values include 'Shipped', 'In Process', 'Cancelled', 'Disputed', 'On Hold', 'Resolved'
*/

WITH product_sales_in_2003_and_2004 as (
	SELECT
		sales.product_id
		, sales.status
	-- aggregators
		, COUNT(*) as num_orders
		, SUM(quantity) as total_quantity_sold
		, SUM(quantity*unit_price) as total_dollar_sales
	-- ranks
		, RANK() OVER (
			ORDER BY COUNT(*) DESC
		) as rank_num_orders
		, RANK() OVER (
			ORDER BY SUM(quantity) DESC
		) as rank_total_quantity_sold
		-- Below is the rank to identify the product with the highest sales in revenue
		, RANK() OVER (
			ORDER BY SUM(quantity*unit_price) DESC
		) as rank_total_dollar_sales
	FROM public.sales
	WHERE
	-- filter sales data for specific years
		sales.year BETWEEN 2003 AND 2004
	GROUP BY sales.product_id, sales.status
)

SELECT
	products.product_line
	, product_sales_in_2003_and_2004.*
FROM public.products
INNER JOIN product_sales_in_2003_and_2004
	ON product_sales_in_2003_and_2004.product_id = products.product_id
ORDER BY rank_total_dollar_sales
