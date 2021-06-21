/*
Write one or more queries to find the total sales per region,
	the most popular product line per region,
	and the country with the highest sales per region.

Did you filter some sales data out, and why?
        Yes, I filtered out any deal/sale that did not have the status 'Shipped'. Explained in Q1
*/

-- Used to define region and country that is not US/Canada centric.
-- US and Canada are now viewed as distinct regions and their states/provinces are viewed as countries
WITH customers_with_region_and_country_state as (
	SELECT
		customers.customer_id
		, CASE
			WHEN address_state NOTNULL
				THEN address_state
			ELSE
				address_country
		END as country_state
		, CASE
			WHEN territory ISNULL
				THEN address_country
			ELSE
				territory
		END as region
	FROM public.customers
)

-- Used to join sales and products as well as filter out any sale/deal that has not shipped
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

-- Used to gather data on the total sales in a region
, sales_by_region as (
	SELECT
		region
		, SUM(quantity) as region_total_quantity
		, SUM(quantity*unit_price) as region_total_sales
		, DENSE_RANK() OVER (
			ORDER BY SUM(quantity*unit_price) DESC
		) as rank_region_total_sales
	FROM shipped_sales_and_products
	INNER JOIN customers_with_region_and_country_state
		ON customers_with_region_and_country_state.customer_id = shipped_sales_and_products.customer_id
	GROUP BY region
)

-- Used to gather data on the total sales of a product line in a region
, sales_by_product_line_and_region as (
	SELECT
		region
		, product_line
		, SUM(quantity) as product_line_and_region_total_quantity
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

SELECT
	sales_by_region.region
	, sales_by_product_line_and_region.product_line
	, product_line_and_region_total_quantity
	, product_line_and_region_total_sales
FROM sales_by_region
INNER JOIN sales_by_product_line_and_region
	ON sales_by_product_line_and_region.region = sales_by_region.region
ORDER BY
	rank_region_total_sales
	, rank_product_line_total_sales_per_region
