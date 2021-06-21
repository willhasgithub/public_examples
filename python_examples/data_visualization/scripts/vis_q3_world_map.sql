/*
Write one or more queries to find the total sales per region,
	the most popular product line per region,
	and the country with the highest sales per region.

Did you filter some sales data out, and why?
*/

WITH customers_with_region_and_country_state as (
	SELECT
		customers.customer_id
		, address_country as country_state
		, CASE
			WHEN territory ISNULL
				THEN address_country
			ELSE
				territory
		END as region
	FROM public.customers
)

, shipped_sales_and_products as (
	SELECT
		customer_id
		, product_line
		, unit_price
		, quantity
	FROM public.sales
	INNER JOIN public.products
		ON products.product_id = sales.product_id
	WHERE lower(sales.status::text) = 'shipped'
)

, sales_by_region as (
	SELECT
		region
		, SUM(quantity*unit_price) as region_total_sales
		, DENSE_RANK() OVER (
			ORDER BY SUM(quantity*unit_price) DESC
		) as rank_region_total_sales
	FROM shipped_sales_and_products
	INNER JOIN customers_with_region_and_country_state
		ON customers_with_region_and_country_state.customer_id = shipped_sales_and_products.customer_id
	GROUP BY region
)

, sales_by_product_line_and_region as (
	SELECT
		region
		, product_line
		, SUM(quantity*unit_price) as product_line_and_region_total_sales
		, DENSE_RANK() OVER (
			PARTITION BY region
			ORDER BY SUM(quantity*unit_price) DESC
		) as rank_product_line_total_sales_per_region
	FROM shipped_sales_and_products
	INNER JOIN customers_with_region_and_country_state
		ON customers_with_region_and_country_state.customer_id = shipped_sales_and_products.customer_id
	GROUP BY region, product_line
)

, sales_by_country_and_region as (
	SELECT
		region
		, country_state
		, SUM(quantity*unit_price) as country_and_region_total_sales
		, DENSE_RANK() OVER (
			PARTITION BY region
			ORDER BY SUM(quantity*unit_price) DESC
		) as rank_country_total_sales_per_region
	FROM shipped_sales_and_products
	INNER JOIN customers_with_region_and_country_state
		ON customers_with_region_and_country_state.customer_id = shipped_sales_and_products.customer_id
	GROUP BY region, country_state
)

SELECT
	sales_by_region.region
	, sales_by_country_and_region.country_state
-- 	, sales_by_product_line_and_region.product_line
-- 	, region_total_sales
	, country_and_region_total_sales
--	, product_line_and_region_total_sales
-- 	, rank_region_total_sales
	, rank_country_total_sales_per_region
--	, rank_product_line_total_sales_per_region
FROM sales_by_region
--INNER JOIN sales_by_product_line_and_region
--	ON sales_by_product_line_and_region.region = sales_by_region.region
INNER JOIN sales_by_country_and_region
	ON sales_by_country_and_region.region = sales_by_region.region
-- WHERE sales_by_region.region in ('USA')
ORDER BY
	rank_region_total_sales
	, rank_country_total_sales_per_region
--	, rank_product_line_total_sales_per_region
