/*
This SQL query will be used to visualize Question 2.
The file prefaced with q2_ is used to answer Question 2 in the form of a SQL query/table
*/

WITH deal_size_and_unit_price as (
	SELECT
        deal_size as "Deal Size"
		, unit_price as "Unit Price"
		, COUNT(*) as "Frequency of Deal Size and Unit Price"
	FROM public.sales
	WHERE lower(sales.status::text) = 'shipped'
	GROUP BY deal_size, unit_price
)

SELECT
	deal_size_and_unit_price.*
FROM deal_size_and_unit_price
