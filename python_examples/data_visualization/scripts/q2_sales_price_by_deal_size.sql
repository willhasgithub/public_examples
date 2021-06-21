/*
Write a SQL query to determine the average unit price per deal size. Did you filter some sales data out, and why?
    Yes, I filtered out any deal/sale that did not have the status 'Shipped'. Explained in Q1

BONUS: Compare the average to the median unit price. Do they align? Is there any significance to these results?
    Compared via Skew = 3 * (Mean – Median) / Standard Deviation.
*/


WITH deal_size_statistics as (
	SELECT
		deal_size
		, ROUND(AVG(unit_price), 2) as mean_sales_price
		, PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY unit_price) as median_unit_price
		, ROUND(
			STDDEV(unit_price)
			, 2) as unit_price_standard_deviation
		, ROUND(
			3 * (
			(AVG(unit_price) - PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY unit_price))
			/ STDDEV(unit_price)
				)
			, 2) as unit_price_skew
	FROM public.sales
	WHERE lower(sales.status::text) = 'shipped'
	GROUP BY deal_size
	ORDER BY unit_price_skew DESC
)

SELECT
	deal_size_statistics.*
FROM deal_size_statistics
