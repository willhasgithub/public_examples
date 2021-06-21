import pandas as pd
from sqlalchemy.exc import IntegrityError

from scripts.support_methods import get_docs_file, create_db_connection


def list_absolute_path_of_input_files(*args) -> list:
    """
    Takes a list of the input file names located in the docs/ directory
    and returns a list of the absolute paths for those files.

    This ensures that the files can be opened in any environment.

    :param args: a list of the input file names (e.g. "products.csv")
    :return: a list of the absolute paths for input files
    """
    list_input_files = [get_docs_file(input_file_name) for input_file_name in args]
    return list_input_files


if __name__ == "__main__":
    sql_con = create_db_connection()

    list_in_fl_nms = list_absolute_path_of_input_files("products.csv", "customers.csv", "sales.csv")
    for in_fl_nm in list_in_fl_nms:
        table_name = in_fl_nm.stem
        in_df = pd.read_csv(in_fl_nm)
        try:
            in_df.to_sql(name=table_name, con=sql_con, if_exists='append', index=False)
        except IntegrityError as e:
            print(e.statement)
            # if e.orig.find("duplicate key value violates unique constraint") >= 0:
            #     pass
            # else:
            #     print(e)
            continue

    pass
