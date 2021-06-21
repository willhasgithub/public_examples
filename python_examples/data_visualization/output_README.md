# William Wisener -- Output Instructions

### Determine the state of your own machine
* If not already created, establish a blank local instance of a Postgres SQL instance. 
* Please note, that it may be easiest to run it in a Docker container using this guide  https://dev.to/andre347/how-to-easily-create-a-postgres-database-in-docker-4moj
* The default password to connect to the local instance is `"password": "T@k3H0m3"`.
* This project is run on `Python 3.7`
* Please install that all required python packages on your local interpreter.

### Run the appropriate scripts
1. Begin by connecting to your local instance. Please note, you may need to change the value for `"password"` 
   in the file `docs/db_connection_data.json`. The default value is `"password": "T@k3H0m3"`.
1. Under a blank Postgres SQL instance, please run PG Admin open a tab with the query tool and run the DDL file `scripts/ddl-postgres-db.sql`.
1. After completing step `2`, please run `scripts/load_input_data.py` to load the data from the given CSVs.

## Run
* The SQL scipts for each question are as follows:
   1. `scripts/q1_highest_sales_by_product.sql`
   1. `scripts/q2_sales_price_by_deal_size.sql`
   1. `scripts/q3_popular_products_and_countries_per_region.sql`
* The visualization files are all in HTML form and can be found under the following file names:
  1. `visualization_render_files/rendered_outfiles/q1_visualization_total_revenue_per_product_line.html`
  1. `visualization_render_files/rendered_outfiles/q2_visualization_distribution_unit_price_per_deal_size.html`
  1. `visualization_render_files/rendered_outfiles/q3_visualization_total_revenue_per_region_and_country.html`
  1. `visualization_render_files/rendered_outfiles/q3_visualization_total_revenue_per_region_and_product_line.html`
  1. `visualization_render_files/rendered_outfiles/q3_visualization_us_map_of_total_revenue_per_country.html`
  1. `visualization_render_files/rendered_outfiles/q3_visualization_world_map_of_total_revenue_per_country.html`
* You may also run `visualization_render_files/__init__.py` and the files for each question should render in your browser.
