from scripts.support_methods import get_script_file, create_db_connection, get_docs_file
import pandas as pd
import plotly.express as px


def q1_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    df_product_line = in_df.groupby(['product_line'], sort=True)[['product_line', 'total_dollar_sales']].sum()
    df_product_line = df_product_line.sort_values(by=['total_dollar_sales'], ascending=[False]).reset_index()
    category_order = {"Product Line": list(df_product_line['product_line'])}

    df_plot = in_df[['product_line', 'product_id', 'total_dollar_sales', 'total_quantity_sold']]
    df_plot = df_plot.rename(columns={
        "product_line": "Product Line",
        "product_id": "Product Id",
        "total_dollar_sales": "Revenue in Dollars",
        "total_quantity_sold": "Quantity Sold"
    })

    fig = px.bar(df_plot,
                 x="Product Line", y="Revenue in Dollars", hover_name="Product Id",
                 color="Quantity Sold",
                 title="2003 and 2004 Total Revenue by Product Line including Quantity and Id",
                 color_continuous_scale="Viridis_r", range_color=[550, 900], category_orders=category_order)

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def q2_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    fig = px.histogram(in_df, x="Unit Price", y="Frequency of Deal Size and Unit Price", color="Deal Size",
                       marginal="box",
                       title="Distribution of Unit Price per Deal Size",
                       hover_data=in_df.columns)

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def q3_total_sales_per_product_line_and_region_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    df_plot = in_df.rename(columns={
        "product_line_and_region_total_quantity": "Quantity Sold",
        "product_line": "Product Line",
        "product_line_and_region_total_sales": "Revenue",
        "region": "Region"
    })

    fig = px.bar(df_plot,
                 x="Region", y="Revenue", hover_name="Product Line",
                 color="Quantity Sold",
                 title="Total Revenue by Product Line and Region including quantity sold",
                 color_continuous_scale="Viridis_r",
                 )

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def q3_total_sales_per_country_and_region_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    df_plot = in_df.rename(columns={
        "country_and_region_total_quantity": "Quantity Sold",
        "country_state": "Country State",
        "country_and_region_total_sales": "Revenue",
        "region": "Region"
    })

    fig = px.bar(df_plot,
                 x="Region", y="Revenue", hover_name="Country State",
                 color="Quantity Sold",
                 title="Total Revenue by Country and Region including quantity sold",
                 color_continuous_scale="Viridis_r",
                 )

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def q3_usa_states_map_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    fig = px.choropleth(in_df, locations='country_state', color='country_and_region_total_sales',
                        color_continuous_scale="Viridis_r",
                        locationmode='USA-states',
                        scope="usa",
                        title="US Map for Total Revenue by State",
                        labels={'country_and_region_total_sales': 'Total Sales'}
                        )

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def q3_world_map_render_plot(in_df, show_plot_in_browser=False, output_file_name=None):
    fig = px.choropleth(in_df, locations='country_state', color='country_and_region_total_sales',
                        color_continuous_scale="Viridis_r",
                        title="World Map for Total Revenue by Country",
                        locationmode='country names',
                        labels={'country_and_region_total_sales': 'Total Sales'}
                        )

    if isinstance(output_file_name, str) and output_file_name != '':
        fig.write_html(f"{output_file_name}.html")

    if show_plot_in_browser:
        fig.show()


def main(action_item, engine):
    target_file_name = action_item['sql_visualization_file_name']

    target_file = get_script_file(target_file_name)

    with open(target_file, "r") as in_sql_file:
        in_sql = in_sql_file.read()

    df = pd.read_sql(in_sql, engine)

    function_name = action_item['visualization_function_name']

    arguments_string = ', '.join([f'{key}={val}' for key, val in action_item.items()
                                  if key not in ('visualization_function_name', 'sql_visualization_file_name')])
    eval(f"{function_name}(in_df=df, {arguments_string})")


if __name__ == '__main__':
    eng = create_db_connection()

    action_dict = [
        {
            "sql_visualization_file_name": "vis_q1_highest_sales_by_product.sql",
            "visualization_function_name": "q1_render_plot",
            # "output_file_name": "'rendered_outfiles/q1_visualization_total_revenue_per_product_line'",
            "show_plot_in_browser": True
        },
        {
            "sql_visualization_file_name": "vis_q2_median_sales_price.sql",
            "visualization_function_name": "q2_render_plot",
            # "output_file_name": "'rendered_outfiles/q2_visualization_distribution_unit_price_per_deal_size'",
            "show_plot_in_browser": True
        },
        {
            "sql_visualization_file_name": "vis_q3_total_sales_per_product_line_and_region.sql",
            "visualization_function_name": "q3_total_sales_per_product_line_and_region_render_plot",
            # "output_file_name": "'rendered_outfiles/q3_visualization_total_revenue_per_region_and_product_line'",
            "show_plot_in_browser": True
        },
        {
            "sql_visualization_file_name": "vis_q3_total_sales_per_country_and_region.sql",
            "visualization_function_name": "q3_total_sales_per_country_and_region_render_plot",
            # "output_file_name": "'rendered_outfiles/q3_visualization_total_revenue_per_region_and_country'",
            "show_plot_in_browser": True
        },
        {
            "sql_visualization_file_name": "vis_q3_usa_states_map.sql",
            "visualization_function_name": "q3_usa_states_map_render_plot",
            # "output_file_name": "'rendered_outfiles/q3_visualization_us_map_of_total_revenue_per_country'",
            "show_plot_in_browser": True
        },
        {
            "sql_visualization_file_name": "vis_q3_world_map.sql",
            "visualization_function_name": "q3_world_map_render_plot",
            # "output_file_name": "'rendered_outfiles/q3_visualization_world_map_of_total_revenue_per_country'",
            "show_plot_in_browser": True
        }
    ]

    for action in action_dict:
        main(action_item=action, engine=eng)

    pass
